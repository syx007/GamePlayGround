require("Code/Resource/ResourceMgr")
require("Code/GameCore/PlayerMgr")
require("Code/GameStateSwh")
-- tmd on DEOT we can't use Chinese comment
-- DON'T write Chinese comment.

function love.load()
    
    loadResource()
    initTiles()
    gameState = 0

    -- debug_directGame = true
    debug_directGame = false
    if debug_directGame then gameState = 1 end

    windowWidth = 320
    windowHeight = 240

    love.window.setMode(windowWidth, windowHeight, {resizable = false})
    mapULoffsetX = 10
    mapULoffsetY = 10
    mapLineCount = map_size.w
    mapWidthCount = map_size.w
    mapHeightCount = map_size.h
    --mapSize = 220
    camera_width=windowWidth
    camera_height=windowHeight
    baseCellSize=32
    cellSize=32;
    MaxGridWidth=10;
    MaxGridHeight=10;
    --InitBoundWidth=6;
    --InitBoundHeight=6;
    world_origin_x=camera_width/2
    world_origin_y=camera_height/2
    --world_origin_x=camera_width/2-MaxGridWidth*cellSize/2
    --world_origin_y=camera_height/2-MaxGridHeight*cellSize/2
    world_bound_x_min=world_origin_x-MaxGridWidth*baseCellSize/2;
    world_bound_x_max=world_origin_x+MaxGridWidth*baseCellSize/2;
    world_bound_y_min=world_origin_y-MaxGridHeight*baseCellSize/2;
    world_bound_y_max=world_origin_y+MaxGridHeight*baseCellSize/2;
    camera_bias_x=0;
    camera_bias_y=0;
    select_x=0
    select_y=0
    SelectedMode=true
    Help=false
    ZoomFactor=1;

    initMainMenuCursor()

    initCursor(mapWidthCount/2,mapHeightCount/2)
    initMap()
    setTileMap()

    t=0
    counter = 0
    timer = 0.0
    tiker = 0.0
    frameCounter = 0
    frametiker = 0

    score = 0
    gridSize=cellSize
    --gridSize = mapSize / mapLineCount
    --cellSize = mapSize / mapLineCount - 10

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
