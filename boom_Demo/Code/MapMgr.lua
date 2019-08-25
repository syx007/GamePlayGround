require("Code/ElementLib")

function initMap()
    mapData = {}
    for i = 1, mapLineCount do
        mapData[i] = {}
        for j = 1, mapLineCount do mapData[i][j] = 0 end
    end
end

function updateMap_Cursor_pushOnly()
    ePosX = cursor.cx + 1
    ePosY = cursor.cy + 1
    for i = 1, mapLineCount do
        for j = 1, mapLineCount do
            if mapData[i][j] > 0 then
                if ePosX == i and ePosY == j + 1 and cursor.dy == -1 then
                    if j - 1 > 0 then
                        mapData[i][j - 1] = mapData[i][j];
                        mapData[i][j] = 0;
                    else
                        cursor.dy = 0;
                    end
                end
                if ePosX == i and ePosY == j - 1 and cursor.dy == 1 then
                    if j + 1 < mapLineCount + 1 then
                        mapData[i][j + 1] = mapData[i][j];
                        mapData[i][j] = 0;
                    else
                        cursor.dy = 0;
                    end
                end
                if ePosX == i+1 and ePosY == j and cursor.dx == -1 then
                    if i-1 > 0 then
                        mapData[i-1][j] = mapData[i][j];
                        mapData[i][j] = 0;
                    else
                        cursor.dx = 0;
                    end
                end
                if ePosX == i-1 and ePosY == j and cursor.dx == 1 then
                    if i+1 < mapLineCount + 1 then
                        mapData[i+1][j] = mapData[i][j];
                        mapData[i][j] = 0;
                    else
                        cursor.dx = 0;
                    end
                end
            end
        end
    end
end

function setUpMap() mapData[2][3] = 1 end
