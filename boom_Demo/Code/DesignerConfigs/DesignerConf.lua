function getGameStateName(id)
    local StateName = {
        "Main Menu", "Playing Game", "Register Score", "View Score"
    }
    return StateName[id + 1]
end

function getCoreNameByID(id)
    local CoreNameID = {
        "PCB", "Server", "NetworkCable", "Bridge", "Driver", "Processor"
    }
    return CoreNameID[id + 1]
    -- use 0 based index
end

function getSideNameByID(id)
    local SideNameID = {
        "PCB", "SerialConnector", "ParallelConnector", "Firewall"
    }
    return SideNameID[id + 1]
    ----use 0 based index
end