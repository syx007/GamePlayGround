function getNextRotate(rotate)
    -- this is ccw, need implement a cw
    if rotate == 1 then
        return 2
    elseif rotate == 2 then
        return 4
    elseif rotate == 4 then
        return 3
    elseif rotate == 3 then
        return 1
    else
        return 0
    end
end

function extractDataByPtr(data, ptr)
    return math.floor((data / math.pow(10, 4 - ptr))) % 10
end

function getRotatedSide_Single(side, data, rotate)
    -- side is a data!should re-read data.
    -- this infact calculated new ptr.
    local ptr = side
    if rotate == 1 then
        ptr = side
    elseif rotate == 2 then
        ptr = getNextRotate(side)
    elseif rotate == 4 then
        ptr = getNextRotate(getNextRotate(side))
    elseif rotate == 3 then
        ptr = getNextRotate(getNextRotate(getNextRotate(side)))
    end
    return extractDataByPtr(data, ptr)
end

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
        for j = 1, mapLineCount do
            if playDemo_2 then
                mapData[i][j] = BlankElement()
            else
                -- is same currently but allow for different
                mapData[i][j] = BlankTile()
            end
        end
    end
end

function initGoalMap()
    -- this is dynamic atom map
    mapGoalData = {}
    for i = 1, mapLineCount do
        mapGoalData[i] = {}
        for j = 1, mapLineCount do mapGoalData[i][j] = BlankElement() end
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

function setGoalMap()
    -- save elementID
    -- mapData[2][3].id = 1
    -- mapData[2][3].connectivity = 4

    -- mapData[3][3].id = 1
    -- mapData[3][3].connectivity = 13

    -- mapData[3][4].id = 2
    -- mapData[3][4].connectivity = 24

    -- mapData[4][4].id = 2
    -- mapData[4][4].connectivity = 1
    mapGoalData[3][6].id = 1
    mapGoalData[3][6].connectivity = 4

    mapGoalData[4][6].id = 1
    mapGoalData[4][6].connectivity = 1
end

function setUpStructMap()
    -- save elementID
    -- 1:add
    -- 2:minus
    -- 3:rotateL
    -- 4:rotateR
    -- 5:Blocker
    mapStructData[3][4].id = 1
    mapStructData[3][4].connectivity = 4

    mapStructData[4][4].id = 1
    mapStructData[4][4].connectivity = 1

    mapStructData[4][3].id = 5
    mapStructData[4][3].connectivity = 0
end

function setTileMap()
    -- dig hole here
    -- mapData[1][1] = nil
    -- setTileMapByScramble()
    setTileMapByCount()
end

function setTileMapByScramble()
    local source = {nil, 00000, 10110}
    local sourcePer = {15, 70, 15}
    mapData = {}
    for i = 1, mapLineCount do
        mapData[i] = {}
        for j = 1, mapLineCount do
            mapData[i][j] = BlankTile()
            local rnd = math.random(0, 100)
            local accm = sourcePer[1]
            local ptr = 1
            while rnd >= accm do
                ptr = ptr + 1
                accm = accm + sourcePer[ptr]
            end
            if ptr == 1 then
                mapData[i][j] = nil
            else
                mapData[i][j].id = source[ptr]
            end
        end
    end
end

function setTileMapByCount()
    -- local source = {nil, 00000, 10110}
    -- local sourceCount = {6, 24, 6}
    local source = {nil, 00000, 11001, 11221, 33232, 32232, 32222, 42222}
    local sourceCount = {6, 13, 2, 4, 5, 4, 1, 1}
    mapData = {}
    for i = 1, mapLineCount do
        mapData[i] = {}
        for j = 1, mapLineCount do
            mapData[i][j] = BlankTile()
            local rnd = math.random(#sourceCount)
            while sourceCount[rnd] <= 0 do
                rnd = math.random(#sourceCount)
            end
            if rnd == 1 then
                mapData[i][j] = nil
            else
                mapData[i][j].id = source[rnd]
            end
            sourceCount[rnd] = sourceCount[rnd] - 1
        end
    end
end
