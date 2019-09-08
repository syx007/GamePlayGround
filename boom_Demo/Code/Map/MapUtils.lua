-- initalize the flag used in the BFS and DFS
function initMapCalculation()
    driverIncome = 100
    networkScores = {50, 75, 100, 125, 150, 175, 200, 200}
    edgeIncome = 50

    for i = 1, mapWidthCount do
        for j = 1, mapHeightCount do
            if not (mapData[i][j] == nil) then
                mapData[i][j].FlagProcessor = 0
                mapData[i][j].NetworkDepth = -1
            end
        end
    end
end

-- get the position of the processor
-- return : mapData, with indexX and indexY set to x,y
function getProcessor()
    for i = 1, mapWidthCount do
        for j = 1, mapHeightCount do
            if not (mapData[i][j] == nil) then
                local coreID = extractDataByPtr(mapData[i][j].id, 0)
                if coreID == processorCoreID then
                    mapData[i][j].indexX = i
                    mapData[i][j].indexY = j
                    return mapData[i][j]
                end
            end
        end
    end

    return nil
end

-- get the coreID of the neighbour
-- return -1 if the index overflow or the mapData is nil
function getNeighbourCoreID(x, y, rotation)

    local offset = posOffsetByConnectivity(rotation)
    local xx, yy
    xx = x + offset[1]
    yy = y + offset[2]

    if xx < 1 or xx > mapWidthCount then return -1 end
    if yy < 1 or yy > mapHeightCount then return -1 end

    if mapData[xx][yy] == nil then return -1 end

    local coreID = extractDataByPtr(mapData[xx][yy].id, 0)
    return coreID
end

-- check if the connection between two tile is succcessful
-- notice that the grass (2) can connect with load(3)
function checkConnection(x, y, rotation)

    -- validate the (x,y)
    if x < 1 or x > mapWidthCount then return false end
    if y < 1 or y > mapHeightCount then return false end

    if mapData[x][y] == nil then return false end

    -- calculate the (xx,yy) of the neighbour 
    local offset = posOffsetByConnectivity(rotation)
    local xx, yy
    xx = x + offset[1]
    yy = y + offset[2]

    -- validate the (xx,yy)
    if xx < 1 or xx > mapWidthCount then return false end
    if yy < 1 or yy > mapHeightCount then return false end

    if mapData[xx][yy] == nil then return false end

    -- find the connected rotation of the neighbour
    local selfWorldSide = rotation
    local nextWorldSide = 5 - rotation

    -- print(selfRot,nextRot)
    local selfSideData = getRotatedSide_Single(selfWorldSide, mapData[x][y].id,
                                               mapData[x][y].rotation)
    local nextSideData = getRotatedSide_Single(nextWorldSide,
                                               mapData[xx][yy].id,
                                               mapData[xx][yy].rotation)
    -- print(x,y,xx,yy,mapData[x][y].id, mapData[x][y].rotation,selfSide,mapData[xx][yy].id, mapData[xx][yy].rotation,nextSide)

    return (selfSideData == nextSideData) -- or (selfSide + nextSide == 5)

end

function IsSpreadableDriverSide(sideID)
    local SideGrass = ParllelCSideID
    local SideLoad = fenceSideID
    return (sideID == SideGrass) or (sideID == SideLoad)
end

function IsSpreadableNetwork(sideID)
    return (sideID == SerialCSideID)
end

-- make a BFS on the Drivers 
-- mark the FlagProcessor as the target processorID
-- (now the processorID is always 1, there can be multiply processors in the game)
function BFS_Driver(x, y, processorID)
    if x < 1 or x > mapWidthCount then return end
    if y < 1 or y > mapHeightCount then return end
    if mapData[x][y] == nil then return end
    if mapData[x][y].FlagProcessor > 0 then return end

    local coreID = extractDataByPtr(mapData[x][y].id, 0)
    if coreID == driverCoreID or coreID == processorCoreID then
        mapData[x][y].FlagProcessor = processorID
    end

    local westID = getRotatedSide_Single(1, mapData[x][y].id,
                                         mapData[x][y].rotation)
    local northID = getRotatedSide_Single(2, mapData[x][y].id,
                                          mapData[x][y].rotation)
    local southID = getRotatedSide_Single(3, mapData[x][y].id,
                                          mapData[x][y].rotation)
    local eastID = getRotatedSide_Single(4, mapData[x][y].id,
                                         mapData[x][y].rotation)

    if IsSpreadableDriverSide(westID) then
        -- print("Here")
        if checkConnection(x, y, 1) then
            BFS_Driver(x - 1, y, processorID)
        end
    end
    if IsSpreadableDriverSide(northID) then
        if checkConnection(x, y, 2) then
            BFS_Driver(x, y - 1, processorID)
        end
    end
    if IsSpreadableDriverSide(southID) then
        if checkConnection(x, y, 3) then
            BFS_Driver(x, y + 1, processorID)
        end
    end
    if IsSpreadableDriverSide(eastID) then
        if checkConnection(x, y, 4) then
            BFS_Driver(x + 1, y, processorID)
        end
    end
end

-- pre calculate network
function preDFSNetwork()
    for i = 1, mapWidthCount do
        for j = 1, mapHeightCount do
            if not (mapData[i][j] == nil) then
                local coreID = extractDataByPtr(mapData[i][j].id, 0)
                if coreID == serverCoreID then
                    DFS_Network(i, j, -1)
                    --assume only one server for now
                    return
                end
            end
        end
    end
