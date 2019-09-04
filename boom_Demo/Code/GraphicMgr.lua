require("Code/ElementLib")
require("Code/Utils")
require("Code/AnimationSheet")

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
    -- local csize = mapSize / mapLineCount - 10
    local cPosX = mapULoffsetX + cursor.cx * gsize + 5
    local cPosY = mapULoffsetY + cursor.cy * gsize + 5
    love.graphics.setColor(1.0, 0.0, 0.0)
    love.graphics.rectangle("line", cPosX, cPosY, cellSize, cellSize, 3, 3, 5)
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
                    love.graphics.line(cPosX, cPosY, cPosX - gridSize,
                                       cPosY - gridSize)
                    love.graphics.line(cPosX, cPosY - gridSize,
                                       cPosX - gridSize, cPosY)
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

function updateTileMap()
    for i = 1, mapLineCount do
        for j = 1, mapLineCount do
            -- ElementData = getElementByID(mapData[i][j].id)

            local cPosX = mapULoffsetX + (i - 1) * gridSize + 5
            local cPosY = mapULoffsetY + (j - 1) * gridSize + 5

            local cCirPosX = cPosX - gridSize / 2.0
            local cCirPosY = cPosY - gridSize / 2.0
            local hCellSize = cellSize / 2.0
            local tileCoreSize = cellSize * 0.6
            local tileOffset = (cellSize - tileCoreSize) / 2.0
            if not (mapData[i][j] == nil) then
                local coreID = extractDataByPtr(mapData[i][j].id, 0)
                local westID = getRotatedSide_Single(1, mapData[i][j].id,
                                                     mapData[i][j].rotation)
                local northID = getRotatedSide_Single(2, mapData[i][j].id,
                                                      mapData[i][j].rotation)
                local southID = getRotatedSide_Single(3, mapData[i][j].id,
                                                      mapData[i][j].rotation)
                local eastID = getRotatedSide_Single(4, mapData[i][j].id,
                                                     mapData[i][j].rotation)

                -- westID=getRotatedSide_Single(westID,mapData[i][j].rotation);
                -- northID=getRotatedSide_Single(northID,mapData[i][j].rotation);
                -- southID=getRotatedSide_Single(southID,mapData[i][j].rotation);
                -- eastID=getRotatedSide_Single(eastID,mapData[i][j].rotation);

                CoreColor(coreID)
                love.graphics.setColor(coreColor[1], coreColor[2], coreColor[3]) -- Core    
                love.graphics.rectangle("fill", cPosX + tileOffset,
                                        cPosY + tileOffset, tileCoreSize,
                                        tileCoreSize, 3, 3, 5)

                -- print(westID);
                SubTileColor(westID)
                love.graphics.setColor(subTileColor[1], subTileColor[2],
                                       subTileColor[3]) -- subtile-1     
                love.graphics.rectangle("fill", cPosX - 1, cPosY + tileOffset,
                                        tileOffset, tileCoreSize, 3, 3, 5)

                SubTileColor(northID)
                love.graphics.setColor(subTileColor[1], subTileColor[2],
                                       subTileColor[3]) -- subtile-2
                love.graphics.rectangle("fill", cPosX + tileOffset, cPosY - 1,
                                        tileCoreSize, tileOffset, 3, 3, 5)

                SubTileColor(southID)
                love.graphics.setColor(subTileColor[1], subTileColor[2],
                                       subTileColor[3]) -- subtile-3
                love.graphics.rectangle("fill", cPosX + tileOffset,
                                        cPosY + 1 + tileCoreSize + tileOffset,
                                        tileCoreSize, tileOffset, 3, 3, 5)

                SubTileColor(eastID)
                love.graphics.setColor(subTileColor[1], subTileColor[2],
                                       subTileColor[3]) -- subtile-4
                love.graphics.rectangle("fill",
                                        cPosX + 1 + tileCoreSize + tileOffset,
                                        cPosY + tileOffset, tileOffset,
                                        tileCoreSize, 3, 3, 5)
            end
        end
    end
end

function updateAnimation()
    --TODO
end

function drawShop()
    --TODO
end

function applyPP()
    --TODO
end

function updateUI()
    -- TODO
    printScore();
end

function printScore()
    love.graphics.setColor(0.5, 1.0, 0.5)
    local font = love.graphics.newFont(14)
	love.graphics.print(greenScore, 265, 100)
	
    love.graphics.setColor(0.5, 1, 1)
    local font = love.graphics.newFont(14)
    love.graphics.print(blueScore, 265, 150)
end

function printWin()
    if win then
        local font = love.graphics.newFont(14)
        love.graphics.print("WIN", 265, 100)
    end
end

