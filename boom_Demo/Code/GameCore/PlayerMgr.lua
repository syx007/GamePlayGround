require("Code/GameCore/InputMgr");
require("Code/Graphic/AnimationSheet");
--all info and operation relate to player here

function initCursor()
    cursor = {}
    cursor.cx = 0
    cursor.cy = 0
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
