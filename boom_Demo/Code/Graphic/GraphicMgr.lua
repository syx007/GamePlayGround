require("Code/DesignerConfigs/ElementConf")
require("Code/Utils")
require("Code/Graphic/AnimationSheet")
require("Code/Graphic/UiGraphicMgr")
require("Code/Graphic/Camera")
require("Code/Resource/TileMgr")

function getWorldCoordfromGrid(grid_x, grid_y, camera_bias_x, camera_bias_y)
    local coord = {x, y}
    coord.x = grid_x * cellSize + world_origin_x - camera_bias_x
    coord.y = grid_y * cellSize + world_origin_y - camera_bias_y
    return coord
end
function MapIdx2GridCoord(MapIdx_x, MapIdx_y)
    local grid_coord = {x, y}
    grid_coord.x = MapIdx_x - mapLineCount / 2
    grid_coord.y = MapIdx_y - mapLineCount / 2
    return grid_coord
end
function GridCoord2MapIdx(grid_x, grid_y)
    local MapIdx = {x, y}
    mapIdx.x = grid_x + mapLineCount / 2 + 1
    mapIdx.y = grid_y + mapLineCount / 2 + 1
    return mapIdx
end

function updateMap()
    for i = 1, mapLineCount do
        for j = 1, mapLineCount do
            local grid_coord = MapIdx2GridCoord(i - 1, j - 1)
            local cPos = getWorldCoordfromGrid(grid_coord.x, grid_coord.y,
                                               camera_bias_x, camera_bias_y)
            ElementData = getElementByID(mapData[i][j].id)
            ElementGoalData = getElementByID(mapGoalData[i][j].id)
            StructDataID = (mapStructData[i][j].id)

            local cPosX = cPos.x
            local cPosY = cPos.y

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
                -- love.graphics.circle("line", cCirPosX, cCirPosY, hCellSize)
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
function playCoreAnimation(core_id, t, playAnimation)
    local fCount = Tiles[core_id + 1][1].Core.fCount + 1
    -- print("fcount=",fCount)
    if playAnimation == true then
        Tiles[core_id + 1][1].Core.content[animationFCounter % fCount]:setFilter(
            "nearest", "nearest")
        return Tiles[core_id + 1][1].Core.content[animationFCounter % fCount]
    else
        Tiles[core_id + 1][1].Core.content[0]:setFilter("nearest", "nearest")
        return Tiles[core_id + 1][1].Core.content[0]
    end
end
function playSideAnimation(core_id, side_id, t, playAnimation)
    -- print("coreid",core_id,"sideid",side_id)
    local fCount = Tiles[core_id + 1][side_id + 1].Side.fCount + 1
    -- print("fcount=",fCount)
    if playAnimation == true then
        Tiles[core_id + 1][side_id + 1].Side.content[animationFCounter % fCount]:setFilter(
            "nearest", "nearest")
        return Tiles[core_id + 1][side_id + 1].Side.content[animationFCounter %
                   fCount]
    else
        Tiles[core_id + 1][side_id + 1].Side.content[0]:setFilter("nearest",
                                                                  "nearest")
        return Tiles[core_id + 1][side_id + 1].Side.content[0]
    end
end
function drawTileCore(grid_x, grid_y, core_id, playAnimation)
    love.graphics.setColor(1, 1, 1, 1)
    local coord = getWorldCoordfromGrid(grid_x, grid_y, camera_bias_x,
                                        camera_bias_y)
    -- Tiles[core_id + 1][1].Core.content[0]:setFilter("nearest", "nearest")
    love.graphics.draw(playCoreAnimation(core_id, t, playAnimation),
                       coord.x + ZoomFactor * 16, coord.y + ZoomFactor * 16, 0,
                       ZoomFactor, ZoomFactor, 16, 16)
end

function drawTilSide(grid_x, grid_y, core_id, side_id, rot, playAnimation)
    -- if side_id == noSideID then return end
    love.graphics.setColor(1, 1, 1, 1)
    -- print(core_id,side_id)
    -- this ID should comply excel sheet or change Core2SideMap.map file
    local coord = getWorldCoordfromGrid(grid_x, grid_y, camera_bias_x,
                                        camera_bias_y)
    -- Tiles[core_id + 1][side_id + 1].Side.content[0]:setFilter("nearest", "nearest")
    love.graphics.draw(playSideAnimation(core_id, side_id, t, playAnimation),
                       coord.x + ZoomFactor * 16, coord.y + ZoomFactor * 16,
                       (rot - 2) * (3.141592654 / 2), ZoomFactor, ZoomFactor,
                       16, 16)
