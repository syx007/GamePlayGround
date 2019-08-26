-- put all rendering and graphicing API here
require("Code/ElementLib")
require("Code/Utils")

function initArtAsset()
    -- we force the sampler here.
    -- don't like any interpolation, just use point filter is good.
    -- however, setting sampler have to do every draw.
    fighter0:setFilter("nearest", "nearest")
    bullet0:setFilter("nearest", "nearest")
    emptybullet0:setFilter("nearest", "nearest")
end

function drawCursor()
    local gsize = mapSize / mapLineCount
    local csize = mapSize / mapLineCount - 10
    local cPosX = mapULoffsetX + cursor.cx * gsize + 5
    local cPosY = mapULoffsetY + cursor.cy * gsize + 5
    love.graphics.setColor(1.0, 1.0, 1.0)
    love.graphics.rectangle("line", cPosX, cPosY, csize, csize, 3, 3, 5)
end
function drawGrid(count, pX, pY, sX, sY)
    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
    love.graphics.setLineWidth(1)
    love.graphics.line(pX, pY, pX + sX, pY)
    love.graphics.line(pX, pY, pX, pY + sY)
    for i = 1, count do
        -- love.graphics.setLineWidth(1)
        love.graphics.line(pX, pY + i * (sY / count), pX + sX,
                           pY + i * (sY / count))
    end
    for i = 1, count do
        -- love.graphics.setLineWidth(1)
        love.graphics.line(pX + i * (sX / count), pY, pX + i * (sX / count),
                           pY + sY)
    end
end

function updateTimer()
    local timerCol = frametiker / 60
    love.graphics.setColor(timerCol, timerCol, timerCol)
    love.graphics.rectangle("fill", 250, 180, 50, 50, 3, 3, 5)
end

function drawBond(_connectivity, _cPosX, _cPosY, colorR)
    local hGridSize = gridSize / 2.0

    local lStartX = _cPosX - hGridSize
    local lStartY = _cPosY - hGridSize

    for idx = 0, 3 do
        local cctvty = math.floor(_connectivity / math.pow(10, idx) % 10)
        if not (cctvty == 0) then
            local offset = posOffsetByConnectivity(cctvty)
            love.graphics.setLineWidth(3)
            love.graphics.setColor(colorR, colorR, colorR)
            love.graphics.line(lStartX, lStartY,
                               lStartX + offset[1] * hGridSize,
                               lStartY + offset[2] * hGridSize)
        end
    end
end

function updateMap()
    for i = 1, mapLineCount do
        for j = 1, mapLineCount do
            ElementData = getElementByID(mapData[i][j].id)
            ElementGoalData = getElementByID(mapGoalData[i][j].id)
            StructDataID = (mapStructData[i][j].id)

            local cPosX = mapULoffsetX + i * gridSize
            local cPosY = mapULoffsetY + j * gridSize

            local cCirPosX = cPosX - gridSize / 2.0
            local cCirPosY = cPosY - gridSize / 2.0
            local hCellSize = cellSize / 2.0

            if (StructDataID > 0) then
                if (StructDataID == 1) or (StructDataID == 2) then
                    drawBond(mapStructData[i][j].connectivity, cPosX, cPosY, 0.5)
                    love.graphics.setColor(0.5, 0.5, 0.5)
                    love.graphics.circle("fill", cCirPosX, cCirPosY, hCellSize)
                elseif (StructDataID == 5) then
                    love.graphics.setColor(1.0, 1.0, 1.0)
                    love.graphics.setLineWidth(1)
                    love.graphics.line(cPosX,cPosY,cPosX-gridSize,cPosY-gridSize);
                    love.graphics.line(cPosX,cPosY-gridSize,cPosX-gridSize,cPosY);
                end
            end
            if not (ElementGoalData == nil) then
                drawBond(mapGoalData[i][j].connectivity, cPosX, cPosY, 1.0)
                love.graphics.setColor(ElementGoalData.color[1] / 255,
                                       ElementGoalData.color[2] / 255,
                                       ElementGoalData.color[3] / 255)
                love.graphics.circle("line", cCirPosX, cCirPosY, hCellSize)
                love.graphics.setColor(0.0, 0.0, 0.0)
                love.graphics.circle("fill", cCirPosX, cCirPosY, hCellSize - 1)
            end
            if not (ElementData == nil) then
                drawBond(mapData[i][j].connectivity, cPosX, cPosY, 1.0)
                love.graphics.setColor(ElementData.color[1] / 255,
                                       ElementData.color[2] / 255,
                                       ElementData.color[3] / 255)
                love.graphics.circle("fill", cCirPosX, cCirPosY, hCellSize)
            end
        end
    end
end

function mainGraphicUpdate()
    drawGrid(mapLineCount, mapULoffsetX, mapULoffsetY, mapSize, mapSize)
    updateMap()
    updateTimer()
    drawCursor()
    printWin()
end

function uiUpdate()
    for i = 0, 4 do
        if i < player.bulletCount then
            love.graphics.draw(bullet0, 10 + i * 24, 220)
        else
            love.graphics.draw(emptybullet0, 10 + i * 24, 220)
        end
    end
end

function printWin()
    if win then
        local font = love.graphics.newFont(14)
        love.graphics.print("WIN", 265, 100)
    end
end

