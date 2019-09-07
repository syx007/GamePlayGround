require("Code/Map/MapMgr")
require("Code/Utils")

function GameLoopUpdateMainMenu(dt)
    local mainMenuEntryCount = 2
    mmCursor.x = mmCursor.x + mmCursor.dx
    -- mmCursor.x = mmCursor.x % mainMenuEntryCount
    mmCursor.x = mathClamp(mmCursor.x, 0, mainMenuEntryCount - 1)
    mmCursor.dx = 0
    if mmCursor.action == 1 then
        mmCursor.action = 0
        if mmCursor.x == 0 then
            -- Entry Block
            gameState = 1
        end
    end
    -- print(mmCursor.x)
end
function GameLoopUpdateRegisterScore(dt)
    -- TODO
end
function GameLoopUpdateViewScore(dt)
    -- TODO
end

function GameLoopUpdatePlayingGame(dt)
    updateTileMap_Cursor()
    updateScore()
    local tragetPosX = cursor.cx + cursor.dx
    local tragetPosY = cursor.cy + cursor.dy
    -- cursor and map coodinate and +1 +1 offset
    if isTargetMovable_Cursor(tragetPosX + 1, tragetPosY + 1) then
        cursor.cx = tragetPosX
        cursor.cy = tragetPosY
    end
    cursor.dx = 0
    cursor.dy = 0
end