end

function drawSingeTile(grid_coord, id, idOnOff, rotation, playAnimation)
    local coreID = extractDataByPtr(id, 0)
    local westID = getRotatedSide_Single(1, id, rotation)
    local northID = getRotatedSide_Single(2, id, rotation)
    local southID = getRotatedSide_Single(3, id, rotation)
    local eastID = getRotatedSide_Single(4, id, rotation)

    local westIDOnOff = getRotatedSideOnOff_Single(1, idOnOff, rotation)
    local northIDOnOff = getRotatedSideOnOff_Single(2, idOnOff, rotation)
    local southIDOnOff = getRotatedSideOnOff_Single(3, idOnOff, rotation)
    local eastIDOnOff = getRotatedSideOnOff_Single(4, idOnOff, rotation)
    -- local westIDOnOff = 0
    -- local northIDOnOff = 0
    -- local southIDOnOff = 0
    -- local eastIDOnOff = 0

    drawTileCore(grid_coord.x, grid_coord.y, coreID, playAnimation)
    drawTilSide(grid_coord.x, grid_coord.y, coreID, westID + westIDOnOff, 1,
                false)
    drawTilSide(grid_coord.x, grid_coord.y, coreID, northID + northIDOnOff, 2,
                false)
    drawTilSide(grid_coord.x, grid_coord.y, coreID, southID + southIDOnOff, 4,
                false)
    drawTilSide(grid_coord.x, grid_coord.y, coreID, eastID + eastIDOnOff, 3,
                false)
end

function updateTileMap()
    for i = 1, mapLineCount do
        for j = 1, mapLineCount do
            local grid_coord = MapIdx2GridCoord(i - 1, j - 1)
            local cPos = getWorldCoordfromGrid(grid_coord.x, grid_coord.y,
                                               camera_bias_x, camera_bias_y)
            -- ElementData = getElementByID(mapData[i][j].id)
            local cPosX = cPos.x
            local cPosY = cPos.y

            local cCirPosX = cPosX - gridSize / 2.0
            local cCirPosY = cPosY - gridSize / 2.0
            local hCellSize = cellSize / 2.0
            local tileCoreSize = cellSize * 0.6
            local tileOffset = (cellSize - tileCoreSize) / 2.0
            if not (mapData[i][j] == nil) then
                drawSingeTile(grid_coord, mapData[i][j].id,
                              mapData[i][j].idOnOff, mapData[i][j].rotation,
                              mapData[i][j].playAnimation)
            end
        end
    end
end

function DrawMapUnit(grid_x, grid_y, camera_bias_x, camera_bias_y, r, g, b, a)
    -- getWorldCoord(grid_x,grid_y,world_coord_)
    -- math.randomseed(os.time()+grid_x*grid_y)
    -- r=math.random()
    -- g=math.random()
    -- b=math.random()

    local coord = getWorldCoordfromGrid(grid_x, grid_y, camera_bias_x,
                                        camera_bias_y)
    love.graphics.setColor(r, g, b, a)
    love.graphics.rectangle("line", coord.x, coord.y, cellSize, cellSize)
end
function DrawMapLayer0(MaxGridWidth, MaxGridHeight, r, g, b, a)

    -- zoom_bias_x=camera_bias_x*(1-ZoomFactor)
    -- zoom_bias_y=camera_bias_y*(1-ZoomFactor)
    for i = -MaxGridWidth / 2, MaxGridWidth / 2 - 1 do
        for j = -MaxGridHeight / 2, MaxGridHeight / 2 - 1 do
            DrawMapUnit(i, j, camera_bias_x, camera_bias_y, r, g, b, a)
        end
    end
end
function DrawMapLayer1(MapLimit_w, MapLimit_h, r, g, b, a)
    for i = -map_size.w / 2, map_size.w / 2 - 1 do
        for j = -map_size.h / 2, map_size.h / 2 - 1 do
            -- math.randomseed(os.time()+i*j)
            -- r=math.random()
            -- g=math.random()
            -- b=math.random()
            DrawMapUnit(i, j, camera_bias_x, camera_bias_y, r, g, b, a)
        end
    end
