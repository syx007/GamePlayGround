-- luabit = require"bit"
function LoadCore2SideMap(Mapfile)
    -- Core2SideMap = {}
    -- -- local f = love.filesystem.read(Mapfile, "r")
    -- local f = io.open(Mapfile, "r")
    -- if f ~= nil then
    --     io.input(f)
    --     for i = 1, #coreTable do
    --         Core2SideMap[i] = {}
    --         local strtable = GetValuesfromCSVFormat(f:read())
    --         for j = 1, #sideTable do
    --             Core2SideMap[i][j] = tonumber(strtable[j])
    --         end
    --     end
    -- else
    --     love.graphics.print("file1 is nil", 10, 10)
    -- end
    -- print(Core2SideMap[1][1]);
    
    --static loading for packaging
    Core2SideMap={{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}}
end
-- key of Cores:CorePCB,CoreServer,CoreNetwork,CoreBridge,CoreDriver,CoreProcessor
-- key of Sides:SidePCB,SideSerialConnector,SideParllelConnector,SideFirewall
function initTiles()
    Tiles = {}
    -- LoadCore2SideMap("Assets\\Art\\Sprite\\Core2SideMap.map")
    for i = 1, #coreTable do
        Tiles[i] = {}
        for j = 1, #sideTable do
            if Core2SideMap[i][j] >= 0 then
                -- print(Core2SideMap[i][j])
                tile = {}
                tile.is_playing=false
                tile.Core = coreTable[i]
                tile.Side = sideTable[j]
                if Core2SideMap[i][j] == 0 then
                    tile.optional = true
                elseif Core2SideMap[i][j] == 1 then
                    tile.optional = false
                end
                tile.direction = 0
                Tiles[i][j] = tile
                -- print(i,j,Tiles[i][j].Core.name,Tiles[i][j].Side.name,Tiles[i][j].Core.f)
            end
        end
    end
end
--[[function AddTile2TileMap(grid_x,grid_y,core,side,connected_sides)
    --connected_sides:use 4-bit binrary 8421 code,north=1000b=8,east=0100b=4,sorth=0010b=2,west=0001b=1
    --use left shift operation to check: i=1, i=i<<1,if (i and connected_sides)~=0 then sorth=true 
    TileShown={}
    TileShown.x=grid_x
    TileShown.y=grid_y
    TileShown.side_direction=connected_sides
    TileShown.tile=Tiles[core][side]
    
    --TileMap[]
end]]

--[[function drawTileMap(grid_x,grid_y)
end
function item_rot()
end

function item_translate()
end

function item_set()
end]]
