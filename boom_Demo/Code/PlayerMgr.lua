require("Code/InputMgr");
require("Code/AnimationSheet");
--all info and operation relate to player here

function initCursor()
    cursor = {}
    cursor.cx = 0
    cursor.cy = 0
    cursor.dx = 0
    cursor.dy = 0
    cursor.action = 0
    cursor.rotate = 0
end

function initPlayer()
	--this is infact a table in LUA
	--however we could use this just like a struct
	--and every variable in LUA is global in default.
	--unless you put local keyword
	player={};
	player.x=100;
	player.y=120;
	player.dx=0;
	player.dy=0;
	player.speed=65.0;
	player.bulletSpeed=130.0;
	player.bulletCount=5;
	
	-- Animation Sheet
	player.sheet = GetAnimationSheet(ship,32,32,1)
end

function updatePlayer(dt)
	updateInput();
	player.x=player.x+player.dx*dt;
	player.y=player.y+player.dy*dt;
	player.dx=0;
	player.dy=0;
	UpdateAnimationSheet(player.sheet,dt);
end

function _Fire()
    if player.bulletCount <= 0 then
        noBulletSFX:play()
    else
        player.bulletCount = player.bulletCount - 1
        bullet = {}
        bullet.x = player.x + 16
        bullet.y = player.y + 16
        table.insert(bulletList, bullet)
        shootSFX:play()
        return
    end
end

function updateBullet(dt)
    local dyingBullet = {}
    if #bulletList > 0 then
        for i = 1, #bulletList do
            bulletList[i].x = bulletList[i].x + player.bulletSpeed * dt
            if bulletList[i].x > 320 then
                table.insert(dyingBullet, i)
            end
        end
    end
    if #dyingBullet > 0 then
        for i = 1, #dyingBullet do
            table.remove(bulletList, dyingBullet[i])
        end
    end
end
