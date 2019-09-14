function getGameStateName(id)
    local StateName = {
        "Main Menu", "Playing Game", "Register Score", "View Score"
    }
    return StateName[id + 1]
end

function getCoreNameByID(id)
    -- print("id=",id)
    local CoreNameID = {
        "PCB", "NetworkCable", "Server", "Bridge", "Driver", "Processor",
        "Cooler", "BackPlate"
    }
    return CoreNameID[id + 1]
    -- use 0 based index
end

function getSideNameByID(id)
    local SideNameID = {
        "PCB", "SerialConnector", "ParallelConnector", "Firewall"
    }
    return SideNameID[id + 1]
    ----use 0 based index
end

function initTileMetaData()
    -- body
    heatSinkCoreID = 6
    processorCoreID = 5
    driverCoreID = 4
    brigeCoreID = 3
    serverCoreID = 2
    networkCableCoreID = 1
    PCBCoreID = 0

    PCBSideID = 0
    SerialCSideID = 1
    ParllelCSideID = 2
    fenceSideID = 3

    shopSidePer = {40, 35, 15, 10}

    autoQA = false
    couldOnlyBuyInShopOnce = true
end

function initGamePlayData()
    initCash = 10000.0
    stepCounterMax = 100
    destoryInterval = 5
    destoryCount = 4
    -- initCash = 1000000000.0
    -- stepCounterMax = 100
    -- destoryInterval = 9999999
    -- destoryCount = 4
end

function getPriceByCore(id)
    -- PCBPrice = 10
    -- netCablePrice = 50
    -- bridgePrice = 100
    -- serverPrice = 150
    -- dirverPrice = 50
    -- processPrice = 250
    -- heatSinkPrice = 400
    local CostID = {10, 50, 100, 130, 50, 230, 200}
    return CostID[id + 1]
end

function getPriceBySide(id)
    -- PCBSideID = 0
    -- SerialCSideID = 1
    -- ParllelCSideID = 2
    -- fenceSideID = 3
    local SideID = {0, 75, 15, 45}
    return SideID[id + 1]
end

function getCostByID(id)
    -- PCBCost = 1
    -- netCableCost = 10
    -- bridgeCost = 30
    -- serverCost = 20
    -- dirverCost = 75
    -- processCost = 30
    -- heatSinkCost = 20
    local CostID = {10, 15, 25, 35, 75, 85, 65}
    return CostID[id + 1]
end

function getTotalCoreCount() return 6 end

function getTotalSideCount() return 2 end
