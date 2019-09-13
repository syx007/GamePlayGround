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
    printScore()
    printTimeCounter()
    drawShopUI()
    -- printButtonTips()
end

function drawMainMenu()
    local hWindowWidth = windowWidth / 2.0
    local hWindowHeight = windowHeight / 2.0

    local mainLogoWidth = mainGameLogo:getWidth()
    local mainLogoHeight = mainGameLogo:getHeight()
    local mainLogoX = (windowWidth / 2) - (mainLogoWidth / 2)
    local mainLogoY = (windowHeight / 2) - (mainLogoHeight / 2) - 25
    love.graphics.draw(mainGameLogo, mainLogoX, mainLogoY)

    local font = love.graphics.newFont(14)
    love.graphics.printf("Game Start", 0, hWindowHeight + 20, windowWidth,
                         "center")

    local font = love.graphics.newFont(14)
    love.graphics.printf("...Pending", 0, hWindowHeight + 45, windowWidth,
                         "center")

    love.graphics.rectangle("line", hWindowWidth - 40,
                            hWindowHeight + 20 - 2 + 24 * mmCursor.x, 80, 20, 3,
                            5)
end

function drawPlayingGame()
    -- drawGrid(mapLineCount, mapULoffsetX, mapULoffsetY, mapSize, mapSize)
    -- updateTileMap()
    -- drawCursor()
    love.graphics.setColor(1.0, 1.0, 1.0)
    love.graphics.draw(gamePlayUIBG, 0, 0)

    -- updateAnimation()
    -------------------------------------------------------------
    -- drawBackGroundGrid()
    -- DrawMapLayer0(MaxGridWidth, MaxGridHeight, 0.1, 0.2, 0.3, 1)
    -- DrawMapLayer1(map_size.w, map_size.h, 0.4, 0.4, 0.4, 1)
    -- drawGrid(mapLineCount, mapULoffsetX, mapULoffsetY, mapSize, mapSize)
    updateTileMap()
    -- print(cursor.cx,cursor.cy)

    local grid_coord = MapIdx2GridCoord(cursor.cx, cursor.cy)
    drawCursor(grid_coord.x, grid_coord.y, 0, 1.0, 0,
               0.5 * math.sin(0.1 * animationFCounter) + 1)
    -- updateAnimation()

    if stepDrawSwch then
        if drawDestoryCursorSwch then
            -- love.graphics.setColor(1.0, 0.0, 0.0)
            if destoryCounter == 1 then
                local gsize = map_size.w / MaxGridWidth
                for i = 0, destoryCount - 1 do
                    local grid_coord = MapIdx2GridCoord(
                                           nextDestoryPosX[i + 1] - 1,
                                           nextDestoryPosY[i + 1] - 1)
                    drawCursor(grid_coord.x, grid_coord.y, 1.0, 0.0, 0.0, 1.0)
                end
            elseif destoryCounter == 2 then
                local gsize = map_size.w / MaxGridWidth
                for i = 0, destoryCount - 1 do
                    local grid_coord = MapIdx2GridCoord(
                                           nextDestoryPosX[i + 1] - 1,
                                           nextDestoryPosY[i + 1] - 1)
                    drawCursor(grid_coord.x, grid_coord.y, 0.8, 0.5, 0.0, 1.0)
                end
            end
        end
    end

    updateUI()
    drawShop()
    applyPP()
end
function drawRegisterScore()
    -- TODO 
end
function drawViewScore()
    -- TODO 
end
