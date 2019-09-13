require("Code/DesignerConfigs/DesignerConf")
-- initalize the flag used in the BFS and DFS
function initMapCalculation()
    driverIncome = 100
    networkIncome = 100
    networkScores = {50, 75, 100, 125, 150, 175, 200, 200}
    edgeIncome = 50

    PCBCost = 10
    netCable = 100
    bridgeCost = 300
    serverCost = 200
    dirverCost = 75
    processCost = 300
    heatSinkCost = 200

    for i = 1, mapWidthCount do
        for j = 1, mapHeightCount do
            if not (mapData[i][j] == nil) then
                mapData[i][j].FlagProcessor = 0
                mapData[i][j].ProcessorVisited = 0
                mapData[i][j].NetworkDepth = -1
                mapData[i][j].NetworkQueue = -1
                -- resetOnOff
                mapData[i][j].idOnOff = 0000
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
    -- local SideGrass = ParllelCSideID
    -- local SideLoad = fenceSideID
    -- return (sideID == SideGrass) or (sideID == SideLoad)
    return (offSideID == sideID)
end

function IsSpreadableNetwork(sideID) return (sideID == SerialCSideID) end

-- make a BFS on the Drivers 
-- mark the FlagProcessor as the target processorID
-- (now the processorID is always 1, there can be multiply processors in the game)
function BFS_Driver(x, y, processorID)
    -- have chance to STACKOVERFLOW
    -- will error out when involve with network disk combination

    if x < 1 or x > mapWidthCount then return end
    if y < 1 or y > mapHeightCount then return end
    if mapData[x][y] == nil then return end
    if mapData[x][y].FlagProcessor > 0 then return end
    if mapData[x][y].ProcessorVisited > 0 then return end

    local coreID = extractDataByPtr(mapData[x][y].id, 0)

    if coreID == driverCoreID or coreID == processorCoreID then
        mapData[x][y].FlagProcessor = processorID
    end

    mapData[x][y].ProcessorVisited = 1

    local westID = getRotatedSide_Single(1, mapData[x][y].id,
                                         mapData[x][y].rotation)
    local northID = getRotatedSide_Single(2, mapData[x][y].id,
                                          mapData[x][y].rotation)
    local southID = getRotatedSide_Single(3, mapData[x][y].id,
                                          mapData[x][y].rotation)
    local eastID = getRotatedSide_Single(4, mapData[x][y].id,
                                         mapData[x][y].rotation)

    if IsSpreadableDriverSide(westID) then
        if checkConnection(x, y, 1) then
            -- if coreID == driverCoreID or coreID == processorCoreID then
            mapData[x][y].idOnOff = SetSideOnOff(mapData[x][y].idOnOff,
                                                 rotatePtr(1, mapData[x][y]
                                                               .rotation), 1)
            -- end
            BFS_Driver(x - 1, y, processorID)
        end
    end
    if IsSpreadableDriverSide(northID) then
        if checkConnection(x, y, 2) then
            -- if coreID == driverCoreID or coreID == processorCoreID then
            mapData[x][y].idOnOff = SetSideOnOff(mapData[x][y].idOnOff,
                                                 rotatePtr(2, mapData[x][y]
                                                               .rotation), 1)
            -- end
            BFS_Driver(x, y - 1, processorID)
        end
    end
    if IsSpreadableDriverSide(southID) then
        if checkConnection(x, y, 3) then
            -- if coreID == driverCoreID or coreID == processorCoreID then
            mapData[x][y].idOnOff = SetSideOnOff(mapData[x][y].idOnOff,
                                                 rotatePtr(3, mapData[x][y]
                                                               .rotation), 1)
            -- end
            BFS_Driver(x, y + 1, processorID)
        end
    end
    if IsSpreadableDriverSide(eastID) then
        if checkConnection(x, y, 4) then
            -- if coreID == driverCoreID or coreID == processorCoreID then
            mapData[x][y].idOnOff = SetSideOnOff(mapData[x][y].idOnOff,
                                                 rotatePtr(4, mapData[x][y]
                                                               .rotation), 1)
            -- end
            BFS_Driver(x + 1, y, processorID)
        end
    end

    -- if coreID == processorCoreID then print(mapData[x][y].idOnOff) end
end

-- pre calculate network
function preDFSNetwork()
    for i = 1, mapWidthCount do
        for j = 1, mapHeightCount do
            if not (mapData[i][j] == nil) then
                local coreID = extractDataByPtr(mapData[i][j].id, 0)
                if coreID == serverCoreID then
                    DFS_Network(i, j, -1, 0)
                    -- assume only one server for now
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

