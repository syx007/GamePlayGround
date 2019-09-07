require("Code/ResourceMgr")
require("Code/PlayerMgr")
require("Code/InputMgr")
require("Code/GraphicMgr")
require("Code/MapMgr")
require("Code/Utils")
-- tmd on DEOT we can't use Chinese comment
-- DON'T write Chinese comment.

function love.load()
    playDemo_2 = false

    counter = 0
    love.window.setMode(320, 240, {resizable = false})
    mapULoffsetX = 10
    mapULoffsetY = 10
	mapLineCount = 6
	mapWidthCount = 6
	mapHeightCount = 6
    mapSize = 220
    initCursor()
    initMap()
    setTileMap()
    loadResource()
    timer = 0.0
    tiker = 0.0
    frameCounter = 0
    frametiker = 0

    score = 0

    gridSize = mapSize / mapLineCount
    cellSize = mapSize / mapLineCount - 10

    win = false
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then love.event.quit() end
    --[[ABXY=JKUI DEOT]] --
    -- if key == "j" or key == "z" then _Fire() end
    updateInput_DemoVI(key)
end

function love.update(dt)
    updateTileMap_Cursor()
    updateScore()
    local tragetPosX = cursor.cx + cursor.dx
    local tragetPosY = cursor.cy + cursor.dy
    -- cursor and map coodinate and +1 +1 offset
    if isTargetMovable_Cursor(tragetPosX + 1, tragetPosY + 1) then
        cursor.cx = tragetPosX
        cursor.cy = tragetPosY
    end
    cursor.dx = 0
    cursor.dy = 0

    timer = timer + dt
    tiker = timer - math.floor(timer)
    tiker = tiker * tiker

    frameCounter = frameCounter + 1
    frametiker = frameCounter % 60
end

function mainGraphicUpdate()
    drawGrid(mapLineCount, mapULoffsetX, mapULoffsetY, mapSize, mapSize)
    updateTileMap()
    drawCursor()
    updateAnimation()
    updateUI()
    drawShop()
    applyPP()
end

function love.draw()
    -- initArtAsset()//only use once for loading asset
    mainGraphicUpdate()
end