end
function drawCursor(grid_x, grid_y, r, g, b, a)
    DrawMapUnit(grid_x, grid_y, camera_bias_x, camera_bias_y, r, g, b, a)
end

function drawDestoryCursor(grid_x, grid_y, r, g, b, a)
    local coord = getWorldCoordfromGrid(grid_x, grid_y, camera_bias_x,
                                        camera_bias_y)
    love.graphics.setColor(r, g, b, a)
    love.graphics.rectangle("line", coord.x + 3, coord.y + 3, cellSize - 5,
                            cellSize - 5, 3, 5)
end

function updateAnimation()
    -- TODO
end

function drawShop()
    -- TODO
end

function applyPP()
    -- TODO
end

function updateUI()
    inWarningState = false
    printScore()
    printTimeCounter()
    if inWarningState then
        local uiX = 230
        local uiY = 18

        local waringTerm = math.sin(animationFCounter * 0.5)
        love.graphics.setColor(1.0, 0.2, 0.1, 0.2 * waringTerm)
        love.graphics.rectangle("fill", uiX - 15, uiY - 5, 100, 70)
    end
    drawShopUI()
    -- printButtonTips()
end

function drawCodefall(frameCounter)
    flags = {}
    if frameCounter % 20 == 0 then
        local values = {}
        for i = 0, 31 do
            values[i] = math.floor(math.random(0, 32))
            if values[i] < 3 then flags[i] = true end
        end
    else
        for i = 0, 31 do flags[i] = false end
    end

    if frameCounter % 10 == 0 then
        for i = 0, 31 do
            temp[i].ch = string.char(math.floor(math.random(33, 126)))
            -- print(temp[i].ch)
            if flags[i] == true then
                -- print("i=",i)
                temp[i].alpha = 1
            else
                if temp[i].alpha > 0 then
                    temp[i].alpha = temp[i].alpha - 0.1
                else
                    temp[i].alpha = 0
                end
            end
        end

        for i = 22, 0, -1 do
            for j = 0, 31 do
                strmap[i + 1][j].ch = strmap[i][j].ch
                strmap[i + 1][j].alpha = strmap[i][j].alpha
            end
        end
        for j = 0, 31 do
            strmap[0][j].ch = temp[j].ch
            strmap[0][j].alpha = temp[j].alpha
        end
    end
    local font = love.graphics.setNewFont(9)
    for i = 0, 23 do
        for j = 0, 31 do
            love.graphics.setColor(0.05, 0.7, 0.7, strmap[i][j].alpha)
            love.graphics.print(strmap[i][j].ch, j * 10, i * 10)
        end
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function drawEnterTips(timer)
    love.graphics.draw(EnterTipsUI, 95, 162 + 5 * math.sin(2 * timer))
end

function drawMainMenu()
    local hWindowWidth = windowWidth / 2.0
    local hWindowHeight = windowHeight / 2.0

    local mainLogoWidth = mainGameLogo:getWidth()
    local mainLogoHeight = mainGameLogo:getHeight()
    local mainLogoX = (windowWidth / 2) - (mainLogoWidth / 2)
    local mainLogoY = (windowHeight / 2) - (mainLogoHeight / 2) - 25
    love.graphics.draw(menuBackground, 0, 0)

    drawCodefall(100)
    love.graphics.draw(menuLogo, 0, 0)
    drawEnterTips(timer)
end

