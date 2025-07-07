# VictorMono NF, Bold Italic
#EnvyCoderR Nerd Font Mono, Bold
use ../nuLlama/coins
use ../nuLlama/tvl
use ../nuLlama/volumes
use ../nuLlama/stablecoins

export def analyze [crypto?: string] { 
    #multi-chain flow
    if ($crypto | is-empty) {
        let chains = [
        "ethereum",
        "solana",
        #"avax",
        "base",
        "arbitrum",
        #"optimism",
       # "zksync",
        "tron",
        "near",
    ]
    let chain_data = $chains | par-each {|chain|
        getChain $chain
    }
    print $chain_data
    print "analyzing chain data..."
    $chain_data | to json | fabric analyze_crypto | dont-think | glow
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
            print $chain_data
            print "analyzing chain data..."
            $chain_data | to json | fabric analyze_crypto | dont-think | glow
        } else {
            getChain $crypto | to json | fabric analyze_crypto | dont-think | glow
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







