# VictorMono NF, Bold Italic
#EnvyCoderR Nerd Font Mono, Bold
use ../nuLlama/coins
use ../nuLlama/tvl
use ../nuLlama/volumes
use ../nuLlama/stablecoins

export def analyze [crypto?: string] { 
    open ("~/dev/nushell/llamalyze/.env" | path expand) | from toml | load-env
    let today = (date now | format date "%m-%d-%Y")
    let vault_path =  if ($"($env.VAULT_PATH)/($today)/" | path exists) {
        $"($env.VAULT_PATH)/($today)/"
    } else {
        mkdir $"($env.VAULT_PATH)/($today)"
        $"($env.VAULT_PATH)/($today)"
    }
    #multi-chain flow
    if ($crypto | is-empty) {
        let chains = [
        "ethereum",
        "solana",
       # "avalanche-2",
        "base",
        "arbitrum",
        #"optimism",
       # "zksync",
        "tron",
        #"the-open-network",
        "near",
        #"sonic-3",
        #"unichain",
        #"osmosis", <- this one doesnt have a totalusd for some reason, will probably work otherwise.
       # "aurora-near",
        #"cardano",
    ]
    let fear_and_greed = http get https://api.alternative.me/fng/?limit=1 
    let chain_data = $chains | par-each {|chain|
        getChain $chain
    }
    let payload = {
        chain_data: $chain_data,
        fear_and_greed: {value: $fear_and_greed.data.value, rating: $fear_and_greed.data.value_classification}
    }
    print "analyzing chain data..."
    $payload | to json | fabric analyze_crypto | dont-think | save -f $"($vault_path)Crypto Market Onchain Overview-(date now | format date "%m-%d-%Y").md" | glow
    } else {
        #single crypto flow
        if ($crypto == "ethereum") {
            let chains = [
                "ethereum",
                "arbitrum",
                "base",
            ]
            let chain_data = $chains | par-each {|chain|
                getChain $chain
            }
            #print $chain_data
            #print "analyzing chain data..."
            #print ( $"($vault_path)($crypto | str capitalize) Onchain Overview-(date now | format date "%m-%d-%Y").md" | path exists)
            $chain_data | to json | fabric analyze_crypto | dont-think | save -f $"($vault_path)($crypto | str capitalize) Onchain Overview-(date now | format date "%m-%d-%Y").md" | cd $"($vault_path)" | glow
        } else {
            getChain $crypto | to json | fabric analyze_crypto | dont-think | save -f $"($vault_path)($crypto | str capitalize) Onchain Overview-(date now | format date "%m-%d-%Y").md" | cd $"($vault_path)"       
        }
    }
}


export def getChain [crypto: string] { 
   
let volume_data = volumes dexsByChain $crypto 
let fee_data = http get $"https://api.llama.fi/overview/fees/($crypto)" | select total24h total7d total30d change_1d change_7d change_1m
let tvl_data = tvl chainHistorical $crypto | last 30
{
        name: $crypto, 
        symbol: (
            (coins currentPrices $crypto | values | first | values | get symbol | first) | default ""
        ),
        current_price:  (coins currentPrices $crypto | values | first  |  values | get price | first),
        percentage_change: (coins percentage $crypto | values | first  |  values | first),
        historical_tvl: $tvl_data,
        current_tvl: ($tvl_data | last | get tvl),
        volume: {24h: $volume_data.total24h, 7d: $volume_data.total7d, 30d: $volume_data.total30d}, volume_change: {24h: $volume_data.change_1d, 7d: $volume_data.change_7d, 30d: $volume_data.change_1m},
        fees: {24h: $fee_data.total24h, 7d: $fee_data.total7d, 30d: $fee_data.total30d},
        fees_change: {24h: $fee_data.change_1d, 7d: $fee_data.change_7d, 30d: $fee_data.change_1m},
        
        historical_stableMcap: (stablecoins chainHistory $crypto 1 | last 10 
                                | get totalMintedUsd |get peggedUSD),
        stablecoinMcap: (stablecoins all | get chains | where gecko_id == $crypto | get totalCirculatingUSD | get peggedUSD)
    }
}







#TODO: add more chains, figure out why the coingecko api is not working for some chains.
#TODO: figure out why osmosis is a special snowflake
