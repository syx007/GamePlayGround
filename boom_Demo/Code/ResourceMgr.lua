--现在这个东西就是简单的加载一下内容，这里需要添加的东西还是蛮多的
--路径管理，自动加载卸载；甚至打包的strip其实都需要考虑的。

function loadResource()
	fighter0=love.graphics.newImage("Art/Sprite/Fighter0_0.png");
	bullet0=love.graphics.newImage("Art/Sprite/Bullet0_0.png");
	emptybullet0=love.graphics.newImage("Art/Sprite/Bullet0_1.png");
	shootSFX = love.audio.newSource("Music/SFX/Hit_00.wav", "static");
	noBulletSFX = love.audio.newSource("Music/SFX/Open_01.wav", "static");
end