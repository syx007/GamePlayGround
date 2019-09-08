require("Code/Map/MapMgr")
require("Code/Utils")
require("Code/Graphic/Camera")
require("Code/Resource/ResourceMgr")
require("Code/DesignerConfigs/DesignerConf")

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

function genShopTile()
    -- this ID should comply excel sheet or change Core2SideMap.map file
    -- this indeed should comply excel sheet
    -- print(Core2SideMap[1][1])
    local resID = 0
    local randCore = 0

    repeat
        -- entry block
        randCore = love.math.random(getTotalCoreCount()) - 1
    until ((randCore ~= 2) and (randCore ~= 5) and (randCore ~= 3))

    local randSideA = love.math.random(getTotalSideCount()) - 1
    local randSideB = love.math.random(getTotalSideCount()) - 1
    local randSideC = love.math.random(getTotalSideCount()) - 1
    local randSideD = love.math.random(getTotalSideCount()) - 1

    -- randCore should not get 2,5--should implement bridge
    -- could allow play buy 2 or 5 is 2 or 5 destoryed

    if randCore == 0 then
        -- should not clamp but reset
        repeat
            -- entry block
            randSideA = love.math.random(getTotalSideCount()) - 1
        until (randSideA ~= 3)
        repeat
            -- entry block
            randSideB = love.math.random(getTotalSideCount()) - 1
        until (randSideB ~= 3)
        repeat
            -- entry block
            randSideC = love.math.random(getTotalSideCount()) - 1
        until (randSideC ~= 3)
        repeat
            -- entry block
            randSideD = love.math.random(getTotalSideCount()) - 1
        until (randSideD ~= 3)
    end
    resID = 10000 * randCore + 1000 * randSideA + 100 * randSideB + 10 *
                randSideC + randSideD
    -- print(resID)
    return resID
end

function refreshShop()
    shopContent = {}
    shopContent[1] = genShopTile()
    shopContent[2] = genShopTile()
    shopContent[3] = genShopTile()
    shopContent[4] = genShopTile()

    shopPrice = {}
    shopPrice[1] = getCostByID(extractDataByPtr(shopContent[1], 0))
    shopPrice[2] = getCostByID(extractDataByPtr(shopContent[2], 0))
    shopPrice[3] = getCostByID(extractDataByPtr(shopContent[3], 0))
    shopPrice[4] = getCostByID(extractDataByPtr(shopContent[4], 0))
end

function PerStepUpdate()
    stepDrawSwch = true
    stepCounter = stepCounter - 1
    totalCash = totalCash + (totalIncome - totalCost)
    doDestory()
    refreshShop()
end

function GameLoopUpdatePlayingGame(dt)
    local actionRec = cursor.action
    t = t + 1
    cellSize = baseCellSize * ZoomFactor
    MoveCamera(SelectedMode, dt)
    ZoomCamera(SelectedMode, dt)
    updateTileMap_Cursor()
    updateScore()
    local tragetPosX = cursor.cx + cursor.dx
    local tragetPosY = cursor.cy + cursor.dy
    -- cursor and map coodinate and +1 +1 offset
    if isTargetMovable_Cursor(tragetPosX + 1, tragetPosY + 1) then
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

    hold_buying = false
    if love.keyboard.isDown("i") or love.keyboard.isDown("s") then
        hold_buying = true
    end

    local pendingGoods = nil
    if buying_ptr > 0 then
        if totalCash >= shopPrice[buying_ptr] then
            if shopContent[buying_ptr] ~= nil then
                totalCash = totalCash - shopPrice[buying_ptr]
                pendingGoods = shopContent[buying_ptr]
                shopContent[buying_ptr] = nil
                shopPrice[buying_ptr] = 0
            else
                -- no goods
            end
        else
            -- no cash
        end
    end

    if pendingGoods ~= nil then
        -- deliver good
        local ranX = 0.0
        local ranY = 0.0
        repeat
            ranX = love.math.random(mapLineCount)
            ranY = love.math.random(mapLineCount)
        until (mapData[ranX][ranY] == nil)
        mapData[ranX][ranY] = BlankTile()
        mapData[ranX][ranY].id = pendingGoods
    end

    -- TODO also check game end by cash
    if totalCash < 0 then
        -- Gameplay End by no cash
        changeGameStateTo(0) -- current return to main menu
    end

    if stepCounter <= 0 then
        -- Gameplay End by no time
        changeGameStateTo(0) -- current return to main menu
    end
end
