-- we upadate all input data here
function updateInputMainMenu(key)
    if love.keyboard.isDown('up') then
        mmCursor.dx = -1
    elseif love.keyboard.isDown('down') then
        mmCursor.dx = 1
    end
    if (love.keyboard.isDown('z') or love.keyboard.isDown('j')) then
        mmCursor.action = 1
    end
end

function updateInputRegisterScore(key)
    -- TODO
end

function updateInputViewScore(key)
    -- TODO
end

function updateInputPlayingGame(key)
    if (love.keyboard.isDown('z') or love.keyboard.isDown('j')) then
        if love.keyboard.isDown('up') then
            cursor.action = 2
        elseif love.keyboard.isDown('down') then
            cursor.action = 3
        elseif love.keyboard.isDown('left') then
            cursor.action = 1
        elseif love.keyboard.isDown('right') then
            cursor.action = 4
        else
            cursor.action = 0
        end
    else
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
    if (love.keyboard.isDown('x') or love.keyboard.isDown('k')) then
        print("rotate input")
        cursor.rotate = 1
    end
end
