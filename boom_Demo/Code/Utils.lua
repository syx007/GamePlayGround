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

function getNextRotate_Reverse(rotate)
    -- this is ccw, need implement a cw
    if rotate == 1 then
        return 3
    elseif rotate == 3 then
        return 4
    elseif rotate == 4 then
        return 2
    elseif rotate == 2 then
        return 1
    else
        return 0
    end
end

function rotatePtr(side, rotate)
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
    return ptr
end

function arrayFind(array, element)
    for ele, content in ipairs(array) do
        -- BODY
        if content == element then
            -- BODY
            return ele
        end
    end
    return -1
end

function arrayContain(array, element)
    for ele, content in ipairs(array) do
        if content == element then return true end
    end
    return false
end

function mathClamp(x, min, max) return math.min(math.max(x, min), max) end

function GetSideOnOff(data, ptr)
    if data ~= nil then
        return math.floor((data / math.pow(10, 4 - ptr))) % 10
    else
        return 0
    end
end

function SetSideOnOff(data, ptr, onoff)
    local orgOnOff = GetSideOnOff(data, ptr)
    if onoff ~= orgOnOff then
        if orgOnOff == 3 then
            if orgOnOff ~= 0 then
                return
            else
                data = data - math.pow(10, 4 - ptr) * orgOnOff
            end
        else
            -- data = data - math.pow(10, 4 - ptr) * orgOnOff
            data = data + math.pow(10, 4 - ptr) * onoff
        end
    end
    return data
end

function getRotatedSideOnOff_Single(side, data, rotate)
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
    return GetSideOnOff(data, ptr)
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
            -- is same currently but allow for different    
            mapData[i][j] = BlankTile()
        end
    end
end

function setTileMap()
    -- dig hole here
    -- mapData[1][1] = nil
    -- setTileMapByScramble()
    -- setTileMapByCount()
    setRealGamePlayMap()
end

function setTileMapByScramble()
    local source = {nil, 00001, 41101, 51011, 11111, 31111, 11111, 20011}
    local sourcePer = {30, 10, 10, 10, 10, 10, 10, 10}
    mapData = {}
    for i = 1, mapLineCount do
        mapData[i] = {}
        for j = 1, mapLineCount do
            mapData[i][j] = BlankTile()
            local rnd = love.math.random(0, 100)
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
    -- local source = {nil, 00000, 11001, 11221, 33131, 31131, 42222, 52222}
    -- local sourceCount = {16, 3, 2, 4, 5, 4, 1, 1}
    local source = {nil, 00001, 41101, 51011, 11111, 31111, 11111, 20011}
    local sourceCount = {4, 5, 7, 1, 7, 1, 7, 4}
    -- local source = {nil, 41101, 51011}
    -- local sourceCount = {34, 1, 1}
    mapData = {}
    for i = 1, mapLineCount do
        mapData[i] = {}
        for j = 1, mapLineCount do
            mapData[i][j] = BlankTile()
            local rnd = love.math.random(#sourceCount)
            while sourceCount[rnd] <= 0 do
                rnd = love.math.random(#sourceCount)
            end
            if rnd == 1 then
                mapData[i][j] = nil
            else
                mapData[i][j].id = source[rnd]
                mapData[i][j].rotation = math.floor(love.math.random(4))+1
            end
            sourceCount[rnd] = sourceCount[rnd] - 1
        end
    end
    -- autoQA=false
end

function setRealGamePlayMap()
    mapData = {}
    for i = 1, mapLineCount do
        mapData[i] = {}
        for j = 1, mapLineCount do
            mapData[i][j] = BlankTile()
            mapData[i][j].id = 00000
        end
    end
    mapData[3][3] = nil
    mapData[4][3] = nil
    mapData[3][4] = nil
    mapData[4][4] = nil

    mapData[2][3] = nil
    mapData[2][4] = nil
    mapData[5][3] = nil
    mapData[5][4] = nil

    mapData[3][2] = nil
    mapData[4][2] = nil
    mapData[3][5] = nil
    mapData[4][5] = nil

    mapData[1][1].id = 51111
    mapData[6][6].id = 21111
    -- mapData[1][6].id = 52222
    -- mapData[6][1].id = 21111
end
