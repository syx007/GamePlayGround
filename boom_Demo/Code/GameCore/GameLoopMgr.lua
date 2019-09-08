require("Code/Map/MapMgr")
require("Code/Utils")
require("Code/Graphic/Camera")

function changeGameStateTo(stateID)
    gameState = stateID
    mainResetScreenSwitch(stateID)
end

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
            changeGameStateTo(1)
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

function doDestory()
    -- infact destory after actual moving, so player able to move tile away.
    destoryCounter = destoryCounter - 1
    print(destoryCounter)
    if destoryCounter <= 0 then
        destoryCounter = destoryInterval
        for i = 0, destoryCount - 1 do
            mapData[nextDestoryPosX[i + 1]][nextDestoryPosY[i + 1]] = nil
        end
        nextDestoryPosX = nil
        nextDestoryPosY = nil
    elseif destoryCounter <= 1 then
        print("draw now")
        drawDestoryCursorSwch = true
        nextDestoryPosX = {}
        nextDestoryPosY = {}
        for i = 0, destoryCount - 1 do
            -- should check no same
            local ranX = 0.0
            local ranY = 0.0
            repeat
                ranX = love.math.random(mapLineCount)
                ranY = love.math.random(mapLineCount)
                local xIdx = arrayFind(nextDestoryPosX, ranX)
                local yIdx = arrayFind(nextDestoryPosY, ranY)
                local resOk = not ((yIdx == xIdx) and
                                  (not ((xIdx == -1) and (yIdx == -1))))
            until (resOk)

            nextDestoryPosX[i + 1] = ranX
            nextDestoryPosY[i + 1] = ranY
        end
    end
end

function PerStepUpdate()
    stepDrawSwch = true
    stepCounter = stepCounter - 1
    totalCash = totalCash + (totalIncome - totalCost)
    doDestory()
end

function GameLoopUpdatePlayingGame(dt)
    local actionRec = cursor.action
    t=t+1
    cellSize=baseCellSize*ZoomFactor
    MoveCamera(SelectedMode,dt)
    ZoomCamera(SelectedMode,dt)
    updateTileMap_Cursor()
    updateScore()
    local tragetPosX = cursor.cx + cursor.dx
    local tragetPosY = cursor.cy + cursor.dy
    -- cursor and map coodinate and +1 +1 offset
    if isTargetMovable_Cursor(tragetPosX+1, tragetPosY+1) then
        cursor.cx = tragetPosX
        cursor.cy = tragetPosY
        -- currently rotating doesn't count as step
        -- and only success move tile count
        if (actionRec ~= 0) then
            if (cursor.dx ~= 0) or (cursor.dy ~= 0) then
                stepDrawSwch = false
                drawDestoryCursorSwch = false
                PerStepUpdate()
            end
        end
    end
    cursor.dx = 0
    cursor.dy = 0

    if stepCounter <= 0 then
        -- Gameplay End
        changeGameStateTo(0) -- current return to main menu
    end
end
