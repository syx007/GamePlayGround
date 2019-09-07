-- initalize the flag used in the BFS and DFS
function initMapCalculation()
    driverScore = 100
    networkScores = {50,75,100,125,150,175,200,200}
    edgeScore = 50

    for i = 1, mapWidthCount do
        for j = 1, mapHeightCount do
            if not(mapData[i][j] == nil) then
                mapData[i][j].FlagProcessor = 0
                mapData[i][j].FlagNetwork = 0
            end
        end
    end
end

-- get the position of the processor
-- return : mapData, with indexX and indexY set to x,y
function getProcessor()
    for i = 1, mapWidthCount do
        for j = 1, mapHeightCount do
            if not(mapData[i][j] == nil) then
                local coreID=extractDataByPtr(mapData[i][j].id,0);
                if coreID == 4 then
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
function getNeighbourCoreID(x,y,rotation)

    local xx , yy
    if rotation == 1 then -- west 
        xx = x - 1
        yy = y
    elseif rotation == 2 then -- north
        xx = x
        yy = y - 1
    elseif rotation == 3 then -- south
        xx = x 
        yy = y + 1
    else -- east
        xx = x + 1
        yy = y
    end


    if xx < 1 or xx > mapWidthCount then
        return -1
    end
    if yy < 1 or yy > mapHeightCount then
        return -1
    end

    if mapData[xx][yy] == nil then
        return -1
    end

    local coreID = extractDataByPtr(mapData[xx][yy].id,0);
    return coreID
end

function checkConnectionOverNetwork(x,y,rotation)
    
    -- calculate the (xx,yy) of the neighbour 
    local xx , yy
    if rotation == 1 then -- west 
        xx = x - 1
        yy = y
    elseif rotation == 2 then -- north
        xx = x
        yy = y - 1
    elseif rotation == 3 then -- south
        xx = x 
        yy = y + 1
    else -- east
        xx = x + 1
        yy = y
    end

    local networkCoreID = 1

    return getNeighbourCoreID(x,y,rotation) == networkCoreID and checkConnection(x,y,rotation) and checkConnection(xx,yy,rotation)
end

-- check if the connection between two tile is succcessful
-- notice that the grass (2) can connect with load(3)
function checkConnection(x,y,rotation)

    -- validate the (x,y)
    if x < 1 or x > mapWidthCount then
        return false
    end
    if y < 1 or y > mapHeightCount then
        return false
    end
    
    if mapData[x][y] == nil then
        return false
    end

    -- calculate the (xx,yy) of the neighbour 
    local xx , yy
    if rotation == 1 then -- west 
        xx = x - 1
        yy = y
    elseif rotation == 2 then -- north
        xx = x
        yy = y - 1
    elseif rotation == 3 then -- south
        xx = x 
        yy = y + 1
    else -- east
        xx = x + 1
        yy = y
    end

    -- validate the (xx,yy)
    if xx < 1 or xx > mapWidthCount then
        return false
    end
    if yy < 1 or yy > mapHeightCount then
        return false
    end

    if mapData[xx][yy] == nil then
        return false
    end

    -- find the connected rotation of the neighbour
    local selfRot , nextRot 
    if rotation == 1 then -- west 
        selfRot = 1
        nextRot = 4
    elseif rotation == 2 then -- north
        selfRot = 2
        nextRot = 3
    elseif rotation == 3 then -- south
        selfRot = 3
        nextRot = 2
    else -- east
        selfRot = 4
        nextRot = 1
    end

    -- print(selfRot,nextRot)
    local selfSide = getRotatedSide_Single(selfRot,mapData[x][y].id,mapData[x][y].rotation);
    local nextSide = getRotatedSide_Single(nextRot,mapData[xx][yy].id,mapData[xx][yy].rotation);
    -- print(x,y,xx,yy,mapData[x][y].id, mapData[x][y].rotation,selfSide,mapData[xx][yy].id, mapData[xx][yy].rotation,nextSide)
    
    return (selfSide == nextSide) or ( selfSide + nextSide == 5)

