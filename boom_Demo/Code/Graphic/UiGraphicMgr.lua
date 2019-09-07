
function printButtonTips()
    if Help==true then
    if SelectedMode==false then
        love.graphics.setColor(1, 1, 1,0.6)
        TipText="Enter Select Mode:Y\nZoom In:A\nZoom Out:B\nMove Camera:Up/Down/Left/Right"
        love.graphics.print(TipText,10,10)
    else
        love.graphics.setColor(1, 1, 1,0.6)
        TipText="Enter Viewer Mode:Y\nMove Cursor:Up/Down/Left/Right\nMove Block:A+Up/Down/Left/Right\nRotate Block:B\nZoom In:Shift+A\nZoom Out:Shift+B"
        love.graphics.print(TipText,10,10)
    end
    else
        love.graphics.setColor(1, 1, 1,0.3)
        TipText="Help:Shift+Y"
        love.graphics.print(TipText,240,5)
    end
    if SelectedMode==false then
        love.graphics.setColor(1, 1, 1,0.6)
        StatusText="Viewer Mode"
        love.graphics.print(StatusText,10,225)
    else
        love.graphics.setColor(1, 1, 1,0.6)
        StatusText="Select Mode"
        love.graphics.print(StatusText,10,225)
    end
end
function printScore()
    love.graphics.setColor(0.5, 1.0, 0.5)
    local font = love.graphics.newFont(14)
    love.graphics.print("CPU scr:" .. driverScore, 240, 50)
    love.graphics.setColor(0.5, 1, 1)
    local font = love.graphics.newFont(14)
    love.graphics.print("Net scr:" .. blueScore, 240, 100)

    love.graphics.setColor(1, 0.5, 1)
    local font = love.graphics.newFont(14)
    love.graphics.print("FRW scr:" .. edgeScore, 240, 150)

    love.graphics.setColor(1, 1, 0.5)
    local font = love.graphics.newFont(14)
    love.graphics.print("TTL scr:" .. (driverScore + blueScore + edgeScore),
                        240, 200)
end

function printWin()
    if win then
        local font = love.graphics.newFont(14)
        love.graphics.print("WIN", 265, 100)
    end
end

function updateTimer()
    local timerCol = frametiker / 60
    love.graphics.setColor(timerCol, timerCol, timerCol)
    love.graphics.rectangle("fill", 250, 180, 50, 50, 3, 3, 5)
end