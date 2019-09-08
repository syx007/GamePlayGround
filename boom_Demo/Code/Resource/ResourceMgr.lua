-- currently, it only finish a very simple job--just load some image and wav
-- in future, we could do path management, auto loading, or even strip during packaging
require("Code/DesignerConfigs/DesignerConf")
-- body
-- Sprite Name Format:
-- Core:
-- sp_Core[ID]_[fCount]
-- Side:
-- sp_Side[ID]_[fCount]

-- same for Tile and Side
-- .id
-- .name
-- .content//Actual Image Object
-- .fCount
function getCoreResByID(id) return coreTable[id + 1] end
function getSideResByID(id) return sideTable[id + 1] end

function getCoreResCount() return coreTableCount end
function getSideResCount() return sideTableCount end

-- Function about this line are all API, uploaded API don't get deleted.

function initfilePathConstant()
    ArtSpritePath = "Art/Sprite/"
    ArtMapPath = "Art/Map/"
    ArtLogoPath = "Art/Logo/"
    ArtFontPath = "Art/Font/"

    MusicSFXPath = "Music/SFX/"

    CoreFolderName = "Core/"
    SideFolderName = "Side/"

    GameLogoName = "GameLogo.png"
end

function extractDataFromName(name)
    local data = name:sub(8)
    return string.gmatch(data, "[^_]+")
end

function discardExtensionName(name) return string.match(name, "[^.]+") end

function loadUIResource()
    -- this is relative fix path UI image
    -- so, just write here as fix loading
    mainGameLogo = love.graphics.newImage(ArtLogoPath .. GameLogoName)
    gamePlayUIBG = love.graphics.newImage("Art/Map/gamePlayBG.png")
end

function loadResource()
    initfilePathConstant()
    loadUIResource()
    local ArtCoreSpritePath = ArtSpritePath .. CoreFolderName
    local ArtSideSpritePath = ArtSpritePath .. SideFolderName

    local coreFiles = love.filesystem.getDirectoryItems(ArtCoreSpritePath)
    local sideFiles = love.filesystem.getDirectoryItems(ArtSideSpritePath)

    coreTable = {}
    sideTable = {}
    coreTableCount = 0
    sideTableCount = 0

    for f in pairs(coreFiles) do
        coreFileName = discardExtensionName(coreFiles[f])
        local coreFileDataList = {}
        for word in extractDataFromName(coreFileName) do
            coreFileDataList[#coreFileDataList + 1] = word
        end
        local tid = tonumber(coreFileDataList[1]) + 1
        local id = tonumber(coreFileDataList[1])

        coreTable[tid] = {}
        coreTable[tid].name = getCoreNameByID(coreFileDataList[1]) -- TODO
        coreTable[tid].id = id
        coreTable[tid].content = love.graphics.newImage(
                                     ArtCoreSpritePath .. coreFiles[f])
        coreTable[tid].fCount = tonumber(coreFileDataList[2]) -- TODO
        coreTableCount = coreTableCount + 1
    end

    for f in pairs(sideFiles) do
        sideFileName = discardExtensionName(sideFiles[f])
        local sideFileDataList = {}
        for word in extractDataFromName(sideFileName) do
            sideFileDataList[#sideFileDataList + 1] = word
        end
        local tid = tonumber(sideFileDataList[1]) + 1
        local id = tonumber(sideFileDataList[1])

        sideTable[tid] = {}
        sideTable[tid].name = getCoreNameByID(sideFileDataList[1]) -- TODO
        sideTable[tid].id = id
        sideTable[tid].content = love.graphics.newImage(
                                     ArtSideSpritePath .. sideFiles[f])
        sideTable[tid].fCount = tonumber(sideFileDataList[2]) -- TODO
        -- fighter0:setFilter("nearest", "nearest")
        sideTableCount = sideTableCount + 1
    end
end
