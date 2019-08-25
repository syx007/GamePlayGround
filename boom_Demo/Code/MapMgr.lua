require("Code/ElementLib")

function initMap()
    mapData = {}
    for i = 1, mapLineCount do
        mapData[i] = {}
        for j = 1, mapLineCount do mapData[i][j] = 0 end
    end
end

function isTargetInMap(tragetPos)
    return (tragetPos[1] > 0 and tragetPos[1] < mapLineCount + 1) and
               (tragetPos[2] > 0 and tragetPos[2] < mapLineCount + 1)
end

function isTargetMovable(tragetPos)
    return (mapData[tragetPos[1]][tragetPos[2]] <= 0) and
               isTargetInMap(tragetPos)
end

function pushElement(cCX, cCY, i, j, cascadePush)
    isPushingX = (cCX == i + 1 and cCY == j and cursor.dx == -1) or
                     (cCX == i - 1 and cCY == j and cursor.dx == 1)
    isPushingY = (cCX == i and cCY == j + 1 and cursor.dy == -1) or
                     (cCX == i and cCY == j - 1 and cursor.dy == 1)
    if (not isPushingY) and (not isPushingX) then return end
    local tragetPos = {i + cursor.dx, j + cursor.dy}
    if isTargetMovable(tragetPos) then
        mapData[tragetPos[1]][tragetPos[2]] = mapData[i][j]
        mapData[i][j] = 0
    else
        if isPushingY then cursor.dy = 0 end
        if isPushingX then cursor.dx = 0 end
        return
    end
end

function pullElement(cCX, cCY, i, j)
    -- TODO
end

function updateMap_Cursor_pushOnly()
    local covtCX = cursor.cx + 1
    local covtCY = cursor.cy + 1
    for i = 1, mapLineCount do
        for j = 1, mapLineCount do
            if mapData[i][j] > 0 then
                pushElement(covtCX, covtCY, i, j)
            end
        end
    end
end

function setUpMap()
    mapData[2][3] = 1
    mapData[4][5] = 1
end
