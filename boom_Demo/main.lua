require("Code/Resource/ResourceMgr")
require("Code/GameCore/PlayerMgr")
require("Code/GameStateSwh")
-- tmd on DEOT we can't use Chinese comment
-- DON'T write Chinese comment.

function love.load()
    
    loadResource()
    initTiles()
    gameState = 0

    debug_direc tGame = true
    -- debug_directGame = false
    if debug_directGame then gameState = 1 end

    windowWidth = 320
    windowHeight = 240

    love.window.setMode(windowWidth, windowHeight, {resizable = false})

    mapULoffsetX = 52
    mapULoffsetY = 1
    mapLineCount = map_size.w
    mapWidthCount = map_size.w
    mapHeightCount = map_size.h

    camera_width=windowWidth
    camera_height=windowHeight
    baseCellSize=32
    cellSize=32;
    MaxGridWidth=6;
    MaxGridHeight=6;

    world_origin_x=camera_width/2-mapULoffsetX
    world_origin_y=camera_height/2-mapULoffsetY

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

    t=0
    counter = 0
    timer = 0.0
    tiker = 0.0
    frameCounter = 0
    frametiker = 0

    gridSize=cellSize

    win = false
    -- haveSetRandomSeed = false

    -- now random destory should implement
    ---need update random seed per game---DONE
    ---need mutiple random destory---DONE
    ----should be configurable---DONE
    ---need presudo-random interval
    ----should be configurable

    -- cost system should implement
    -- shop system should implement
    destoryInterval = 99
    destoryCount =2
    destoryCounter = destoryInterval
    nextDestoryPosX = nil
    nextDestoryPosY = nil
    stepDrawSwch = false
    drawDestoryCursorSwch = false
    
    love.math.setRandomSeed(love.timer.getTime())
    changeGameStateTo(gameState)

    processorCoreID=5
    driverCoreID=4
    brigeCoreID=3
    serverCoreID=2
    networkCableCoreID=1
    PCBCoreID=0
    
    PCBSideID=0
    SerialCSideID=1
    ParllelCSideID=2
    fenceSideID=3
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
