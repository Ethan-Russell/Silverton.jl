module Silverton

using DataStructures

export
    SilvertonGame,
    advance!

mutable struct SilvertonGame
    round
    prices
    SilvertonGame() = new(1, InitialPrices())
end

InitialPrices() = OrderedDict(
    Gold()=>5,
    Copper()=>5,
    Silver()=>6,
    Lumber{:denver}()=>5,
    Lumber{:slc}()=>6,
    Lumber{:pueblo}()=>5,
    Lumber{:santafe}()=>4,
    Lumber{:elpaso}()=>5,
    Coal{:denver}()=>6,
    Coal{:slc}()=>5,
    Coal{:pueblo}()=>4,
    Coal{:santafe}()=>5,
    Coal{:elpaso}()=>6
)

global IDN = [0,0,1,1,2,2,2,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,7]

struct Gold end
struct Copper end
struct Silver end
struct Lumber{T} end
struct Coal{T} end

limits(::Gold)             = (1, 10)
limits(::Copper)           = (1, 10)
limits(::Silver)           = (1, 10)
limits(::Lumber{:denver})  = (2, 8)
limits(::Lumber{:slc})     = (4, 10)
limits(::Lumber{:pueblo})  = (2,8)
limits(::Lumber{:santafe}) = (1,7)
limits(::Lumber{:elpaso})  = (2, 8)
limits(::Coal{:denver})    = (3, 10)
limits(::Coal{:slc})       = (1, 8)
limits(::Coal{:pueblo})    = (1, 7)
limits(::Coal{:santafe})   = (2, 9)
limits(::Coal{:elpaso})    = (3, 10)




advance!(game::SilvertonGame) = begin
    for commodity in keys(game.prices)
        update!(game, commodity)
    end
    game.round += 1
    println("Advance token to turn $(game.round)")
    for commodity in keys(game.prices)
        println("    Price for $commodity = $(price(commodity, game.prices[commodity]))")
    end
end

update!(game::SilvertonGame, commodity) = begin
    println("Number of $commodity sold?")
    sold = tryparse(Int, readline())
    sold == nothing && (sold=0)
    curprice = game.prices[commodity]
    idn = getidn(game)
    lims = limits(commodity)
    newprice = curprice + roll(commodity, sold, idn)
    newprice = max(min(newprice, lims[2]), lims[1])
    game.prices[commodity] = newprice
end

getidn(game::SilvertonGame) = begin
    global IDN
    return IDN[game.round]
end

roll(commodity::Gold, sold::Int, idn::Int) = lookup(commodity, rand(1:6) + sold)
roll(commodity::Copper, sold::Int, idn::Int) = lookup(commodity, rand(1:6) + sold)
roll(commodity::Silver, sold::Int, idn::Int) = lookup(commodity, rand(1:6)+rand(1:6) + sold - idn)
roll(commodity::Lumber, sold::Int, idn::Int) = lookup(commodity, rand(1:6)+rand(1:6) + sold - idn)
roll(commodity::Coal{T}, sold::Int, idn::Int) where T = begin
    if T==:denver || T==:slc
        return lookup(commodity, rand(1:6) + rand(1:6) + round(sold/2) - idn)
    else
        return lookup(commodity, rand(1:6) + rand(1:6) + sold - idn)
    end
end

lookup(::Gold, n) = begin
    n>7 && return -2
    n>=6 && return -1
    n>=4 && return 0
    n>=2 && return 1
    return 2
end

lookup(::Copper, n) = begin
    n>11 && return -4
    n>=10 && return -3
    n>=8 && return -2
    n>=6 && return -1
    n>=4 && return 0
    n>=3 && return 1
    n>=2 && return 2
    return 3
end

lookup(::Silver, n) = begin
    n>15 && return -7
    n==15 && return -6
    n>=14 && return -5
    n>=13 && return -4
    n>=12 && return -3
    n>=10 && return -2
    n>=8 && return -1
    n>=6 && return 0
    n>=4 && return 1
    n>=3 && return 2
    n>=2 && return 3
    n>=1 && return 4
    return 5
end

lookup(::Lumber, n) = begin
    n>12 && return -4
    n>=11 && return -3
    n>=9 && return -2
    n>=7 && return -1
    n>=6 && return 0
    n>=4 && return 1
    n>=2 && return 2
    return 3
end

lookup(::Coal, n) = begin
    n>12 && return -3
    n>=11 && return -2
    n>=9 && return -1
    n>=6 && return 0
    n>=4 && return 1
    n>=2 && return 2
    return 3
end

price(::Gold, i::Int) = [150, 175, 200, 225, 250, 250, 275, 300, 325, 350][i]
price(::Copper, i::Int) = [100, 120, 140, 160, 200, 200, 240, 280, 320, 400][i]
price(::Silver, i::Int) = [100, 120, 160, 180, 200, 200, 200, 240, 300, 400][i]
price(::Lumber, i::Int) = [30,  40,  60,  80,  100, 120, 160, 200, 240, 300][i]
price(::Coal, i::Int) = [20,  20,  30,  40,  60,  60,  80,  100, 120, 140][i]

end # module