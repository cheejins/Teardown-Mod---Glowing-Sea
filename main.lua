#include "script.lua"
#include "TDSU/tdsu.lua"
#include "Automatic.lua"


--================================================
--Glowing Sea
--by: Cheejins
--================================================


function init()
    print("----------------------------------------------------------------")
    InitUtils() -- Init the utils library.
    Init()
end

function tick()
    TickUtils() -- Manage and run the utils library.
    Tick()
end

function update()
    Update()
end

function draw()
    Draw()
end


UpdateQuickloadPatch() --- umf goodliness
