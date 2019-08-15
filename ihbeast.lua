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
        wait(10 * 60) --10 minutes delay between searches
        stateMachine:goto("home")
    end
    return stateMachine:waitKnownState(10)
end)

stateMachine:register("choose_rival", "heroes_formation", function ()
    stateMachine:log("not implemented #1")
    local found = false
    if not found then found = stateMachine:find("btn_cankill_1_.png") end -- vn rex dancing
    if not found then found = stateMachine:find("btn_cankill_2_.png") end -- hut can
    if not found then found = stateMachine:find("btn_cankill_3_.png") end -- mad 1r
    if found then
        click(found:offset(923 - 351, 0))
    end
    if not found then stateMachine:click("btn_choose_rival_.png") end -- refresh
    return stateMachine:waitKnownState(10)
end)

-- main program
local alive = true
while alive do
    alive = stateMachine:goto("arena_top", "choose_rival", "heroes_formation")
end
--playMusic("ended.mp3", false)