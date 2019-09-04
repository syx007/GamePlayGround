function initMapCalculation()
    for i = 1, mapWidthCount do
        for j = 1, mapHeightCount do
            mapData[i][j].calFlag = 0
        end
    end
end


-- local coreID=extractDataByPtr(mapData[i][j].id,0);
-- local westID=getRotatedSide_Single(1,mapData[i][j].id,mapData[i][j].rotation);
-- local northID=getRotatedSide_Single(2,mapData[i][j].id,mapData[i][j].rotation);
-- local southID=getRotatedSide_Single(3,mapData[i][j].id,mapData[i][j].rotation);
-- local eastID=getRotatedSide_Single(4,mapData[i][j].id,mapData[i][j].rotation);

function getProcessor()
    local count = 0
    for i = 1, mapWidthCount do
        for j = 1, mapHeightCount do
            local coreID=extractDataByPtr(mapData[i][j].id,0);
            if coreID == 1 then
                count = count + 1
            end

        end
    end

    return count
end