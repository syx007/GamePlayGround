function printButtonTips()
    if Help == true then
        if SelectedMode == false then
            love.graphics.setColor(1, 1, 1, 0.6)
            TipText =
                "Enter Select Mode:Y\nZoom In:A\nZoom Out:B\nMove Camera:Up/Down/Left/Right"
            love.graphics.print(TipText, 10, 10)
        else
            love.graphics.setColor(1, 1, 1, 0.6)
            TipText =
                "Enter Viewer Mode:Y\nMove Cursor:Up/Down/Left/Right\nMove Block:A+Up/Down/Left/Right\nRotate Block:B\nZoom In:Shift+A\nZoom Out:Shift+B"
            love.graphics.print(TipText, 10, 10)
        end
    else
        love.graphics.setColor(1, 1, 1, 0.3)
        TipText = "Help:Shift+Y"
        love.graphics.print(TipText, 240, 5)
    end
    if SelectedMode == false then
        love.graphics.setColor(1, 1, 1, 0.6)
        StatusText = "Viewer Mode"
        love.graphics.print(StatusText, 10, 225)
    else
        love.graphics.setColor(1, 1, 1, 0.6)
        StatusText = "Select Mode"
        love.graphics.print(StatusText, 10, 225)
    end
end

function printScore()
    local uiX = 230
    local uiY = 18
    local uiDY = 7

    totalIncome = driverIncome + blueIncome + edgeIncome
    if debug_view then
        love.graphics.setColor(0.5, 1.0, 0.5)
        local font = love.graphics.newFont(14)
        love.graphics.print("CPU scr:" .. driverIncome, uiX, uiY * 1.0 + uiDY)
        love.graphics.setColor(0.5, 1, 1)
        local font = love.graphics.newFont(14)
        love.graphics.print("Net scr:" .. blueIncome, uiX, uiY * 2.0 + uiDY)

        -- love.graphics.setColor(1, 0.5, 1)
        -- local font = love.graphics.newFont(14)
        -- love.graphics.print("FRW scr:" .. edgeIncome, uiX, uiY * 3.0 + uiDY)

        love.graphics.setColor(1, 1, 0.5)
        local font = love.graphics.newFont(14)
        love.graphics.print("TTL scr:" .. (totalIncome), uiX, uiY * 3.0 + uiDY)

        love.graphics.setColor(1, 0, 0.3)
        local font = love.graphics.newFont(14)
        love.graphics.print("TTL cost:" .. (totalCost), uiX, uiY * 4.0 + uiDY)

        love.graphics.setColor(1, 1, 0.5)
        local font = love.graphics.newFont(14)
        love.graphics.print("TTL cash:" .. (totalCash), uiX - 10,
                            uiY * 7.0 + uiDY)
    else
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(incomeUI, uiX - 3, uiY + uiDY - 2, 0, 1.0, 1.0)
        local font = love.graphics.setNewFont(12)
        local totalBenefit = totalIncome - totalCost
        if totalBenefit >= 0 then
            love.graphics.setColor(0.2, 1.0, 0.1)
        else
            love.graphics.setColor(1.0, 0.2, 0.1)
        end
        love.graphics.print((totalBenefit), uiX + 20, uiY + uiDY)

        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(cashUI, uiX - 3, uiY * 2.0 + uiDY - 2, 0, 1.0, 1.0)

        if totalCash > initCash then
            love.graphics.setColor(0.2, 1.0, 0.1)
        elseif totalCash >= initCash / 5.0 then
            love.graphics.setColor(1.0, 1.0, 1.0)
        else
            love.graphics.setColor(1.0, 0.2, 0.1)
        end
        local font = love.graphics.setNewFont(12)
        love.graphics.print((totalCash), uiX + 20, uiY * 2.0 + uiDY)

        inWarningState = inWarningState or (totalCash < initCash / 5.0)
    end
end

