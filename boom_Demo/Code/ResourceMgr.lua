--currently, it only finish a very simple job--just load some image and wav
--in future, we could do path management, auto loading, or even strip during packaging

function loadResource()
	fighter0=love.graphics.newImage("Art/Sprite/Fighter0_0.png");
	bullet0=love.graphics.newImage("Art/Sprite/Bullet0_0.png");
	emptybullet0=love.graphics.newImage("Art/Sprite/Bullet0_1.png");
	shootSFX = love.audio.newSource("Music/SFX/Hit_00.wav", "static");
	noBulletSFX = love.audio.newSource("Music/SFX/Open_01.wav", "static");
	ship = love.graphics.newImage("Art/Sprite/ship.png");
end