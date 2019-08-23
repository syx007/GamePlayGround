require("Code/ResourceMgr");
require("Code/PlayerMgr");
require("Code/InputMgr");
require("Code/GraphicMgr");
--tmd on DEOT we can't use Chinese comment
--DON'T write Chinese comment.

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
	--[[ABXY=JKUI DEOT]]--
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