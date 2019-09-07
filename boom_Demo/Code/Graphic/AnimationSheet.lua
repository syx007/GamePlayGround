function GetAnimationSheet(img,width,height,duration)
	local sheet = {}

	sheet.currentFrame = 1;
	sheet.img = img;
	sheet.quads = {};

	for y = 0, img:getHeight() - height, height do
		for x = 0, img:getWidth() - width, width do
			table.insert(sheet.quads, love.graphics.newQuad(x,y,width,height, img:getDimensions()))
		end
	end

	sheet.duration = duration or 1
	sheet.currentTime = 0

	return sheet;

end

function UpdateAnimationSheet(sheet,dt)
	sheet.currentTime = sheet.currentTime + dt
	if sheet.currentTime >= sheet.duration then
		sheet.currentTime = sheet.currentTime - sheet.duration
	end
end

function DrawAnimationSheet(sheet,x,y,r,sx,sy)
	local id = math.floor(sheet.currentTime / sheet.duration * #sheet.quads ) + 1
	love.graphics.draw(sheet.img, sheet.quads[id],x,y,r,sx,sy )
end