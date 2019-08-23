--这个里面的函数主要是渲染，贴图的绘制都个在这。

function initArtAsset()
	--这个主要是几张图的sampler要强制设一下
	--最好强制设成这种没有插值的。
	--但是比较坑，这个必须在draw里面设，考虑资源管理里面搞个API
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