function initMapCalculation()
    for i = 1, mapWidthCount do
        for j = 1, mapHeightCount do
            -- print('init map %d %d',i,j)
            if not(mapData[i][j] == nil) then
                mapData[i][j].greenFlag = 0
                mapData[i][j].blueFlag = 0
            end
        end
    end
end


-- local coreID=extractDataByPtr(mapData[i][j].id,0);
-- local westID=getRotatedSide_Single(1,mapData[i][j].id,mapData[i][j].rotation);
-- local northID=getRotatedSide_Single(2,mapData[i][j].id,mapData[i][j].rotation);
-- local southID=getRotatedSide_Single(3,mapData[i][j].id,mapData[i][j].rotation);
-- local eastID=getRotatedSide_Single(4,mapData[i][j].id,mapData[i][j].rotation);

function getGreenCore()
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

function checkConnection(x,y,rotation)
    if x < 1 or x > mapWidthCount then
        return false
    end
    if y < 1 or y > mapHeightCount then
        return false
    end
    
    if mapData[x][y] == nil then
        return false
    end

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
        return false
    end
    if yy < 1 or yy > mapHeightCount then
        return false
    end

    if mapData[xx][yy] == nil then
        return false
    end

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
    
    return selfSide == nextSide

end

function calculateGreen(x,y,processorID)
    if x < 1 or x > mapWidthCount then
        return 
    end
    if y < 1 or y > mapHeightCount then
        return 
    end
    if mapData[x][y] == nil then
        return 
    end
    if mapData[x][y].greenFlag > 0 then 
        return
    end

    local targetCore = 3
    local targetSide = 2

    local coreID=extractDataByPtr(mapData[x][y].id,0);
    if coreID == 4 or coreID == targetCore then

        local westID=getRotatedSide_Single(1,mapData[x][y].id,mapData[x][y].rotation);
        local northID=getRotatedSide_Single(2,mapData[x][y].id,mapData[x][y].rotation);
        local southID=getRotatedSide_Single(3,mapData[x][y].id,mapData[x][y].rotation);
        local eastID=getRotatedSide_Single(4,mapData[x][y].id,mapData[x][y].rotation);
    
        mapData[x][y].greenFlag = processorID

        if westID == targetSide and checkConnection(x,y,1) then
            calculateGreen(x-1,y,processorID);
        end
        if northID == targetSide and checkConnection(x,y,2) then
            calculateGreen(x,y-1,processorID);
        end
        if southID == targetSide and checkConnection(x,y,3) then
            calculateGreen(x,y+1,processorID);
        end
        if eastID == targetSide and checkConnection(x,y,4) then
            calculateGreen(x+1,y,processorID);
        end
    end

end

function calculateBlue()
    for i = 1, mapWidthCount do
        for j = 1, mapHeightCount do
            if not(mapData[i][j] == nil) then
                local coreID=extractDataByPtr(mapData[i][j].id,0);
                if coreID == 1 and mapData[i][j].blueFlag == 0 then
                    DFS_Blue(i,j,-1,0)
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

function DFS_Blue(x,y,lastStep,total)
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
    if coreID == targetCore and mapData[x][y].blueFlag == 0 then

        
        local westID=getRotatedSide_Single(1,mapData[x][y].id,mapData[x][y].rotation);
        local northID=getRotatedSide_Single(2,mapData[x][y].id,mapData[x][y].rotation);
        local southID=getRotatedSide_Single(3,mapData[x][y].id,mapData[x][y].rotation);
        local eastID=getRotatedSide_Single(4,mapData[x][y].id,mapData[x][y].rotation);
    
        mapData[x][y].blueFlag = -1

        local res = total+1;
        if westID == targetSide and checkConnection(x,y,1) and not(lastStep==4) then
            res = max(DFS_Blue(x-1,y,1,total+1),res);
        end
        if northID == targetSide and checkConnection(x,y,2) and not(lastStep==3) then
            res = max(DFS_Blue(x,y-1,2,total+1),res);
        end
        if southID == targetSide and checkConnection(x,y,3) and not(lastStep==2) then
            res = max(DFS_Blue(x,y+1,3,total+1),res);
        end
        if eastID == targetSide and checkConnection(x,y,4) and not(lastStep==1) then
            res = max(DFS_Blue(x+1,y,4,total+1),res);
        end

        mapData[x][y].blueFlag = res;


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

    local targetCore = 1 -- lake
    local neighbourCore = 3 -- mill
    local targetSide = 2 -- grass


    local coreID=extractDataByPtr(mapData[x][y].id,0);

    local res = 0

    if coreID == targetCore then
        local westID=getRotatedSide_Single(1,mapData[x][y].id,mapData[x][y].rotation);
        local northID=getRotatedSide_Single(2,mapData[x][y].id,mapData[x][y].rotation);
        local southID=getRotatedSide_Single(3,mapData[x][y].id,mapData[x][y].rotation);
        local eastID=getRotatedSide_Single(4,mapData[x][y].id,mapData[x][y].rotation);
    
        if westID == targetSide and checkConnection(x,y,1) and getNeighbourCoreID(x,y,1) == neighbourCore then
            res = res + 1
        end
        if northID == targetSide and checkConnection(x,y,2) and getNeighbourCoreID(x,y,2) == neighbourCore then
            res = res + 1
        end
        if southID == targetSide and checkConnection(x,y,3) and getNeighbourCoreID(x,y,3) == neighbourCore then
            res = res + 1
        end
        if eastID == targetSide and checkConnection(x,y,4) and getNeighbourCoreID(x,y,4) == neighbourCore then
            res = res + 1
        end
    end
    return res
end



function sumGreen()
    local count = 0
    for i = 1, mapWidthCount do
        for j = 1, mapHeightCount do
            if not(mapData[i][j] == nil) then
                local coreID=extractDataByPtr(mapData[i][j].id,0);
                if coreID == 3 and mapData[i][j].greenFlag > 0 then
                    count = count + 100
                end
            end
        end
    end
    return count
end

function sumBlue()
    local count = 0
    local blueScores = {50,75,100,125,150,175,200,200}
    for i = 1, mapWidthCount do
        for j = 1, mapHeightCount do
            if not(mapData[i][j] == nil) then
                local coreID=extractDataByPtr(mapData[i][j].id,0);
                if coreID == 1 and mapData[i][j].blueFlag > 0 then
                    count = count + blueScores[min(8,mapData[i][j].blueFlag)]
                end
            end
        end
    end
    return count
end

function sumEdge()
    local count = 0
    for i = 1, mapWidthCount do
        for j = 1, mapHeightCount do
            count = count + calculateEdge(i,j) * 50
        end
    end

    return count

end

