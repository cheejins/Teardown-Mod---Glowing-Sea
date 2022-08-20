#include "Mod/script/script.lua"
#include "TDSU/tdsu.lua"


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
