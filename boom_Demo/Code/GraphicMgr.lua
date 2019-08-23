--put all rendering and graphicing API here

function initArtAsset()
	--we force the sampler here.
	--don't like any interpolation, just use point filter is good.
	--however, setting sampler have to do every draw.
	fighter0:setFilter("nearest", "nearest");
	bullet0:setFilter("nearest", "nearest");
	emptybullet0:setFilter("nearest", "nearest");
end

function mainGraphicUpdate()
	if #bulletList>0 then
		for i=1,#bulletList do
			love.graphics.draw(bullet0,bulletList[i].x,bulletList[i].y);
		end
	end
	love.graphics.draw(fighter0,player.x,player.y);
end

function uiUpdate()
	for i=0,4 do
		if i<player.bulletCount then 
			love.graphics.draw(bullet0,10+i*24,220);
		else
			love.graphics.draw(emptybullet0,10+i*24,220);
		end
	end
end