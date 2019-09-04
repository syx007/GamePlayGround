function initMapCalculation()
    for i = 1, mapWidthCount do
        for j = 1, mapHeightCount do
            -- print('init map %d %d',i,j)
            if not(mapData[i][j] == nil) then
                mapData[i][j].calFlag = 0
            end
        end
    end
end


-- local coreID=extractDataByPtr(mapData[i][j].id,0);
-- local westID=getRotatedSide_Single(1,mapData[i][j].id,mapData[i][j].rotation);
-- local northID=getRotatedSide_Single(2,mapData[i][j].id,mapData[i][j].rotation);
-- local southID=getRotatedSide_Single(3,mapData[i][j].id,mapData[i][j].rotation);
-- local eastID=getRotatedSide_Single(4,mapData[i][j].id,mapData[i][j].rotation);

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

function calculateProcessor(x,y,processorID)
    if x < 1 or x > mapWidthCount then
        return 
    end
    if y < 1 or y > mapHeightCount then
        return 
    end
    if mapData[x][y] == nil then
        return 
    end
    if mapData[x][y].calFlag > 0 then 
        return
    end

    local targetCore = 3
    local targetSide = 2


    local coreID=extractDataByPtr(mapData[x][y].id,0);
    local westID=getRotatedSide_Single(1,mapData[x][y].id,mapData[x][y].rotation);
    local northID=getRotatedSide_Single(2,mapData[x][y].id,mapData[x][y].rotation);
    local southID=getRotatedSide_Single(3,mapData[x][y].id,mapData[x][y].rotation);
    local eastID=getRotatedSide_Single(4,mapData[x][y].id,mapData[x][y].rotation);

    if coreID == 4 or coreID == targetCore then

        mapData[x][y].calFlag = processorID

        if westID == targetSide and checkConnection(x,y,1) then
            calculateProcessor(x-1,y,processorID);
        end
        if northID == targetSide and checkConnection(x,y,2) then
            calculateProcessor(x,y-1,processorID);
        end
        if southID == targetSide and checkConnection(x,y,3) then
            calculateProcessor(x,y+1,processorID);
        end
        if eastID == targetSide and checkConnection(x,y,4) then
            calculateProcessor(x+1,y,processorID);
        end
    end

end

function sumProcessor()
    count = 0
    for i = 1, mapWidthCount do
        for j = 1, mapHeightCount do
            if not(mapData[i][j] == nil) then
                if mapData[i][j].calFlag > 0 then
                    count = count + 100
                end
            end
        end
    end
    return count
end
