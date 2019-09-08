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
    local uiY = 15
    local uiDY = 5

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
        love.graphics.setColor(1, 1, 0.5)
        local font = love.graphics.newFont(14)
        love.graphics.print("TTL scr:" .. (totalIncome), uiX, uiY + uiDY)

        love.graphics.setColor(1, 0, 0.3)
        local font = love.graphics.newFont(14)
        love.graphics.print("TTL cost:" .. (totalCost), uiX, uiY * 2.0 + uiDY)

        love.graphics.setColor(1, 1, 0.5)
        local font = love.graphics.newFont(14)
        love.graphics.print("TTL cash:" .. (totalCash), uiX - 10,
                            uiY * 3.0 + uiDY)
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
        local uiX = 230
        local uiY = 15
        local uiDY = 5

        love.graphics.setColor(1.0, 1.0, 1.0)
        local font = love.graphics.newFont(14)
        love.graphics.print("Timer:" .. stepCounter .. "/" .. stepCounterMax,
                            uiX, uiY * 4.0 + uiDY)
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

    drawUIByIDandPos(shopContent[1], bgx, bgy)
    drawUIByIDandPos(shopContent[2], bgx + bgdx, bgy)
    drawUIByIDandPos(shopContent[3], bgx, bgy + bgdy)
    drawUIByIDandPos(shopContent[4], bgx + bgdx, bgy + bgdy)

    if hold_buying then
        love.graphics.print("U" .. shopPrice[1], 231, 135)
        love.graphics.print("D" .. shopPrice[2], 231 + 44, 135)
        love.graphics.print("L" .. shopPrice[3], 231, 135 + 55)
        love.graphics.print("R" .. shopPrice[4], 231 + 44, 135 + 55)
    end
end
