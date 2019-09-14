require("Code/DesignerConfigs/ElementConf")
require("Code/Utils")
require("Code/Map/MapUtils")

-- connectivity:
-- [  2  ]
-- [1 0 4]
-- [  3  ]

-- s=1 r=1:
function isTargetInMap(targetPosX, targetPosY)
    -- print(targetPosX,targetPosY,-MaxGridWidth/2,MaxGridWidth/2 - 1)
    return (targetPosX > 0 and targetPosX < mapLineCount + 1) and
               (targetPosY > 0 and targetPosY < mapLineCount + 1)
end

function tileIsBlocked(targetPosX, targetPosY)
    return not (mapData[targetPosX][targetPosY] == nil)
end

function isTargetMovable_Cursor_withTile(targetPosX, targetPosY)
    if isTargetInMap(targetPosX, targetPosY) then
        return not tileIsBlocked(targetPosX, targetPosY)
    else
        return false
    end
end

function isTargetMovable_Cursor(targetPosX, targetPosY)
    return isTargetInMap(targetPosX, targetPosY)
end

function isTargetMovable(targetPosX, targetPosY)
    if not isTargetInMap(targetPosX, targetPosY) then
        return false
    else
        return (mapData[targetPosX][targetPosY].id <= 0) and
                   (not (mapStructData[targetPosX][targetPosY].id == 5))
    end
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
            else
                love.audio.play(SFX.move_denied)
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
    processor = getProcessor()
    if not (processor == nil) then
        -- start the BFS from the procesor,
        -- there is only one processor now, so mark it as 1
        local processorID = 1 -- this is not ID as kind is #of instanced tile
        BFS_Driver(processor.indexX, processor.indexY, processorID)
    end
    driverIncome = evaluateDriver()

    -- calculate edge
    edgeIncome = evaluateEdge()

    -- calculate blue
    preDFSNetwork()
    blueIncome = evaluateNetwork()

    totalCost = evaluateCost()
end
