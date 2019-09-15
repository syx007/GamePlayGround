require("Code/Resource/ResourceMgr")
require("Code/GameCore/PlayerMgr")
require("Code/GameStateSwh")
-- tmd on DEOT we can't use Chinese comment
-- DON'T write Chinese comment.

-- now random destory should implement ---DONE
---need update random seed per game---DONE
---need mutiple random destory---DONE
----should be configurable---DONE
---need presudo-random interval---DONE
----should be configurable---DONE

-- cost system should implement---DONE
---should expose to designer---DONE
-- shop system should implement---DONE
---should comply to core/side rules---DONE

-- should implement NetBridge ---DONE
-- should implement HeatSink
-- should implement “Smart Destory”

-- shop could only buy once per move---DONE
-- shop could sell Server/CPU---DONE

-- should deal with side with multipledata---DONE
-- is okay to show all network connector---DONE

function globalInit()
    -- this only do once
    loadResource()
    initTileMetaData()
    initTiles()
    gameState = 0

    -- debug_directGame = true
    debug_directGame = false
    if debug_directGame then gameState = 1 end

    debug_view = false

    windowWidth = 320
    windowHeight = 240

    love.window.setMode(windowWidth, windowHeight, {resizable = false})

    mapULoffsetX = 52
    mapULoffsetY = 1
    mapLineCount = map_size.w
    mapWidthCount = map_size.w
    mapHeightCount = map_size.h

    camera_width = windowWidth
    camera_height = windowHeight
    baseCellSize = 32
    cellSize = 32
    MaxGridWidth = 6
    MaxGridHeight = 6

    world_origin_x = camera_width / 2 - mapULoffsetX
    world_origin_y = camera_height / 2 - mapULoffsetY

    world_bound_x_min = world_origin_x - MaxGridWidth * baseCellSize / 2
    world_bound_x_max = world_origin_x + MaxGridWidth * baseCellSize / 2
    world_bound_y_min = world_origin_y - MaxGridHeight * baseCellSize / 2
    world_bound_y_max = world_origin_y + MaxGridHeight * baseCellSize / 2
    camera_bias_x = 0
    camera_bias_y = 0
    select_x = 0
    select_y = 0
    SelectedMode = true
    Help = false
    ZoomFactor = 1

    animationFCounter = 0
    counter = 0
    timer = 0.0
    tiker = 0.0
    frameCounter = 0
    frametiker = 0
    noGoodSideCount = 0
    gridSize = cellSize


    strmap={}
    for i=0,23 do
        strmap[i]={}
        for j=0,31 do
            strmap[i][j]={ch,alpha}
            strmap[i][j].ch="\0"
            strmap[i][j].alpha=0
        end
    end
    temp={}
    for i=0,31 do
        temp[i]={ch,alpha}
        temp[i].ch="\0"
        temp[i].alpha=0
    end

    love.math.setRandomSeed(love.timer.getTime())
    love.audio.setVolume(0.6)
end

function love.load()
    globalInit()
    changeGameStateTo(gameState)
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
    -- Entry Blocker
    mainDrawingSwitch(gameState)
end