function drawPlayingGame()
    if inWarningState then
        local uiX = 0
        local uiY = 0

        local waringTerm = math.sin(animationFCounter * 0.5)
        love.graphics.setColor(0.5, 0.1, 0.1, 0.2 * waringTerm)
        -- love.graphics.setColor(0.0, 0.0, 1.0, 1.0)
        love.graphics.rectangle("fill", uiX - 15, uiY - 5, 223, 223)
    end

    updateTileMap()

    local grid_coord = MapIdx2GridCoord(cursor.cx, cursor.cy)
    drawCursor(grid_coord.x, grid_coord.y, 0, 1.0, 0,
               0.5 * math.sin(0.1 * animationFCounter) + 1)

    if stepDrawSwch then
        if drawDestoryCursorSwch then
            -- love.graphics.setColor(1.0, 0.0, 0.0)
            if destoryCounter == 1 then
                local gsize = map_size.w / MaxGridWidth
                for i = 0, destoryCount - 1 do
                    local grid_coord = MapIdx2GridCoord(
                                           nextDestoryPosX[i + 1] - 1,
                                           nextDestoryPosY[i + 1] - 1)
                    drawDestoryCursor(grid_coord.x, grid_coord.y, 1.0, 0.0, 0.0,
                                      1.0)
                end
            elseif destoryCounter == 2 then
                local gsize = map_size.w / MaxGridWidth
                for i = 0, destoryCount - 1 do
                    local grid_coord = MapIdx2GridCoord(
                                           nextDestoryPosX[i + 1] - 1,
                                           nextDestoryPosY[i + 1] - 1)
                    drawDestoryCursor(grid_coord.x, grid_coord.y, 0.8, 0.5, 0.0,
                                      1.0)
                end
            end
        end
    end

    updateUI()
    drawShop()
    applyPP()

    -- to block UI warning
    love.graphics.setColor(1.0, 1.0, 1.0)
    love.graphics.draw(gamePlayUIBG, 0, 0)
end
function drawRegisterScore()
    local uiX = 25
    local dminY = -11
    local dY = 60

    love.graphics.setColor(0.8, 0.8, 0.8)

    if endingData.endingTime <= 0 then
        local font = love.graphics.setNewFont(25)
        love.graphics.print("YOU MADE IT", uiX - 2, 40 + dminY)
    else
        local font = love.graphics.setNewFont(30)
        love.graphics.print("GAMEOVER", uiX - 2, 40 + dminY)
    end

    local earnedMoney = endingData.endingCash - initCash

    local font = love.graphics.setNewFont(14)
    if earnedMoney >= 0 then
        love.graphics.print("you've earned ", uiX, 80 + dminY)
    else
        if endingData.endingTime <= 0 then
            love.graphics.print("however, you've lost ", uiX, 80 + dminY)
        else
            love.graphics.print("and you've lost ", uiX, 80 + dminY)
        end
    end
    local font = love.graphics.setNewFont(24)
    if earnedMoney >= 0 then
        love.graphics.setColor(0.2, 0.8, 0.1)
    else
        love.graphics.setColor(0.8, 0.2, 0.1)
    end
    love.graphics.print(math.abs(earnedMoney), uiX + 60, 101 + dminY)
    love.graphics.setColor(0.8, 0.8, 0.8)
    local font = love.graphics.setNewFont(14)

    if earnedMoney >= 0 then
        love.graphics.print(" extra money", uiX + 80, 130 + dminY)
    else
        love.graphics.print(" money", uiX + 120, 130 + dminY)
    end

    local survivedTime = stepCounterMax - endingData.endingTime
    local font = love.graphics.setNewFont(14)
    love.graphics.print("you've survived ", uiX, 80 + dY)
    local font = love.graphics.setNewFont(24)
    love.graphics.print(survivedTime, uiX + 60, 102 + dY)
    local font = love.graphics.setNewFont(14)
    love.graphics.print(" rounds", uiX + 120, 130 + dY)

    local font = love.graphics.setNewFont(10)
    love.graphics.print("Press A to return", 14, 205)

    local font = love.graphics.setNewFont(10)
    love.graphics.print("Created By", 225, 95)
    love.graphics.print("theArchitect", 246, 108)

    love.graphics.print("Atwood", 225, 130)
    love.graphics.print("MasterOfKMK", 225, 142)
    love.graphics.print("Yuxuan Su", 225, 154)
    love.graphics.print("Zi Tian", 225, 166)

    local font = love.graphics.setNewFont(12)
    love.graphics.print("Thank you", 224, 185)
    love.graphics.print("For playing", 242, 200)

    love.graphics.setColor(1.0, 1.0, 1.0)
    love.graphics.draw(gamePlayUIBG, 0, 0)
    love.graphics.draw(studioLogo, 232, 22, 0, 0.25, 0.25)
end
function drawViewScore()
    -- REMOVED
end
