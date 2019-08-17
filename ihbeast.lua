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
    if arenaRank > 3 then
        stateMachine:click("btn_arena_top_.png")
        wait(5)
    else
        wait(10 * 60) --10 minutes delay between searches
        stateMachine:goto("home")
    end
    return stateMachine:waitKnownState(10)
end)

stateMachine:register("choose_rival", "heroes_formation", function ()
    local found = false
    local n = 0
    while not found and n < 50 do
        n = n + 1
        if math.fmod(n, 5) == 0 then wait(60) end -- 1 minute pause every 5 searches
        if math.fmod(n, 13) == 0 then wait(10 * 60) end -- 10 minute pause every 13 searches
        if math.fmod(n, 29) == 0 then wait(30 * 60) end -- 30 minute pause every 29 searches
        if not found then found = stateMachine:find("btn_cankill_1_.png") end -- vn rex dancing
        if not found then found = stateMachine:find("btn_cankill_2_.png") end -- hut can
        if not found then found = stateMachine:find("btn_cankill_3_.png") end -- mad 1r
        if not found then found = stateMachine:find("btn_cankill_4_.png") end -- rem me
        if found then
            click(found:offset(923 - 351, 0)) -- attack
        else
            stateMachine:click("btn_choose_rival_.png") -- refresh
        end
    end
    return stateMachine:waitKnownState(10)
end)

-- main program
local alive = true
while alive do
    alive = stateMachine:goto("arena_top", "choose_rival", "heroes_formation")
end
--playMusic("ended.mp3", false)