end

function max(x, y)
    if (x > y) then
        return x
    else
        return y
    end
end

function min(x, y)
    if (x < y) then
        return x
    else
        return y
    end
end

function IsSpreadableNetworkSide(sideID)
    local SideWater = SerialCSideID
    return (sideID == SideWater)
end
-- DFS the network tiles
-- NetworkDepth == 0  => this tile is not searched
-- NetworkDepth == -1 => this tile is being searched, but has no result
-- NetworkDepth >0 => this tile has been searched, the number equals to the total number of connected tile
function DFS_Network(x, y, depth)
    local currentdepth = depth + 1
    if x < 1 or x > mapWidthCount then return end
    if y < 1 or y > mapHeightCount then return end
    if mapData[x][y] == nil then return end
    
    if mapData[x][y].NetworkDepth < 0 then
        mapData[x][y].NetworkDepth = currentdepth
    elseif mapData[x][y].NetworkDepth <= currentdepth then
        return
    elseif mapData[x][y].NetworkDepth > currentdepth then
        mapData[x][y].NetworkDepth = currentdepth
    end
    
    -- print(currentdepth)
    local coreID = extractDataByPtr(mapData[x][y].id, 0)
    if coreID == networkCableCoreID or coreID == serverCoreID then
        local westID = getRotatedSide_Single(1, mapData[x][y].id,
                                             mapData[x][y].rotation)
        local northID = getRotatedSide_Single(2, mapData[x][y].id,
                                              mapData[x][y].rotation)
        local southID = getRotatedSide_Single(3, mapData[x][y].id,
                                              mapData[x][y].rotation)
        local eastID = getRotatedSide_Single(4, mapData[x][y].id,
                                             mapData[x][y].rotation)
    
        if IsSpreadableNetwork(westID) then
            if checkConnection(x, y, 1) then
                DFS_Network(x - 1, y, currentdepth)
            end
        end
        if IsSpreadableNetwork(northID) then
            if checkConnection(x, y, 2) then
                DFS_Network(x, y - 1, currentdepth)
            end
        end
        if IsSpreadableNetwork(southID) then
            if checkConnection(x, y, 3) then
                DFS_Network(x, y + 1, currentdepth)
            end
        end
        if IsSpreadableNetwork(eastID) then
            if checkConnection(x, y, 4) then
                DFS_Network(x + 1, y, currentdepth)
            end
        end
    end
end

function calculateEdge(x, y)

    if x < 1 or x > mapWidthCount then return 0 end
    if y < 1 or y > mapHeightCount then return 0 end
    if mapData[x][y] == nil then return 0 end

    local targetCore = processorCoreID -- driver
    local neighbourCore = networkCableCoreID -- network
    -- local targetSide = 2 -- grass

    local data = mapData[x][y]
    local coreID = extractDataByPtr(data.id, 0)

    local res = 0

    if coreID == targetCore and data.FlagProcessor > 0 then

        local westID = getRotatedSide_Single(1, data.id, data.rotation)
        local northID = getRotatedSide_Single(2, data.id, data.rotation)
        local southID = getRotatedSide_Single(3, data.id, data.rotation)
        local eastID = getRotatedSide_Single(4, data.id, data.rotation)

        if IsSpreadableDriverSide(westID) and checkConnection(x, y, 1) and
            getNeighbourCoreID(x, y, 1) == neighbourCore then
            res = res + 1
        end
        if IsSpreadableDriverSide(northID) and checkConnection(x, y, 2) and
            getNeighbourCoreID(x, y, 2) == neighbourCore then
            res = res + 1
        end
        if IsSpreadableDriverSide(southID) and checkConnection(x, y, 3) and
            getNeighbourCoreID(x, y, 3) == neighbourCore then
            res = res + 1
        end
        if IsSpreadableDriverSide(eastID) and checkConnection(x, y, 4) and
            getNeighbourCoreID(x, y, 4) == neighbourCore then
            res = res + 1
        end
    end
    return res
end

-- calculate the total score of the drive based on the FlagProcessor
function evaluateDriver()
    local count = 0
    for i = 1, mapWidthCount do
        for j = 1, mapHeightCount do
            if not (mapData[i][j] == nil) then
                local coreID = extractDataByPtr(mapData[i][j].id, 0)
                if coreID == driverCoreID and mapData[i][j].FlagProcessor > 0 then
                    count = count + driverIncome
                end
            end
        end
    end
    return count
end

function evaluateNetwork()
    --this currently only calculate necessary longest path
    --and havn't account for bridge
    local maxDepth = -1
    for i = 1, mapWidthCount do
        for j = 1, mapHeightCount do
            if not (mapData[i][j] == nil) then
                local coreID = extractDataByPtr(mapData[i][j].id, 0)
                if coreID == networkCableCoreID then
                    maxDepth=math.max(mapData[i][j].NetworkDepth,maxDepth)
                end
            end
        end
    end
    -- print(count)
    return maxDepth
end

function evaluateEdge()
    local count = 0
    for i = 1, mapWidthCount do
        for j = 1, mapHeightCount do
            count = count + calculateEdge(i, j) * edgeIncome
        end
    end

    return count

end

