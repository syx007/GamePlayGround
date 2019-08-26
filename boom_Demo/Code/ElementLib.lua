function getElementByID(id)
    local Element0={}
    Element0.name='H';
    Element0.color={34,104,189};
    local Element1={}
    Element1.name='He';
    Element1.color={197,112,212};
    local Element2={}
    Element2.name='Li';
    Element2.color={217,217,217};
    local Element3={}
    Element3.name='Be';
    Element3.color={224,150,52};
    Element4={}
    Element4.name='B';
    Element4.color={97,60,12};

    local chart={Element0,Element1,Element2,Element3,Element4};

    -- return Element4;
    return chart[id];
end

function BlankElement()
    local e = {}
    e.id = 0
    e.connectivity = 0
    return e
end

function BlankStruct()
    local e = {}
    e.id = 0
    e.connectivity = 0
    return e
end