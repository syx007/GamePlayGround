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

    win = false
    hold_buying = false
    buying_ptr = 0
    -- haveSetRandomSeed = false

    noSideID = 0
    offSideID = 1
    -- onSideID = 2 -- ?

    nextDestoryPosX = nil
    nextDestoryPosY = nil
    stepDrawSwch = false
    drawDestoryCursorSwch = false

    haveBoughtInShop = false
    haveBoughtInShopWaring = false
    inWarningState = false
    
    noGoodSideCount=0

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
    love.audio.stop()
    initGameOverCursor()
end
function reloadScreenViewScore()
    -- body
    love.audio.stop()
end
