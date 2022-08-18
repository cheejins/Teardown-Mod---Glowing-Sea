RunArgs = {} ---Arguements for main.lua (master script).


function Init()
    InitArgs() -- Init the args for the master script.
    InitUtils() -- Init the utils library.
end

function Tick()
    TickUtils() -- Manage and run the utils library.
end

function Update()
end
function Draw()
end



---Arguements for main.lua (master script).
function SetRunArgs(debug_script) RunArgs.debug_script = debug_script end
function InitArgs()
    -- if RunArgs.debug_script then DB = true end -- Debug the debugger (toggle on/off).
end
