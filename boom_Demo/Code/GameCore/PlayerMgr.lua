require("Code/GameCore/InputMgr");
require("Code/Graphic/AnimationSheet");
--all info and operation relate to player here

function initCursor(init_pos_x,init_pos_y)
    cursor = {}
    cursor.cx = init_pos_x
    cursor.cy = init_pos_y
    cursor.dx = 0
    cursor.dy = 0
    cursor.action = 0
    cursor.rotate = 0
end

function initMainMenuCursor()
    mmCursor = {}
    mmCursor.x=0
    mmCursor.dx=0
    mmCursor.action=0
end

function initGameOverCursor()
    goCursor = {}
    goCursor.x=0
    goCursor.dx=0
    goCursor.action=0
end
