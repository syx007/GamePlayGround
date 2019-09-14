function reloadScreenPlayingGame()
    shopContent = {00000, 00000, 00000, 00000}
    shopPrice = {150, 160, 170, 180}
    -- body
    initCursor(mapWidthCount / 2, mapHeightCount / 2)
    initMap()
    setTileMap()
    refreshShop()
    initGamePlayData()
    -- initTileMetaData()
    -- init Score here, or get nil val
    driverIncome = 0.0
    blueIncome = 0.0
    edgeIncome = 0.0
    totalIncome = 0.0

    totalCost = 0.0 -- should be 0 or positive

    -- now we need reset these val
    totalCash = initCash
    stepCounter = stepCounterMax
    destoryCounter = getRandomDestoryInterval()

    haveBoughtInShop = false
    haveBoughtInShopWaring = false

    endingData = {}
    endingData.endingCash = initCash
    endingData.endingTime = stepCounterMax

    love.audio.stop()
    -- Music.menu:play() --not yet PlayGameplayBGM
end

function reloadScreenMainMenu()
    -- body
    love.audio.stop()
    Music.menu:play() -- not yet
    initMainMenuCursor()
end
function reloadScreenRegisterScore()
    -- GameOver Screen
    -- body
    initGameOverCursor()
end
function reloadScreenViewScore()
    -- body
end
