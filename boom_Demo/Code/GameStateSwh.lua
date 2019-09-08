require("Code/GameCore/InputMgr")
require("Code/Graphic/GraphicMgr")
require("Code/GameCore/GameLoopMgr")
require("Code/GameCore/ReloadScreenMgr")

function mainResetScreenSwitch(GameState)
    local mainResetScreenSwch = {
        [1] = function()
            reloadScreenMainMenu()
            -- print("DrawMenu")
        end,
        [2] = function()
            reloadScreenPlayingGame()
            -- print("Playing")
        end,
        [3] = function()
            reloadScreenRegisterScore()
            -- print("RScore")
        end,
        [4] = function()
            reloadScreenViewScore()
            -- print("VScore")
        end
    }
    return mainResetScreenSwch[GameState + 1]()
end

function mainUpdateInputSwitch(GameState, key)
    local mainInputUpdateSwch = {
        [1] = function(key)
            updateInputMainMenu(key)
            -- print("DrawMenu")
        end,
        [2] = function(key)
            updateInputPlayingGame(key)
            -- print("Playing")
        end,
        [3] = function(key)
            updateInputRegisterScore(key)
            -- print("RScore")
        end,
        [4] = function(key)
            updateInputViewScore(key)
            -- print("VScore")
        end
    }
    return mainInputUpdateSwch[GameState + 1](key)
end

function mainGameLoopSwitch(GameState, dt)
    local mainGameLoopSwch = {
        [1] = function(dt)
            GameLoopUpdateMainMenu(dt)
            -- print("DrawMenu")
        end,
        [2] = function(dt)
            GameLoopUpdatePlayingGame(dt)
            -- print("Playing")
        end,
        [3] = function(dt)
            GameLoopUpdateRegisterScore(dt)
            -- print("RScore")
        end,
        [4] = function(dt)
            GameLoopUpdateViewScore(dt)
            -- print("VScore")
        end
    }
    return mainGameLoopSwch[GameState + 1](dt)
end

function mainDrawingSwitch(GameState)
    local mainDrawingSwch = {
        [1] = function()
            drawMainMenu()
            -- print("DrawMenu")
        end,
        [2] = function()
            drawPlayingGame()
            -- print("Playing")
        end,
        [3] = function()
            drawRegisterScore()
            -- print("RScore")
        end,
        [4] = function()
            drawViewScore()
            -- print("VScore")
        end
    }
    return mainDrawingSwch[GameState + 1]()
end
