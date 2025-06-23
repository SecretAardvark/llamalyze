#TODO: Test Modules for fees/stablecoins/tvl/volumes modules
# VictorMono NF, Bold Italic
#EnvyCoderR Nerd Font Mono, Bold
use ../nuLlama/coins
use ../nuLlama/tvl
use ../nuLlama/volumes

export def main [crypto: string] {
    # let name = $crypto 
    # let current_price = coins currentPrices $crypto | values | first  |  values | get price | first
    # let percentage_change = coins percentage $crypto | values | first  |  values | first
    # let historical_tvl = tvl chainHistorical $crypto | last 10
    # let current_tvl = $historical_tvl | last | get tvl     #$current_price | values | first  |  values | get price | print
    # let volume_data = volumes dexsByChain $crypto 
    # let volume = { 24h: $volume_data.total24h, 7d: $volume_data.total7d, 30d: $volume_data.total30d }
    # #let first_price = coins firstPrices $crypto | values | first  |  values | get price
    # #let historical_price = coins historicalPrices 1718131200 $crypto | values | first  |  values | get price
    # print $current_price
    # #print $first_price
    # #print $historical_price
    # # print $percentage_change
    # # print $historical_tvl
    # # print $current_tvl
    # # print $name
    # # print $volume
    # { 
    # name: $name, 
    # current_price: $current_price, 
    # percentage_change: $percentage_change, 
    # historical_tvl: $historical_tvl, 
    # current_tvl: $current_tvl, 
    # volume: $volume 
    # }
    print "Oh hi mark!"
    getChain  $crypto
}

export def getChain [crypto: string] { 
   let volume_data = volumes dexsByChain $crypto 
    {
        name: $crypto, 
        current_price:  (coins currentPrices $crypto | values | first  |  values | get price | first),
        percentage_change: (coins percentage $crypto | values | first  |  values | first),
        historical_tvl: (tvl chainHistorical $crypto | last 30),
        current_tvl: (tvl chainHistorical $crypto | last | get tvl),
        volume: {24h: $volume_data.total24h, 7d: $volume_data.total7d, 30d: $volume_data.total30d},
        volume_change: {24h: $volume_data.change_1d, 7d: $volume_data.change_7d, 30d: $volume_data.change_1m}
    }
}
# useful flow for comparing chains: [$sol, $eth] | fabric summarize | dont-think | glow
#TODO: make getChain work with bitcoin (errors getting stablecoin mcap)
#TODO: Write a custom fabric prompt. Summarize is already fairly good. 


# export def "main getChain" [crypto: string] { 
#     getChain $crypto
# }

# def getChain [crypto: string] { 
#     mut chainData = []

#     let 
# }


# chain struct { 
#     name: string
#     symbol: string
#     address: string
#     tvl : float
#     volume : float
#     fees : float
#     stablecoins : float
#     tvl_change : float
#     volume_change : float
#     fees_change : float
#     decimals: int
#     logo: string
#     current_price: float
#     percentage_change: float
# }

 