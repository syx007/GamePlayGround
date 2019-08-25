-- we upadate all input data here
function updateInput_DemoII(key)
    if love.keyboard.isDown('up') then
        cursor.dy = -1
    elseif love.keyboard.isDown('down') then
        cursor.dy = 1
    elseif love.keyboard.isDown('left') then
        cursor.dx = -1
    elseif love.keyboard.isDown('right') then
        cursor.dx = 1
    end
end

function updateInput()
    if love.keyboard.isDown('up') then player.dy = -player.speed end
    if love.keyboard.isDown('down') then player.dy = player.speed end
    if love.keyboard.isDown('left') then player.dx = -player.speed end
    if love.keyboard.isDown('right') then player.dx = player.speed end
end
