require("Code/ElementLib")
require("Code/Utils")
require("Code/MapUtils")

-- connectivity:
-- [  2  ]
-- [1 0 4]
-- [  3  ]

-- s=1 r=1:

function isTargetInMap(tragetPosX, tragetPosY)
    return (tragetPosX > 0 and tragetPosX < mapLineCount + 1) and
               (tragetPosY > 0 and tragetPosY < mapLineCount + 1)
end

function tileIsBlocked(tragetPosX, tragetPosY)
    return not (mapData[tragetPosX][tragetPosY] == nil)
end

function isTargetMovable_Cursor_withTile(tragetPosX, tragetPosY)
    if isTargetInMap(tragetPosX, tragetPosY) then
        return not tileIsBlocked(tragetPosX, tragetPosY)
    else
        return false
    end
end

function isTargetMovable_Cursor(tragetPosX, tragetPosY)
return isTargetInMap(tragetPosX, tragetPosY)
end

function isTargetMovable(tragetPosX, tragetPosY)
    if not isTargetInMap(tragetPosX, tragetPosY) then
        return false
    else
        return (mapData[tragetPosX][tragetPosY].id <= 0) and
                   (not (mapStructData[tragetPosX][tragetPosY].id == 5))
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
    local res = oldBond * 10 + newBond
    return res
end

function checkWinning()
    if frametiker == 0 then
        for i = 1, mapLineCount do
            for j = 1, mapLineCount do
                if mapGoalData[i][j].id > 0 then
                    if (not (mapData[i][j].id == mapGoalData[i][j].id)) or
                        (not (mapData[i][j].connectivity ==
                            mapGoalData[i][j].connectivity)) then
                        win = false
                        return
                    end
                end
            end
        end
        win = true
        return
    end
    win = false
    return
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

function updateLakeScore()

    
    -- as prototype the score counting should not implement by programming.
    -- could implmement by hand.
    -- local LakeScore=0;
    -- for i = 1, mapLineCount do
    --     for j = 1, mapLineCount do
    --         local cId=mapStructData[i][j].id;
    --         if extractDataByPtr(cId,0) then
                
    --         end
    --     end
    -- end
    -- return LakeScore;
end

function updateTileMap_Cursor()
    local covtCX = cursor.cx + 1
    local covtCY = cursor.cy + 1
    if not (cursor.action == 0) then
        -- print("moving tile")
        if not (mapData[covtCX][covtCY] == nil) then
            -- print("moving tile 2")
            local offset = posOffsetByConnectivity(cursor.action)
            if isTargetMovable_Cursor_withTile(covtCX + offset[1],
                                               covtCY + offset[2]) then
                mapData[covtCX + offset[1]][covtCY + offset[2]] =
                    mapData[covtCX][covtCY]
                mapData[covtCX][covtCY] = nil
                cursor.dx = offset[1]
                cursor.dy = offset[2]
            end
        end
    end
    if (cursor.rotate == 1) then
        if not (mapData[covtCX][covtCY] == nil) then
            -- print("rotate tile")
            mapData[covtCX][covtCY].rotation =
                getNextRotate(mapData[covtCX][covtCY].rotation)
            -- print(mapData[covtCX][covtCY].rotation)
        end
    end
    cursor.rotate = 0
    cursor.action = 0
end

function updateScore()
    initMapCalculation()

    -- calculate green
    processor = getGreenCore()
    if not( processor == nil ) then
        calculateGreen(processor.indexX,processor.indexY,1)
    end
    greenScore = sumGreen()

    -- calculate blue
    calculateBlue()
    blueScore = sumBlue()

    -- calculate edge
    edgeScore = sumEdge()
end