end

function IsSpreadableDriverSide(sideID)
    local SideGrass = 2
    local SideLoad = 3
    return (sideID == SideGrass) or (sideID == SideLoad)
end

-- make a BFS on the Drivers 
-- mark the FlagProcessor as the target processorID
-- (now the processorID is always 1, there can be multiply processors in the game)
function BFS_Driver(x,y,processorID)
    if x < 1 or x > mapWidthCount then
        return 
    end
    if y < 1 or y > mapHeightCount then
        return 
    end
    if mapData[x][y] == nil then
        return 
    end
    if mapData[x][y].FlagProcessor > 0 then 
        return
    end

    local targetCore = 3
    local SideGrass = 2
    local SideLoad = 3

    local coreID=extractDataByPtr(mapData[x][y].id,0);
    if coreID == 4 or coreID == targetCore then

        local westID=getRotatedSide_Single(1,mapData[x][y].id,mapData[x][y].rotation);
        local northID=getRotatedSide_Single(2,mapData[x][y].id,mapData[x][y].rotation);
        local southID=getRotatedSide_Single(3,mapData[x][y].id,mapData[x][y].rotation);
        local eastID=getRotatedSide_Single(4,mapData[x][y].id,mapData[x][y].rotation);
    
        mapData[x][y].FlagProcessor = processorID

        if IsSpreadableDriverSide(westID) then 
            if checkConnection(x,y,1) then
                BFS_Driver(x-1,y,processorID);
            end
            if checkConnectionOverNetwork(x,y,1) then
                BFS_Driver(x-2,y,processorID);
            end
        end
        if IsSpreadableDriverSide(northID) then 
            if checkConnection(x,y,2) then
                BFS_Driver(x,y-1,processorID);
            end
            if checkConnectionOverNetwork(x,y,2) then
                BFS_Driver(x,y-2,processorID);
            end
        end
        if IsSpreadableDriverSide(southID) then 
            if checkConnection(x,y,3) then
                BFS_Driver(x,y+1,processorID);
            end
            if checkConnectionOverNetwork(x,y,3) then
                BFS_Driver(x,y+2,processorID);
            end
        end
        if IsSpreadableDriverSide(eastID) then 
            if checkConnection(x,y,4) then
                BFS_Driver(x+1,y,processorID);
            end
            if checkConnectionOverNetwork(x,y,4) then
                BFS_Driver(x+2,y,processorID);
            end
        end
        -- if IsSpreadableDriverSide(northID) and checkConnection(x,y,2) then
        --     BFS_Driver(x,y-1,processorID);
        -- end
        -- if IsSpreadableDriverSide(southID) and checkConnection(x,y,3) then
        --     BFS_Driver(x,y+1,processorID);
        -- end
        -- if IsSpreadableDriverSide(eastID) and checkConnection(x,y,4) then
        --     BFS_Driver(x+1,y,processorID);
        -- end
    end

end

-- pre calculate network
function preDFSNetwork()
    for i = 1, mapWidthCount do
        for j = 1, mapHeightCount do
            if not(mapData[i][j] == nil) then
                local coreID=extractDataByPtr(mapData[i][j].id,0);
                if coreID == 1 and mapData[i][j].FlagNetwork == 0 then
                    DFS_Network(i,j,-1,0)
                end
            end
        end
    end
end

function max(x,y)
    if (x > y )then
        return x
    else
        return y
    end
end

function min(x,y)
    if (x < y )then
        return x
    else
        return y
    end
end


function IsSpreadableNetworkSide(sideID)
    local SideWater = 1
    return (sideID == SideWater)