function IsSpreadableNetworkSide(sideID) return (offSideID == sideID) end
-- DFS the network tiles
-- NetworkDepth == 0  => this tile is not searched
-- NetworkDepth == -1 => this tile is being searched, but has no result
-- NetworkDepth >0 => this tile has been searched, the number equals to the total number of connected tile
function DFS_Network(x, y, depth, queue)
    local currentdepth = depth + 1

    queue = queue * 100 + x * 10 + y

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

    mapData[x][y].NetworkQueue = queue

    -- print(currentdepth)
    local coreID = extractDataByPtr(mapData[x][y].id, 0)
    if coreID == networkCableCoreID or coreID == serverCoreID or coreID ==
        brigeCoreID then
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
                mapData[x][y].idOnOff = SetSideOnOff(mapData[x][y].idOnOff,
                                                     rotatePtr(1, mapData[x][y]
                                                                   .rotation), 2)
                DFS_Network(x - 1, y, currentdepth, queue)
            end
        end
        if IsSpreadableNetwork(northID) then
            if checkConnection(x, y, 2) then
                mapData[x][y].idOnOff = SetSideOnOff(mapData[x][y].idOnOff,
                                                     rotatePtr(2, mapData[x][y]
                                                                   .rotation), 2)
                DFS_Network(x, y - 1, currentdepth, queue)
            end
        end
        if IsSpreadableNetwork(southID) then
            if checkConnection(x, y, 3) then
                mapData[x][y].idOnOff = SetSideOnOff(mapData[x][y].idOnOff,
                                                     rotatePtr(3, mapData[x][y]
                                                                   .rotation), 2)
                DFS_Network(x, y + 1, currentdepth, queue)
            end
        end
        if IsSpreadableNetwork(eastID) then
            if checkConnection(x, y, 4) then
                mapData[x][y].idOnOff = SetSideOnOff(mapData[x][y].idOnOff,
                                                     rotatePtr(4, mapData[x][y]
                                                                   .rotation), 2)
                DFS_Network(x + 1, y, currentdepth, queue)
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
    -- this currently only calculate necessary longest path
    -- and havn't account for bridge
    local maxDepth = -1
    local longestQueue = 0
    for i = 1, mapWidthCount do
        for j = 1, mapHeightCount do
            if not (mapData[i][j] == nil) then
                local coreID = extractDataByPtr(mapData[i][j].id, 0)
                if coreID == networkCableCoreID or coreID == brigeCoreID then
                    if mapData[i][j].NetworkDepth >= maxDepth then
                        maxDepth = mapData[i][j].NetworkDepth
                        longestQueue = mapData[i][j].NetworkQueue
                    end
                end
            end
        end
    end
    -- print(maxDepth)
    -- print(longestQueue)--queue length= maxDepth + 1
    local queueTmp = longestQueue
    -- Here,use not longest Queue to turn off network side.
    local bgdmultiplier = 1
    for i = 0, maxDepth do
        local xy = queueTmp % 100
        local y = xy % 10
        local x = math.floor(xy / 10)
        queueTmp = math.floor(queueTmp / 100)

        maxDepth = math.max(maxDepth, 0)
        -- server doesn't count as score in chain of network
        -- however muliple same longest path select if has bridge is by random 
    end

    -- for i = 1, mapWidthCount do
    --     for j = 1, mapHeightCount do
    --         if not (mapData[i][j] == nil) then
    --             for k = 0, maxDepth do
    --                 local xy = queueTmp % 100
    --                 local y = xy % 10
    --                 local x = math.floor(xy / 10)
    --                 queueTmp = math.floor(queueTmp / 100)

    --                 -- could also turn on animation of network here
    --                 if x == i and y == j then
    --                     if brigeCoreID == extractDataByPtr(mapData[x][y].id, 0) then
    --                         bgdmultiplier = bgdmultiplier * 2
    --                     end
    --                 else
    --                     if GetSideOnOff(mapData[x][y].idOnOff,1)==2 then
    --                         SetSideOnOff(mapData[x][y].idOnOff,1,0);
    --                     end
    --                     if GetSideOnOff(mapData[x][y].idOnOff,2)==2 then
    --                         SetSideOnOff(mapData[x][y].idOnOff,2,0);
    --                     end
    --                     if GetSideOnOff(mapData[x][y].idOnOff,3)==2 then
    --                         SetSideOnOff(mapData[x][y].idOnOff,3,0);
    --                     end
    --                     if GetSideOnOff(mapData[x][y].idOnOff,4)==2 then
    --                         SetSideOnOff(mapData[x][y].idOnOff,4,0);
    --                     end
    --                 end
    --             end
    --         end
    --     end

    return (maxDepth) * networkIncome * bgdmultiplier
end

function evaluateEdge()
    local count = 0
    for i = 1, mapWidthCount do
        for j = 1, mapHeightCount do
            count = count + calculateEdge(i, j) * edgeIncome
        end
    end
    -- TODO Redo
    return 0
end

function evaluateCost()
    local cost = 0
    for i = 1, mapWidthCount do
        for j = 1, mapHeightCount do
            if not (mapData[i][j] == nil) then
                local coreID = extractDataByPtr(mapData[i][j].id, 0)
                -- print(coreID)
                cost = cost + getCostByID(coreID)
            end
        end
    end
    return cost
end

function hasAnyCPU()
    for i = 1, mapWidthCount do
        for j = 1, mapHeightCount do
            if not (mapData[i][j] == nil) then
                local coreID = extractDataByPtr(mapData[i][j].id, 0)
                if coreID == processorCoreID then return true end
            end
        end
    end
end

function hasAnyServer()
    for i = 1, mapWidthCount do
        for j = 1, mapHeightCount do
            if not (mapData[i][j] == nil) then
                local coreID = extractDataByPtr(mapData[i][j].id, 0)
                if coreID == serverCoreID then return true end
            end
        end
    end
end
