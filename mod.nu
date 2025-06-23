
# VictorMono NF, Bold Italic
#EnvyCoderR Nerd Font Mono, Bold
use ../nuLlama/coins
use ../nuLlama/tvl
use ../nuLlama/volumes
use ../nuLlama/stablecoins

export def main [crypto: string] { 
    print "Oh hi mark!"
    getChain  $crypto
}

export def getChain [crypto: string] { 
   
let volume_data = volumes dexsByChain $crypto 
let fee_data = http get $"https://api.llama.fi/overview/fees/($crypto)" | select total24h total7d total30d change_1d change_7d change_1m
let tvl_data = tvl chainHistorical $crypto | last 30
{
        name: $crypto, 
        symbol: (coins currentPrices $crypto | values | first  |  values | get symbol | first),
        current_price:  (coins currentPrices $crypto | values | first  |  values | get price | first),
        percentage_change: (coins percentage $crypto | values | first  |  values | first),
        historical_tvl: (tvl chainHistorical $crypto | last 30),
        current_tvl: (tvl chainHistorical $crypto | last | get tvl),
        volume: {24h: $volume_data.total24h, 7d: $volume_data.total7d, 30d: $volume_data.total30d},
        volume_change: {24h: $volume_data.change_1d, 7d: $volume_data.change_7d, 30d: $volume_data.change_1m}
        historical_tvl: $tvl_data,
        current_tvl: ($tvl_data | last | get tvl),
        volume: {24h: $volume_data.total24h, 7d: $volume_data.total7d, 30d: $volume_data.total30d},
        volume_change: {24h: $volume_data.change_1d, 7d: $volume_data.change_7d, 30d: $volume_data.change_1m},
        fees: {24h: $fee_data.total24h, 7d: $fee_data.total7d, 30d: $fee_data.total30d},
        fees_change: {24h: $fee_data.change_1d, 7d: $fee_data.change_7d, 30d: $fee_data.change_1m},
        #This is just tether mcap for now, not total. 
        historical_stableMcap: (stablecoins chainHistory $crypto 1 | last 10 
                                |get totalMintedUsd |get peggedUSD),
        stablecoinMcap: (stablecoins chainHistory $crypto 1 | last | get totalMintedUsd |get peggedUSD)
    }
}
# useful flow for comparing chains: [$sol, $eth] | fabric summarize | dont-think | glow
#TODO: make getChain work with bitcoin (errors getting stablecoin mcap)
#TODO: Write a custom fabric prompt. Summarize is already fairly good. 


#TODO: https://stablecoins.llama.fi/stablecoins?includePrices=true I didn't include this endpoint in nuLlama/stablecoins,
#    but it might be what i need for the current stablecoin mcap 

# chain struct { 
#     name: string x 
#     symbol: string
#     address: string
#     tvl : float x 
#     volume : float x 
#     fees : float x 
#     stablecoins : float x   
#     tvl_change : float x 
#     volume_change : float x
#     fees_change : float x
#     logo: string x 
#     current_price: float x 
#     percentage_change: float x 
# }

 