end
-- DFS the network tiles
-- FlagNetwork == 0  => this tile is not searched
-- FlagNetwork == -1 => this tile is being searched, but has no result
-- FlagNetwork >0 => this tile has been searched, the number equals to the total number of connected tile
function DFS_Network(x,y,lastStep,total)
    if x < 1 or x > mapWidthCount then
        return total
    end
    if y < 1 or y > mapHeightCount then
        return total
    end
    if mapData[x][y] == nil then
        return total
    end

    local targetCore = 1 -- lake
    local targetSide = 1 -- water

    local coreID=extractDataByPtr(mapData[x][y].id,0);
    if coreID == targetCore and mapData[x][y].FlagNetwork == 0 then

        local westID=getRotatedSide_Single(1,mapData[x][y].id,mapData[x][y].rotation);
        local northID=getRotatedSide_Single(2,mapData[x][y].id,mapData[x][y].rotation);
        local southID=getRotatedSide_Single(3,mapData[x][y].id,mapData[x][y].rotation);
        local eastID=getRotatedSide_Single(4,mapData[x][y].id,mapData[x][y].rotation);
    
        mapData[x][y].FlagNetwork = -1

        local res = total+1;
        if IsSpreadableNetworkSide(westID) and checkConnection(x,y,1) and not(lastStep==4) then
            res = max(DFS_Network(x-1,y,1,total+1),res);
        end
        if IsSpreadableNetworkSide(northID) and checkConnection(x,y,2) and not(lastStep==3) then
            res = max(DFS_Network(x,y-1,2,total+1),res);
        end
        if IsSpreadableNetworkSide(southID) and checkConnection(x,y,3) and not(lastStep==2) then
            res = max(DFS_Network(x,y+1,3,total+1),res);
        end
        if IsSpreadableNetworkSide(eastID) and checkConnection(x,y,4) and not(lastStep==1) then
            res = max(DFS_Network(x+1,y,4,total+1),res);
        end

        mapData[x][y].FlagNetwork = res;


        return res
    end

    return total
end



function calculateEdge(x,y)

    if x < 1 or x > mapWidthCount then
        return 0
    end
    if y < 1 or y > mapHeightCount then
        return 0
    end
    if mapData[x][y] == nil then
        return 0
    end

    local targetCore = 3 -- driver
    local neighbourCore = 1 -- network
    -- local targetSide = 2 -- grass

    local data = mapData[x][y]
    local coreID=extractDataByPtr(data.id,0);

    local res = 0

    if coreID == targetCore and data.FlagProcessor > 0 then

        local westID=getRotatedSide_Single(1,data.id,data.rotation);
        local northID=getRotatedSide_Single(2,data.id,data.rotation);
        local southID=getRotatedSide_Single(3,data.id,data.rotation);
        local eastID=getRotatedSide_Single(4,data.id,data.rotation);
    
        if IsSpreadableDriverSide(westID) and checkConnection(x,y,1) and getNeighbourCoreID(x,y,1) == neighbourCore  then
            res = res + 1
        end
        if IsSpreadableDriverSide(northID) and checkConnection(x,y,2) and getNeighbourCoreID(x,y,2) == neighbourCore then
            res = res + 1
        end
        if IsSpreadableDriverSide(southID) and checkConnection(x,y,3) and getNeighbourCoreID(x,y,3) == neighbourCore then
            res = res + 1
        end
        if IsSpreadableDriverSide(eastID) and checkConnection(x,y,4) and getNeighbourCoreID(x,y,4) == neighbourCore then
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
            if not(mapData[i][j] == nil) then
                local coreID=extractDataByPtr(mapData[i][j].id,0);
                if coreID == 3 and mapData[i][j].FlagProcessor > 0 then
                    count = count + driverScore 
                end
            end
        end
    end
    return count
end

function evaluateNetwork()
    local count = 0
    for i = 1, mapWidthCount do
        for j = 1, mapHeightCount do
            if not(mapData[i][j] == nil) then
                local coreID=extractDataByPtr(mapData[i][j].id,0);
                if coreID == 1 and mapData[i][j].FlagNetwork > 0 then
                    count = count + networkScores[min(table.getn(networkScores),mapData[i][j].FlagNetwork)]
                end
            end
        end
    end
    return count
end

function evaluateEdge()
    local count = 0
    for i = 1, mapWidthCount do
        for j = 1, mapHeightCount do
            count = count + calculateEdge(i,j) * edgeScore
        end
    end

    return count

end