function printTimeCounter()

    if debug_view then
        local uiX = 230
        local uiY = 15
        local uiDY = 80

        love.graphics.setColor(1.0, 1.0, 1.0)
        local font = love.graphics.newFont(14)
        love.graphics.print("Timer:" .. stepCounter .. "/" .. stepCounterMax,
                            uiX, uiY * 1.0 + uiDY)
    else
        local uiX = 250
        local uiY = 18
        local uiDY = 7

        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(clockUI, uiX - 20, uiY * 3.0 + uiDY + 1, 0, 0.7, 0.7)

        if stepCounter > stepCounterMax / 2.0 then
            love.graphics.setColor(1.0, 1.0, 1.0)
        elseif stepCounter > stepCounterMax / 5.0 then
            love.graphics.setColor(1.0, 0.5, 0.1)
        else
            love.graphics.setColor(1.0, 0.2, 0.1)
        end

        local font = love.graphics.newFont(14)
        love.graphics.print(stepCounter .. "/" .. stepCounterMax, uiX,
                            uiY * 3.0 + uiDY)

        inWarningState = inWarningState or (stepCounter <= stepCounterMax / 5.0)

    end
end

function printWin()
    if win then
        local font = love.graphics.newFont(14)
        love.graphics.print("WIN", 265, 100)
    end
end

function updateTimer()
    local timerCol = frametiker / 60
    love.graphics.setColor(timerCol, timerCol, timerCol)
    love.graphics.rectangle("fill", 250, 180, 50, 50, 3, 3, 5)
end

function drawUIByIDandPos(id, PosX, PosY)
    if id ~= nil then
        local coreID = extractDataByPtr(id, 0)
        local westID = getRotatedSide_Single(1, id, 0)
        local northID = getRotatedSide_Single(2, id, 0)
        local southID = getRotatedSide_Single(3, id, 0)
        local eastID = getRotatedSide_Single(4, id, 0)

        local shop_grid_coord = MapIdx2GridCoord(PosX, PosY)
        drawTileCore(shop_grid_coord.x, shop_grid_coord.y, coreID)
        drawTilSide(shop_grid_coord.x, shop_grid_coord.y, coreID, westID, 1)
        drawTilSide(shop_grid_coord.x, shop_grid_coord.y, coreID, northID, 2)
        drawTilSide(shop_grid_coord.x, shop_grid_coord.y, coreID, southID, 4)
        drawTilSide(shop_grid_coord.x, shop_grid_coord.y, coreID, eastID, 3)
    end
end

function drawShopUI()
    -- this lock to UI graph
    local bgx = 6.7
    local bgy = 2.5

    local bgdx = 1.4
    local bgdy = 1.75

    -- could do this, if have bought once, the shop interface gray out
    -- if still try to buy, then overlay once.

    if haveBoughtInShop then
        love.graphics.setShader(bwShader)
    else
        love.graphics.setShader()
    end
    drawUIByIDandPos(shopContent[1], bgx, bgy)
    drawUIByIDandPos(shopContent[2], bgx + bgdx, bgy)
    drawUIByIDandPos(shopContent[3], bgx, bgy + bgdy)
    drawUIByIDandPos(shopContent[4], bgx + bgdx, bgy + bgdy)

    -- hold_buying = true

    if hold_buying then
        love.graphics.setColor(0.2, 1.0, 0.1)
    else
        love.graphics.setColor(0.2, 0.2, 0.2)
    end
    love.graphics.print(shopPrice[1], 240, 139)
    love.graphics.print(shopPrice[2], 240 + 44, 139)
    love.graphics.print(shopPrice[3], 240, 139 + 55)
    love.graphics.print(shopPrice[4], 240 + 44, 139 + 55)

    love.graphics.draw(arrowUI, 225, 139, 0, 0.8, 0.8)
    love.graphics.draw(arrowUI, 225 + 44 + 17 * 0.8, 139 + 17 * 0.8, math.pi,
                       0.8, 0.8)
    love.graphics.draw(arrowUI, 225, 139 + 55 + 17 * 0.8, math.pi / 2 * 3, 0.8,
                       0.8)
    love.graphics.draw(arrowUI, 225 + 44 + 17 * 0.8, 139 + 55, math.pi / 2, 0.8,
                       0.8)

    love.graphics.setShader()



    --pending
    -- if haveBoughtInShopWaring then
    --     love.graphics.setColor(0.0, 0.0, 0.0,1.0)
    --     love.graphics.rectangle("fill", 160, 240, 160, 240)
    -- end
end
