require("Code/InputMgr");

--角色相关的东西都在这了。

function initPlayer()
	--这个其实就是一个lua的table，但是其实考虑成struct就行
	--然后lua里面没有写local的变量都是全局的。
	--所以不用return。
	player={};
	player.x=100;
	player.y=120;
	player.dx=0;
	player.dy=0;
	player.speed=65.0;
	player.bulletSpeed=130.0;
	player.bulletCount=5;
end

function updatePlayer(dt)
	updateInput();
	player.x=player.x+player.dx*dt;
	player.y=player.y+player.dy*dt;
	player.dx=0;
	player.dy=0;
end

function _Fire()
	if player.bulletCount<=0 then
		noBulletSFX:play();
	else
		player.bulletCount=player.bulletCount-1;
		bullet={};
		bullet.x=player.x+16;
		bullet.y=player.y+16;
		table.insert(bulletList,bullet);
		shootSFX:play();
		return;
	end
end

function updateBullet(dt)
	local dyingBullet={};
	if #bulletList>0 then
		for i=1,#bulletList do
			bulletList[i].x=bulletList[i].x+player.bulletSpeed*dt;
			if bulletList[i].x>320 then
				table.insert(dyingBullet,i);
			end
		end
	end
	if #dyingBullet>0 then
		for i=1,#dyingBullet do
			table.remove(bulletList,dyingBullet[i]);
		end
	end
end