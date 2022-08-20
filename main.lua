#include "Mod/script/script.lua"
#include "TDSU/tdsu.lua"


--================================================
--Glowing Sea
--by: Cheejins
--================================================


function init()
    print("----------------------------------------------------------------")
    Init()
    InitUtils() -- Init the utils library.
end

function tick()
    Tick()
    TickUtils() -- Manage and run the utils library.
end

function update()
    Update()
end

function draw()
    Draw()
end


UpdateQuickloadPatch() --- umf goodliness
