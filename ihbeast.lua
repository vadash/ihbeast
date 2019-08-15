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
    stateMachine:log(arenaRank)
    return stateMachine:waitKnownState(10)
end)

stateMachine:register("choose_rival", "heroes_formation", function ()
    stateMachine:log("not implemented #1")
    return stateMachine:waitKnownState(10)
end)

-- main program
local alive = true
while alive do
    local starterState = stateMachine:getState()
    alive = stateMachine:goto("arena_top", "choose_rival", "heroes_formation")
end
--playMusic("ended.mp3", false)