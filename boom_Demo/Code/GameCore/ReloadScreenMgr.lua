function reloadScreenPlayingGame()
    -- body
    initCursor(mapWidthCount/2,mapHeightCount/2)
    initMap()
    setTileMap()

    -- init Score here, or get nil val
    driverIncome = 0.0
    blueIncome = 0.0
    edgeIncome = 0.0
    totalIncome = 0.0

    totalCost=0.0 --should be 0 or positive

    -- now we need reset these val
    totalCash = 1000.0

    stepCounterMax = 30
    stepCounter = stepCounterMax
end

function reloadScreenMainMenu()
    -- body
    initMainMenuCursor()
end
function reloadScreenRegisterScore()
    -- body
end
function reloadScreenViewScore()
    -- body
end
