function getCoreNameByID( id )
    local CoreNameID={
        "PCB",
        "Server",
        "Bridge",
        "Driver",
        "Processor"
    }
    return CoreNameID[id];
    --have to decide use 0-index or 1-index on this kind of ID.
end

function getSideNameByID( id )
    local SideNameID={
        "PCB",
        "SerialConnector",
        "ParallelConnector",
        "Firewall"
    }
    return SideNameID[id];
    --have to decide use 0-index or 1-index on this kind of ID.
end