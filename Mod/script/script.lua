#include "debug/db.lua"
#include "player/player.lua"
#include "procgen/procgen.lua"
#include "procgen/tiles.lua"


isRunning = true
RunArgs = {} ---Arguements for main.lua (master script).
tdsu = {} --- Functions


function Init()

    InitArgs() -- Init the args for the master script.

    InitPlayer()
    GenerateTiles()

    print('Mod  initialized.')
end

function Tick()

    if InputPressed("f4") then
        isRunning = not isRunning
    end

    if isRunning then

        TickPlayer()
        UpdateTiles()
        ManageDynamicTiles()

        HighlightPlayerTile(Player, Tiles, TileSize)

        if InputPressed("f5") then
            RegenerateTiles()
        end

        if InputPressed("rmb") then
            PlayerMode = not PlayerMode
        end

        DebugMod()

    end

end

function Update()
end
function Draw()
    if isRunning then
        DrawWorldGrid(Player, 50, 50, TileSize)
    end
end


---Arguements for main.lua (master script).
function SetRunArgs(debug_script) RunArgs.debug_script = debug_script end
function InitArgs()
    -- if RunArgs.debug_script then DB = true end -- Debug the debugger (toggle on/off).
end
