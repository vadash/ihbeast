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
    if arenaRank > 1 then
        stateMachine:click("btn_arena_top_.png")
        wait(5)
    else
        wait(5 * 60) --5 minutes delay between searches
        stateMachine:goto("home")
    end
    return stateMachine:waitKnownState(10)
end)

stateMachine:register("choose_rival", "heroes_formation", function ()
    local found = false
    local n = 0
    while not found and n < 50 do
        n = n + 1
        found = IsGoodArenaTarget(found, "btn_cankill_1_.png") -- vn rex dancing
        --IsGoodArenaTarget(found, "btn_cankill_2_.png") -- hut can
        --IsGoodArenaTarget(found, "btn_cankill_3_.png") -- mad 1r
        --IsGoodArenaTarget(found, "btn_cankill_4_.png") -- rem me
        --IsGoodArenaTarget(found, "btn_cankill_5_.png") -- melbs
        --IsGoodArenaTarget(found, "btn_cankill_6_.png") -- vothan
        if found then
            click(found:offset(923 - 351, 0)) -- attack
        else
            stateMachine:click("btn_choose_rival_.png") -- refresh
        end
    end
    if n >= 50 then
        stateMachine:goto("home")
    else
        return stateMachine:waitKnownState(10)
    end
end)

local function isempty(s)
    return s == nil or s == ''
end

function IsGoodArenaTarget(found, target)
    if found == false then return end
    found = stateMachine:find(target)
    if found ~= nil and found.y ~= nil and found.y > 500 then
        found = false
    end
    return found
end

-- main program
local alive = true
while alive do
    alive = stateMachine:goto("arena_top", "choose_rival", "heroes_formation")
end
playMusic("ended.mp3", false)