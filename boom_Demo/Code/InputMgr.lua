--输入的相关操作都在这儿做。

function updateInput()
	if love.keyboard.isDown('up') then
		player.dy=-player.speed;
	end
	if love.keyboard.isDown('down') then
		player.dy=player.speed;
	end
	if love.keyboard.isDown('left') then
		player.dx=-player.speed;
	end
	if love.keyboard.isDown('right') then
		player.dx=player.speed;
	end
end