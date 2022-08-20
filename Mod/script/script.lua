#include "player/player.lua"
#include "debug/db.lua"
#include "procgen/procgen.lua"


RunArgs = {} ---Arguements for main.lua (master script).

tdsu = {} --- Functions


function Init()

    InitArgs() -- Init the args for the master script.
    InitUtils() -- Init the utils library.


    InitPlayer()
end

function Tick()
    TickUtils() -- Manage and run the utils library.

    TickPlayer()
end

function Update()
end
function Draw()
    DrawWorldGrid(Player, 50, 50, 10)
end



---Arguements for main.lua (master script).
function SetRunArgs(debug_script) RunArgs.debug_script = debug_script end
function InitArgs()
    -- if RunArgs.debug_script then DB = true end -- Debug the debugger (toggle on/off).
end
