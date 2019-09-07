-- we upadate all input data here
function updateInputMainMenu(key)
    if love.keyboard.isDown('up') then
        mmCursor.dx = -1
    elseif love.keyboard.isDown('down') then
        mmCursor.dx = 1
    end
    if love.keyboard.isDown('j') then
        mmCursor.action = 1
    end
end

function updateInputRegisterScore(key)
    -- TODO
end

function updateInputViewScore(key)
    -- TODO
end

--[[function move_selector(key)
    if key =="up" then
        select_y=select_y-1
    end
    if key =="down"then
        select_y=select_y+1
    end
    if key =="left" then
        select_x=select_x-1
    end
    if key =="right"then
        select_x=select_x+1
    end
end]]
--[[function MoveCamera(isSelectMode)
    if isSelectMode==false then
        if love.keyboard.isDown("up") then
            camera_bias_y=camera_bias_y-2
        end
        if love.keyboard.isDown("down") then
            camera_bias_y=camera_bias_y+2
        end
        if love.keyboard.isDown("left") then
            camera_bias_x=camera_bias_x-2
        end
        if love.keyboard.isDown("right") then
            camera_bias_x=camera_bias_x+2
        end
    end
end]]
--[[function ZoomCamera(dt)
    if ZoomFactor<=3 then
        if love.keyboard.isDown("q") then
            ZoomFactor=ZoomFactor*(1+0.4*dt)
        end
    end

    if ZoomFactor>=0.33 then
        if love.keyboard.isDown("w")then
            ZoomFactor=ZoomFactor*(1-0.4*dt)
        end
    end
    
end]]
function updateInputPlayingGame(key)
    if key =="i" then
        SelectedMode=not SelectedMode;
    end
    if key =="o" then
        Help=not Help
    end
    if SelectedMode==true then
        if (love.keyboard.isDown('j')) then
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
        if (love.keyboard.isDown('k')) then
            print("rotate input")
            cursor.rotate = 1
        end
    end
end
