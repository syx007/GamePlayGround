require("Code/ElementLib")
require("Code/Utils")

-- connectivity:
-- [  2  ]
-- [1 0 4]
-- [  3  ]

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
    displaceData[i][j] = dispToOffset(tragetPosX - i, tragetPosY - j)
    -- print(tragetPosX - i, tragetPosY - j)
    -- print(displaceData[i][j])
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
        -- print("====")
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
            local offset = posOffsetByConnectivity(displaceData[i][j])
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

function addBound(oldBond, newBond)

    for idx = 0, 3 do
        local cBond = math.floor(oldBond / math.pow(10, idx) % 10)
        if cBond == newBond then return oldBond end
    end
    local res=oldBond * 10 + newBond;
    return res;
end

function updateElementBond()
    -- currently the bond is still exclusive.
    if frametiker == 0 then
        for i = 1, mapLineCount do
            for j = 1, mapLineCount do
                if mapData[i][j].id > 0 then
                    if mapStructData[i][j].id > 0 then
                        offset = posOffsetByConnectivity(
                                     mapStructData[i][j].connectivity)
                        if mapData[i + offset[1]][j + offset[2]].id > 0 then
                            mapData[i][j].connectivity =
                                addBound(mapData[i][j].connectivity,
                                         mapStructData[i][j].connectivity)
                            mapData[i + offset[1]][j + offset[2]].connectivity =
                                addBound(
                                    mapData[i + offset[1]][j + offset[2]]
                                        .connectivity, mapStructData[i +
                                        offset[1]][j + offset[2]].connectivity)
                        end
                    end
                end
            end
        end
    end
end
