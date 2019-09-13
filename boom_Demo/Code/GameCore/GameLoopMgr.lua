require("Code/Map/MapMgr")
require("Code/Utils")
require("Code/Graphic/Camera")
require("Code/Resource/ResourceMgr")
require("Code/DesignerConfigs/DesignerConf")
require("Code/Map/MapUtils")


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
    -- print(destoryCounter)
    if destoryCounter <= 0 then
        destoryCounter = destoryInterval
        for i = 0, destoryCount - 1 do
            mapData[nextDestoryPosX[i + 1]][nextDestoryPosY[i + 1]] = nil
        end
        nextDestoryPosX = nil
        nextDestoryPosY = nil
    elseif destoryCounter <= 1 then
        drawDestoryCursorSwch = true
    elseif destoryCounter <= 2 then
        -- print("draw now")
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

    local cpuBlock=processorCoreID
    local serverBlock=serverCoreID
    local blockerBlock=PCBCoreID

    repeat
        -- entry block
        randCore = love.math.random(getTotalCoreCount()) - 1
        --could not prevent from buying multiple cpu/server, so not allow buying CPU/SERVER
    until ((randCore ~= cpuBlock) and (randCore ~= serverBlock)and (randCore ~= blockerBlock))
    -- local randCore = 0

    local sideData = Core2SideMap[randCore + 1]

    local randSideA = 0
    local randSideB = 0
    local randSideC = 0
    local randSideD = 0

    repeat
        -- entry block
        randSideA = love.math.random(getTotalSideCount()) - 1
    until (sideData[randSideA + 1] ~= -1)
    repeat
        -- entry block
        randSideB = love.math.random(getTotalSideCount()) - 1
    until (sideData[randSideB + 1] ~= -1)
    repeat
        -- entry block
        randSideC = love.math.random(getTotalSideCount()) - 1
    until (sideData[randSideC + 1] ~= -1)
    repeat
        -- entry block
        randSideD = love.math.random(getTotalSideCount()) - 1
    until (sideData[randSideD + 1] ~= -1)

    local hasNecessarySide = false

    for i, data in pairs(sideData) do
        -- if randCore == 0 then print(data) end
        if data == 1 then
            hasNecessarySide = hasNecessarySide or (randSideA == (i - 1))
            hasNecessarySide = hasNecessarySide or (randSideB == (i - 1))
            hasNecessarySide = hasNecessarySide or (randSideC == (i - 1))
            hasNecessarySide = hasNecessarySide or (randSideD == (i - 1))
            if not hasNecessarySide then
                -- print(data)
                -- print(i)
                -- just settle for now.
                randSideA = (i - 1)
            end
        end
    end
    resID = 10000 * randCore + 1000 * randSideA + 100 * randSideB + 10 *
                randSideC + randSideD
    return resID
end

function caculateTilePrice(id)
    local corePrice = getPriceByCore(extractDataByPtr(id, 0))
    local sidePrice = 0
    sidePrice = sidePrice + getPriceBySide(extractDataByPtr(id, 1))
    sidePrice = sidePrice + getPriceBySide(extractDataByPtr(id, 2))
    sidePrice = sidePrice + getPriceBySide(extractDataByPtr(id, 3))
    sidePrice = sidePrice + getPriceBySide(extractDataByPtr(id, 4))
    return corePrice + sidePrice
end

function refreshShop()
    shopContent = {}
    shopContent[1] = genShopTile()
    shopContent[2] = genShopTile()
    shopContent[3] = genShopTile()
    shopContent[4] = genShopTile()

    shopPrice = {}
    shopPrice[1] = caculateTilePrice(shopContent[1], 0)
    shopPrice[2] = caculateTilePrice(shopContent[2], 0)
    shopPrice[3] = caculateTilePrice(shopContent[3], 0)
    shopPrice[4] = caculateTilePrice(shopContent[4], 0)
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

    animationFCounter = math.floor(frameCounter/2.0)
    
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
