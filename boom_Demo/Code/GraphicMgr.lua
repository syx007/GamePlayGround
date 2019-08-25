-- put all rendering and graphicing API here
function initArtAsset()
    -- we force the sampler here.
    -- don't like any interpolation, just use point filter is good.
    -- however, setting sampler have to do every draw.
    fighter0:setFilter("nearest", "nearest")
    bullet0:setFilter("nearest", "nearest")
    emptybullet0:setFilter("nearest", "nearest")
end

function drawCursor()
    local gsize = mapSize / mapLineCount;
    local csize = mapSize / mapLineCount - 10;
    local cPosX = mapULoffsetX + cursor.cx * gsize + 5;
	local cPosY = mapULoffsetY + cursor.cy * gsize + 5;
	love.graphics.setColor(1.0,1.0,1.0);
    love.graphics.rectangle("line", cPosX, cPosY, csize, csize, 3, 3, 5)
end
function drawGrid(count, pX, pY, sX, sY)
    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
    love.graphics.line(pX, pY, pX + sX, pY)
    love.graphics.line(pX, pY, pX, pY + sY)
    for i = 1, count do
        love.graphics.setLineWidth(2)
        love.graphics.line(pX, pY + i * (sY / count), pX + sX,
                           pY + i * (sY / count))
    end
    for i = 1, count do
        love.graphics.setLineWidth(2)
        love.graphics.line(pX + i * (sX / count), pY, pX + i * (sX / count),
                           pY + sY)
    end
end

function updateMap()
	for i=1,mapLineCount do
		for j=1,mapLineCount do
			ElementData=mapData[i][j];
			if ElementData>0 then
				local gsize = mapSize / mapLineCount
				local csize = mapSize / mapLineCount - 10
				local cPosX = mapULoffsetX + i * gsize;
				local cPosY = mapULoffsetY + j * gsize;
				love.graphics.setColor(0,0,1.0);
				love.graphics.circle("fill", cPosX-gsize/2.0, cPosY-gsize/2.0, csize/2.0)
			end
		end
	end
end

function mainGraphicUpdate()
    drawGrid(mapLineCount, mapULoffsetX, mapULoffsetY, mapSize, mapSize);
	updateMap();
	drawCursor();
end

function uiUpdate()
    for i = 0, 4 do
        if i < player.bulletCount then
            love.graphics.draw(bullet0, 10 + i * 24, 220)
        else
            love.graphics.draw(emptybullet0, 10 + i * 24, 220)
        end
    end
end
