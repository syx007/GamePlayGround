require("Code/Resource/ResourceMgr")
require("Code/GameCore/PlayerMgr")
require("Code/GameStateSwh")
-- tmd on DEOT we can't use Chinese comment
-- DON'T write Chinese comment.

function love.load()
    loadResource()

    gameState = 0

    -- debug_directGame = true
    debug_directGame = false
    if debug_directGame then gameState = 1 end

    windowWidth = 320
    windowHeight = 240

    love.window.setMode(windowWidth, windowHeight, {resizable = false})
    mapULoffsetX = 10
    mapULoffsetY = 10
    mapLineCount = 6
    mapWidthCount = 6
    mapHeightCount = 6
    mapSize = 220

    initMainMenuCursor()

    initCursor()
    initMap()
    setTileMap()

    counter = 0
    timer = 0.0
    tiker = 0.0
    frameCounter = 0
    frametiker = 0

    score = 0

    gridSize = mapSize / mapLineCount
    cellSize = mapSize / mapLineCount - 10

    win = false

    --init Score here, or get nil val
    driverScore=0.0;
    blueScore=0.0;
    edgeScore=0.0;

    -- we also have split load for different screen, for reloading screen to init.
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then love.event.quit() end
    --[[ABXY=JKUI DEOT]] --
    mainUpdateInputSwitch(gameState, key)
end

function love.update(dt)
    
    timer = timer + dt
    tiker = timer - math.floor(timer)
        
    frameCounter = frameCounter + 1
    frametiker = frameCounter % 60

    mainGameLoopSwitch(gameState, dt)
end

function love.draw()
    -- Return Blocker
    mainDrawingSwitch(gameState)
end
