require("Code/ResourceMgr")
require("Code/PlayerMgr")
require("Code/InputMgr")
require("Code/GraphicMgr")
require("Code/MapMgr")
-- tmd on DEOT we can't use Chinese comment
-- DON'T write Chinese comment.

function love.load()
    counter = 0
    love.window.setMode(320, 240, {resizable = false})
    mapULoffsetX = 10
    mapULoffsetY = 10
    mapLineCount = 5
    mapSize = 220
    initCursor()
    -- loadResource()
    -- bulletList = {}
    -- initPlayer()
    initMap()
    setUpMap()
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then love.event.quit() end
    --[[ABXY=JKUI DEOT]] --
    -- if key == "j" or key == "z" then _Fire() end
    updateInput_DemoII(key)
end

function love.update(dt)
	updateMap_Cursor_pushOnly();
    cursor.cx = cursor.cx + cursor.dx
    cursor.cy = cursor.cy + cursor.dy
    cursor.cy = math.min(mapLineCount - 1, math.max(0, cursor.cy))
    cursor.cx = math.min(mapLineCount - 1, math.max(0, cursor.cx))
    cursor.dx = 0
    cursor.dy = 0
end

function love.draw()
    -- initArtAsset()
    mainGraphicUpdate()
    -- uiUpdate()
end
