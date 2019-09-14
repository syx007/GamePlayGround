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
    if mmCursor.dx ~= 0 then love.audio.play(SFX.move_cursor) end
    -- mmCursor.x = mmCursor.x % mainMenuEntryCount
    mmCursor.x = mmCursor.x % 2
    mmCursor.dx = 0
    if mmCursor.action == 1 then
        mmCursor.action = 0
        if mmCursor.x == 0 then
            -- Entry Block
            love.audio.play(SFX.move_cursor)
            changeGameStateTo(1)
        end
    end
    -- print(mmCursor.x)
end
function GameLoopUpdateRegisterScore(dt)
    -- TODO
    if goCursor.action == 1 then
        goCursor.action = 0
        changeGameStateTo(0)
    end
end
function GameLoopUpdateViewScore(dt)
    -- TODO
end

function getRandomCounterOffset()
    -- Entry Block
    return love.math.random(5) - 3
end

function getRandomDestoryInterval()
    -- white average
    return math.max(love.math.random(3, destoryInterval + 3), 3)
end

function doDestory()
    -- infact destory after actual moving, so player able to move tile away.
    destoryCounter = destoryCounter - 1
    -- if destoryCounter > 2 then
    --     destoryCounter = destoryCounter + getRandomCounterOffset()
    -- end
    -- print(destoryCounter)
    if destoryCounter <= 0 then
        -- destoryCounter = 3
        destoryCounter = getRandomDestoryInterval()
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

function generateRandomSideCount()
    local rnd = math.random(0, 100)
    local accm = shopSidePer[1]
    local ptr = 1
    while rnd >= accm do
        ptr = ptr + 1
        if shopSidePer[ptr] ~= nil then
            accm = accm + shopSidePer[ptr]
        else
            return 2
        end
    end

    return ptr
end

function genShopTile()
    -- return 0
    local resID = 0
    local randCore = 0
    local randSide = {}

    local cpuBlock = -99
    local serverBlock = -99

    if couldOnlyBuyInShopOnce then
        if hasAnyCPU() then cpuBlock = processorCoreID end
        if hasAnyServer() then serverBlock = serverCoreID end
    else
        -- in order to prevent have many server/cpu on field, shop could only sell them when player could only buy once
        cpuBlock = processorCoreID
        serverBlock = serverCoreID
    end

    local blockerBlock = PCBCoreID

    repeat
        -- entry block
        randCore = love.math.random(getTotalCoreCount()) - 1
        -- could not prevent from buying multiple cpu/server, so not allow buying CPU/SERVER
    until ((randCore ~= cpuBlock) and (randCore ~= serverBlock) and
        (randCore ~= blockerBlock))

    local oneOrtwo = (love.math.random() < 0.75)
    local halfFullOrEmpty = (love.math.random() < 0.5)

    local connecterCount = generateRandomSideCount()

    if connecterCount == 4 then
        randSide = {1, 1, 1, 1}
    else
        if connecterCount == 1 or connecterCount == 3 then
            local randNum = math.floor(love.math.random(4))
            if connecterCount == 1 then
                randSide = {0, 0, 0, 0}
                randSide[randNum] = 1
            else
                randSide = {1, 1, 1, 1}
                randSide[randNum] = 0
            end
        else
            local randNum = math.floor(love.math.random(6))
            if randNum == 1 then
                randSide = {0, 0, 1, 1}
            elseif randNum == 2 then
                randSide = {0, 1, 1, 0}
            elseif randNum == 3 then
                randSide = {1, 1, 0, 0}
            elseif randNum == 4 then
                randSide = {1, 0, 0, 1}
            elseif randNum == 5 then
                randSide = {1, 0, 1, 0}
            else
                randSide = {0, 1, 0, 1}
            end
        end
    end

    resID = 10000 * randCore + 1000 * randSide[4] + 100 * randSide[3] + 10 *
                randSide[2] + randSide[1]

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

    haveBoughtInShop = false
    haveBoughtInShopWaring = false
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

    animationFCounter = math.floor(frameCounter / 3.0)

    cellSize = baseCellSize * ZoomFactor
    MoveCamera(SelectedMode, dt)
    ZoomCamera(SelectedMode, dt)
    updateTileMap_Cursor()
    updateScore()
    local tragetPosX = cursor.cx + cursor.dx
    local tragetPosY = cursor.cy + cursor.dy
    -- cursor and map coodinate and +1 +1 offset

    if not autoQA then
        if isTargetMovable_Cursor(tragetPosX + 1, tragetPosY + 1) then
            cursor.cx = tragetPosX
            cursor.cy = tragetPosY
            -- currently rotating doesn't count as step
            -- and only success move tile count
            if (actionRec ~= 0) then
                if (cursor.dx ~= 0) or (cursor.dy ~= 0) then
                    love.audio.play(SFX.move_item)
                    stepDrawSwch = false
                    drawDestoryCursorSwch = false
                    PerStepUpdate()
                end
            elseif (cursor.dx ~= 0) or (cursor.dy ~= 0) then
                -- just moving cursor
                love.audio.play(SFX.move_cursor)
            end
        else
            if (cursor.dx ~= 0) or (cursor.dy ~= 0) then
                -- just moving cursor
                love.audio.play(SFX.move_denied)
            end
        end
    else
        stepDrawSwch = false
        drawDestoryCursorSwch = false
        PerStepUpdate()
    end
    cursor.dx = 0
    cursor.dy = 0

    hold_buying = false
    if love.keyboard.isDown("i") or love.keyboard.isDown("s") then
        hold_buying = true
    end

    local pendingGoods = nil
    if buying_ptr > 0 then
        if not haveBoughtInShop then
            if totalCash >= shopPrice[buying_ptr] then
                if shopContent[buying_ptr] ~= nil then
                    totalCash = totalCash - shopPrice[buying_ptr]
                    pendingGoods = shopContent[buying_ptr]
                    shopContent[buying_ptr] = nil
                    shopPrice[buying_ptr] = 0
                    -- use here to check if buy once
                    haveBoughtInShop = couldOnlyBuyInShopOnce
                else
                    -- no goods
                end
            else
                -- no cash
                -- TODO
            end
        else
            -- have bought once
            if buying_ptr > 0 then love.audio.play(SFX.move_denied) end
        end
    end

    buying_ptr = 0

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
        endingData.endingCash = totalCash
        endingData.endingTime = stepCounter
        changeGameStateTo(2) -- current return to main menu
    end

    if stepCounter <= 0 then
        endingData.endingCash = totalCash
        endingData.endingTime = stepCounter
        -- Gameplay End by no time
        changeGameStateTo(2) -- current return to main menu
    end
end
