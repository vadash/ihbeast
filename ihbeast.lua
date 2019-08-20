-- global variables
ROOT = scriptPath()
AUTO_IMAGE_PATH = ROOT.."image" -- path with auto generated images
MANUAL_IMAGE_PATH = ROOT.."manual" -- manual captured stuff
HIGHLIGHT = false

-- initializing
setImagePath(AUTO_IMAGE_PATH)
dofile(ROOT.."stateMachine.lua")

stateMachine:register("arena_top", "choose_rival", function ()
    local rankPosition = Region(1025, 191, 73, 28)
    setImagePath(MANUAL_IMAGE_PATH)
    local arenaRank = numberOCR(rankPosition, "arena")
    setImagePath(AUTO_IMAGE_PATH)
    stateMachine:log("arenaRank = "..arenaRank)
    if arenaRank > 2 then
        stateMachine:click("btn_arena_top_.png")
        wait(5)
    else
        wait(10 * 60) --5 minutes delay between searches
        stateMachine:goto("home")
    end
    return stateMachine:waitKnownState(10)
end)

found = false
stateMachine:register("choose_rival", "heroes_formation", function ()
    found = false
    local n = 0
    while found == nil or found == false do
        n = n + 1
        if n >= 50 then break end
        IsGoodArenaTarget("btn_cankill_1_.png") -- vn rex dancing
        --IsGoodArenaTarget("btn_cankill_2_.png") -- hut can
        --IsGoodArenaTarget("btn_cankill_3_.png") -- mad 1r
        --IsGoodArenaTarget("btn_cankill_4_.png") -- rem me
        --IsGoodArenaTarget("btn_cankill_5_.png") -- melbs
        --IsGoodArenaTarget("btn_cankill_6_.png") -- vothan
        --IsGoodArenaTarget("btn_cankill_7_.png") -- ons kharma100
        --IsGoodArenaTarget("btn_cankill_8_.png") --wins
        --IsGoodArenaTarget("btn_cankill_9_.png") --ons
        --IsGoodArenaTarget("btn_cankill_10_.png") --chefster
        --IsGoodArenaTarget("btn_cankill_11_.png") --mad bones
        if found == nil or found == false then
            stateMachine:click("btn_choose_rival_.png") -- refresh
        else
            click(found:offset(923 - 351, 0)) -- attack
        end
        wait(2)
    end
    if n >= 50 then
        stateMachine:goto("home")
    else
        return stateMachine:waitKnownState(10)
    end
end)

function IsGoodArenaTarget(target)
    if found == nil or found == false then
        found = stateMachine:find(target)
    end
    return found
end

-- main program
local alive = true
while alive do
    alive = stateMachine:goto("arena_top", "choose_rival", "heroes_formation")
end
playMusic("ended.mp3", false)