require("Code/ResourceMgr");
require("Code/PlayerMgr");
require("Code/InputMgr");
require("Code/GraphicMgr");
--这些就是include，跟shader里的概念比较像
--基本上就是把文件愣怼在一起。而且不用考虑循环include
--这个是基于根文件夹的绝对路径，代码上不写后缀名

function love.load()
	counter=0;
	love.window.setMode( 320, 240, {resizable=false} );
	loadResource();
	bulletList={};
	initPlayer();
end

function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		love.event.quit();
	end
	--[[ABXY=JKUI DEOT右侧按钮和键盘的对应]]--
	if key == "j" or key == "z" then
		_Fire();
	end
end

function love.update(dt)
	updatePlayer(dt);
	updateBullet(dt);
end

function love.draw()
	initArtAsset();
	mainGraphicUpdate();
	uiUpdate();
end