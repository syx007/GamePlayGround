function dispToOffset(pX, pY)
    if pX == 0 then
        if pY == 1 then
            return 3
        else
            if pY == 0 then
                return 0
            else
                return 2
            end
        end
    else
        if pX == 1 then
            return 4
        else
            return 1
        end
    end
end

function posOffsetByConnectivity(connectivity)
    local Pos = {0, 0}

    if connectivity == 0 then
        return Pos
    elseif connectivity == 1 then
        Pos[1] = Pos[1] - 1
        return Pos
    elseif connectivity == 4 then
        Pos[1] = Pos[1] + 1
        return Pos
    elseif connectivity == 2 then
        Pos[2] = Pos[2] - 1
        return Pos
    elseif connectivity == 3 then
        Pos[2] = Pos[2] + 1
        return Pos
    end
    return Pos
end

function initMap()
    -- this is dynamic atom map
    mapData = {}
    for i = 1, mapLineCount do
        mapData[i] = {}
        for j = 1, mapLineCount do mapData[i][j] = BlankElement() end
    end
end

function initStructMap()
    -- put static struction data here
    mapStructData = {}
    for i = 1, mapLineCount do
        mapStructData[i] = {}
        for j = 1, mapLineCount do mapStructData[i][j] = BlankStruct() end
    end
end

function initDisplacement()
    displaceData = {}
    for i = 1, mapLineCount do
        displaceData[i] = {}
        for j = 1, mapLineCount do displaceData[i][j] = 0 end
    end
end

function initSwapMap()
    swapMapData = {}
    for i = 1, mapLineCount do
        swapMapData[i] = {}
        for j = 1, mapLineCount do swapMapData[i][j] = BlankElement() end
    end
end

function copyNewMapByVal()
    local newMapData = {}
    for i = 1, mapLineCount do
        newMapData[i] = {}
        for j = 1, mapLineCount do newMapData[i][j] = mapData[i][j] end
    end
    return newMapData
end

function setUpMap()
    -- save elementID
    -- mapData[2][3].id = 1
    -- mapData[2][3].connectivity = 4

    -- mapData[3][3].id = 1
    -- mapData[3][3].connectivity = 13

    -- mapData[3][4].id = 2
    -- mapData[3][4].connectivity = 24

    -- mapData[4][4].id = 2
    -- mapData[4][4].connectivity = 1
    mapData[2][3].id = 1
    mapData[2][3].connectivity = 0

    mapData[5][3].id = 1
    mapData[5][3].connectivity = 0
end

function setUpStructMap()
    -- save elementID
    -- 1:add
    -- 2:minus
    -- 3:rotateL
    -- 4:rotateR
    mapStructData[3][4].id = 1
    mapStructData[3][4].connectivity = 4

    mapStructData[4][4].id = 1
    mapStructData[4][4].connectivity = 1
end
