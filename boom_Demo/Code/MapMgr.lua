require("Code/ElementLib")

-- connectivity:
-- [  2  ]
-- [1 0 4]
-- [  3  ]

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

-- function shiftPosByConnectivity(Pos, connectivity)
--     if connectivity == 0 then
--         return Pos
--     elseif connectivity == 1 then
--         Pos[1] = Pos[1] - 1
--         return Pos
--     elseif connectivity == 4 then
--         Pos[1] = Pos[1] + 1
--         return Pos
--     elseif connectivity == 2 then
--         Pos[2] = Pos[2] - 1
--         return Pos
--     elseif connectivity == 3 then
--         Pos[2] = Pos[2] - 1
--         return Pos
--     end
-- end

function BlankElement()
    local e = {}
    e.id = 0
    e.connectivity = 0
    return e
end

function initMap()
    mapData = {}
    for i = 1, mapLineCount do
        mapData[i] = {}
        for j = 1, mapLineCount do mapData[i][j] = BlankElement() end
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

function isTargetInMap(tragetPosX, tragetPosY)
    return (tragetPosX > 0 and tragetPosX < mapLineCount + 1) and
               (tragetPosY > 0 and tragetPosY < mapLineCount + 1)
end

function isTargetMovable(tragetPosX, tragetPosY)
    if not isTargetInMap(tragetPosX, tragetPosY) then
        return false
    else
        return (mapData[tragetPosX][tragetPosY].id <= 0)
    end
end

function connectivityMoveCheck(tragetPosX, tragetPosY, i, j, fromDir)
    -- print("connectivityMoveCheck");
    local total = mapData[i][j].connectivity
    if total == 0 then
        -- have really nothing else connected.
        return isTargetMovable(tragetPosX, tragetPosY)
    else
        local localMovable = false
        local remoteMovable = true
        for idx = 0, 3 do
            local cctvty = math.floor(total / math.pow(10, idx) % 10)
            local offset = posOffsetByConnectivity(cctvty)
            local localMovableTmp = isTargetMovable(tragetPosX, tragetPosY)

            if not localMovableTmp then
                if (offset[1] == tragetPosX - i) and
                    (offset[2] == tragetPosY - j) then
                    -- print("fliped")
                    localMovableTmp = true
                end
            end
            localMovable = localMovable or localMovableTmp
            if not (cctvty + fromDir == 5) and (not (cctvty == 0)) then
                local localMovableTmp = connectivityMoveCheck(
                                            tragetPosX + offset[1],
                                            tragetPosY + offset[2],
                                            i + offset[1], j + offset[2], cctvty)
                remoteMovable = remoteMovable and localMovableTmp
            end
        end
        -- print((i .. j))
        -- print(("localMovable"))
        -- print((localMovable))
        -- print(("remoteMovable"))
        -- print((remoteMovable))
        -- print((remoteMovable and localMovable))
        return (remoteMovable and localMovable)
    end
end

function moveSingleElement(newMapData, mapData, i, j, tragetPosX, tragetPosY)
    -- newMapData[tragetPosX][tragetPosY] = mapData[i][j]
    -- newMapData[i][j] = BlankElement()
    displaceData[i][j] = dispToOffset(tragetPosX - i, tragetPosY - j)
    print(tragetPosX - i, tragetPosY - j)
    print(displaceData[i][j])
end

function moveElement(newMapData, mapData, i, j, tragetPosX, tragetPosY, fromDir)
    -- print("moveElement")
    local total = mapData[i][j].connectivity
    if total == 0 then
        -- have really nothing else connected.
        -- print("moveElementOnly")
        moveSingleElement(newMapData, mapData, i, j, tragetPosX, tragetPosY)
    else
        -- print("moveElementConnected")
        for idx = 0, 3 do
            local cctvty = math.floor(total / math.pow(10, idx) % 10)
            if not (cctvty + fromDir == 5) and (not (cctvty == 0)) then
                -- print(cctvty)
                local offset = posOffsetByConnectivity(cctvty)
                moveElement(newMapData, mapData, i + offset[1], j + offset[2],
                            tragetPosX + offset[1], tragetPosY + offset[2],
                            cctvty)
            end
        end
        moveSingleElement(newMapData, mapData, i, j, tragetPosX, tragetPosY)
    end
end

function pushElement(cCX, cCY, i, j, cascadePush, newMapData)
    isPushingX = (cCX == i + 1 and cCY == j and cursor.dx == -1) or
                     (cCX == i - 1 and cCY == j and cursor.dx == 1)
    isPushingY = (cCX == i and cCY == j + 1 and cursor.dy == -1) or
                     (cCX == i and cCY == j - 1 and cursor.dy == 1)
    if (not isPushingY) and (not isPushingX) then return end
    local tragetPos = {i + cursor.dx, j + cursor.dy}
    if connectivityMoveCheck(tragetPos[1], tragetPos[2], i, j, 0) then
        moveElement(newMapData, mapData, i, j, tragetPos[1], tragetPos[2], 0)
        print("====")
    else
        if isPushingY then cursor.dy = 0 end
        if isPushingX then cursor.dx = 0 end
        return
    end
end

function pullElement(cCX, cCY, i, j)
    -- TODO
end

function swapMap_wDisp()
    initSwapMap()
    for i = 1, mapLineCount do
        for j = 1, mapLineCount do
            if not (displaceData[i][j] == 0) then
                print(displaceData[i][j])
            end
            local offset = posOffsetByConnectivity(displaceData[i][j])
            if not (displaceData[i][j] == 0) then
                print(offset[1] .. offset[2])
            end
            if not (mapData[i][j].id == 0) then
                swapMapData[i + offset[1]][j + offset[2]] = mapData[i][j]
            end
        end
    end
    mapData = swapMapData
end

function swapMap()
    initSwapMap()
    for i = 1, mapLineCount do
        for j = 1, mapLineCount do swapMapData[i][j] = mapData[i][j] end
    end
    mapData = swapMapData
end

function updateMap_Cursor_pushOnly()
    initDisplacement()
    local covtCX = cursor.cx + 1
    local covtCY = cursor.cy + 1
    for i = 1, mapLineCount do
        for j = 1, mapLineCount do
            if mapData[i][j].id > 0 then
                pushElement(covtCX, covtCY, i, j, false, newMapData)
            end
        end
    end
    swapMap_wDisp()
end

function setUpMap()
    -- save elementID
    mapData[2][3].id = 1
    mapData[2][3].connectivity = 4

    mapData[3][3].id = 1
    mapData[3][3].connectivity = 13

    mapData[3][4].id = 2
    mapData[3][4].connectivity = 24

    mapData[4][4].id = 2
    mapData[4][4].connectivity = 1
end
