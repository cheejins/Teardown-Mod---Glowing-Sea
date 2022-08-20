#include "debug/db.lua"
#include "player/player.lua"
#include "procgen/procgen.lua"
#include "procgen/tiles.lua"


RunArgs = {} ---Arguements for main.lua (master script).
tdsu = {} --- Functions


function Init()

    InitArgs() -- Init the args for the master script.

    InitPlayer()
    GenerateTiles()

end

function Tick()

    TickPlayer()
    -- GenerateDynamicTiles()
    UpdateTiles()
    HighlightPlayerTile(Player, Tiles, TileSize)

    if InputPressed("f5") then
        RegenerateTiles()
    end

    if InputPressed("rmb") then
        PlayerMode = not PlayerMode
    end

end

function Update()
end
function Draw()
    DrawWorldGrid(Player, 50, 50, TileSize)
end


---Arguements for main.lua (master script).
function SetRunArgs(debug_script) RunArgs.debug_script = debug_script end
function InitArgs()
    -- if RunArgs.debug_script then DB = true end -- Debug the debugger (toggle on/off).
end
