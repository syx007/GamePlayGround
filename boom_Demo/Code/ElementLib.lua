function getElementByID(id)
    local Element0 = {}
    Element0.name = 'H'
    Element0.color = {34, 104, 189}
    local Element1 = {}
    Element1.name = 'He'
    Element1.color = {197, 112, 212}
    local Element2 = {}
    Element2.name = 'Li'
    Element2.color = {217, 217, 217}
    local Element3 = {}
    Element3.name = 'Be'
    Element3.color = {224, 150, 52}
    Element4 = {}
    Element4.name = 'B'
    Element4.color = {97, 60, 12}

    local chart = {Element0, Element1, Element2, Element3, Element4}

    -- return Element4;
    return chart[id]
end

function getTileElementByID(id)
    -- now design a tile is built by mutiple elements, core\north\south\east\west
    -- and actually has core/side. this has different type:
    -- core:ground/dam/lake/mill...
    -- side:ground/lake/road/grass...
    -- then use these tile to create a tile.
    -- +------2------+-
    ----+---------+---
    ------+++++++-----
    -- 1---+--0--+----4
    ------+++++++-----
    ----+---------+---
    -- +------3------+-

    -- side:
    -- ground:0
    -- water:1
    -- grass:2
    -- load:3

    -- core:
    -- ground:0
    -- water:1
    -- lake:2
    -- mill:3
    -- dam:4

    -- scheme-ID:01234
    -- RiverStraight:10110
    -- RiverLeft:11010
    -- RiverRight:10011
    -- RiverLake:10010
    -- Dam:40110

    -- nil for nothing
    local Element0 = {}
    Element0.name = 'Ground'
    local Element1 = {}
    Element1.name = 'RiverStraight'
    local Element2 = {}
    Element2.name = 'RiverLeft'
    local Element3 = {}
    Element3.name = 'RiverRight'
    local Element4 = {}
    Element4.name = 'RiverLake'
    local Element5 = {}
    Element5.name = 'RiverDam'

    local chart = {Element0, Element1, Element2, Element3, Element4, Element5}

    -- return Element4;
    return chart[id]
end

function SubTileColor(id)
    subTileColor = {}
    local subTileColorLib = {
        {0.36, 0.27, 0.0}, {0.18, 0.96, 1.0},{0.33, 0.64, 0.0}, {1.0, 0.9, 0.0}
    }
    subTileColor = subTileColorLib[id + 1]
end

function CoreColor(id)
    coreColor = {}
    local coreColorLib = {
        {0.36, 0.27, 0.0}, {0.18, 0.96, 1.0}, {0.58, 0.58, 0.58},
        {0.33, 0.64, 0.0}, {1.0, 0.6, 0.0}
    }
    coreColor = coreColorLib[id + 1]
end

function BlankElement()
    local e = {}
    e.id = 0
    e.rotation = 0
    e.connectivity = 0
    return e
end

function BlankTile()
    local e = {}
    -- e.id = math.floor( love.math.random( 1, 3 ) )*10000+math.floor( love.math.random( 1, 3 ) )*1000+math.floor( love.math.random( 1, 3 ) )*100+math.floor( love.math.random( 1, 3 ) )*10+math.floor( love.math.random( 1, 3 ) )
    e.id = 00000
    e.rotation = 1
    e.connectivity = 0
    return e
end

function BlankStruct()
    local e = {}
    e.id = 0
    e.rotation = 0
    e.connectivity = 0
    return e
end
