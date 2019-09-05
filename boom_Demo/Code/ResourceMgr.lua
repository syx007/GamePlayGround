-- currently, it only finish a very simple job--just load some image and wav
-- in future, we could do path management, auto loading, or even strip during packaging
require("Code/DesignerConf")
function initfilePathConstant()
    ArtSpritePath = "Art/Sprite/"
    ArtMapPath = "Art/Map/"
    ArtLogoPath = "Art/Logo/"
    ArtFontPath = "Art/Font/"

    MusicSFXPath = "Music/SFX/"

    CoreFolderName = "Core/"
    SideFolderName = "Side/"
end

function loadResource()
    initfilePathConstant()
    local ArtCoreSpritePath = ArtSpritePath .. CoreFolderName
    local ArtSideSpritePath = ArtSpritePath .. SideFolderName
    -- body
    -- Sprite Name Format:
    -- Core:
    -- sp_Core[ID]
    -- Side:
    -- sp_Side[ID]
    -- fighter0=love.graphics.newImage(ArtSpitePath..CoreFolderName.."Fighter0_0.png");

    local files = love.filesystem.getDirectoryItems(ArtCoreSpritePath)

    coreTable = {}

    for f in pairs(files) do
        fileName = files[f]
        coreTable[f] = {}
        coreTable[f].name = getCoreNameByID(0) -- TODO
        coreTable[f].id = f - 1
        coreTable[f].content = love.graphics.newImage(
                                   ArtCoreSpritePath .. fileName)
        coreTable[f].fCount = 0 -- TODO
    end
end

-- function loadResource()
-- 	fighter0=love.graphics.newImage("Art/Sprite/Fighter0_0.png");
-- 	bullet0=love.graphics.newImage("Art/Sprite/Bullet0_0.png");
-- 	emptybullet0=love.graphics.newImage("Art/Sprite/Bullet0_1.png");
-- 	shootSFX = love.audio.newSource("Music/SFX/Hit_00.wav", "static");
-- 	noBulletSFX = love.audio.newSource("Music/SFX/Open_01.wav", "static");
-- 	ship = love.graphics.newImage("Art/Sprite/ship.png");
-- end
