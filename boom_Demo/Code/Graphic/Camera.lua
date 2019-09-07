function MoveCamera(isSelectMode,dt)
    if isSelectMode==false then
        if love.keyboard.isDown("up") then
            camera_bias_y=camera_bias_y-2*ZoomFactor
        end
        if love.keyboard.isDown("down") then
            camera_bias_y=camera_bias_y+2*ZoomFactor
        end
        if love.keyboard.isDown("left") then
            camera_bias_x=camera_bias_x-2*ZoomFactor
        end
        if love.keyboard.isDown("right") then
            camera_bias_x=camera_bias_x+2*ZoomFactor
        end
    else
        cursor_grid_coord= MapIdx2GridCoord(cursor.cx,cursor.cy)
        local target_x=cursor_grid_coord.x*cellSize+0.5*cellSize
        local target_y=cursor_grid_coord.y*cellSize+0.5*cellSize
        if math.abs(camera_bias_x-target_x)>2*ZoomFactor then
            if camera_bias_x<target_x then
                camera_bias_x=camera_bias_x+2*ZoomFactor
            elseif camera_bias_x>target_x then
                camera_bias_x=camera_bias_x-2*ZoomFactor
            end
        else
            camera_bias_x=target_x
        end
        if math.abs(camera_bias_y-target_y)>2*ZoomFactor then
            if camera_bias_y<target_y then
                camera_bias_y=camera_bias_y+2*ZoomFactor
            elseif camera_bias_y>target_y then
                camera_bias_y=camera_bias_y-2*ZoomFactor
            end
        else
            camera_bias_y=target_y
        end
        --local cursor_coord=getWorldCoordfromGrid(cursor.cx,cursor.cy,camera_bias_x,camera_bias_y)
        --camera_bias_x=cursor_coord.x
        --camera_bias_y=cursor_coord.y
    end
end
function ZoomCamera(isSelectMode,dt)
if isSelectMode==false then
    if ZoomFactor<=2 then
        if love.keyboard.isDown("j") then
            ZoomFactor=ZoomFactor*(1+0.4*dt)
        end
    end

    if ZoomFactor>=0.5 then
        if love.keyboard.isDown("k")then
            ZoomFactor=ZoomFactor*(1-0.4*dt)
        end
    end
else
    if ZoomFactor<=2 then
        if love.keyboard.isDown("h") then
            ZoomFactor=ZoomFactor*(1+0.4*dt)
        end
    end

    if ZoomFactor>=0.5 then
        if love.keyboard.isDown("l")then
            ZoomFactor=ZoomFactor*(1-0.4*dt)
        end
    end
end
    
end