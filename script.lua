#include "Mod/script/debug/db.lua"
#include "Mod/script/grid/cell.lua"
#include "Mod/script/grid/grid.lua"
#include "Mod/script/grid/bounds.lua"
#include "Mod/script/player/player.lua"
#include "Mod/script/procgen/drawProcgen.lua"
#include "Mod/script/procgen/procgen.lua"
#include "Mod/script/procgen/tiles.lua"


config = {}
config.isRunning = true
config.showDebugMod = false
config.showGrid = true
config.flashTiles = false
config.showGridBoundaries = true


controls = {
    deleteTile = false,
    spawnTile  = false,
}



function Init()

    -- InitArgs() -- Init the args for the script entry point.

    InitGrid()
    InitPlayer()

    InitProcgen()
    GenerateTiles()
    UpdateBoundaries()

    print('Mod  initialized.')

end


function Tick()

    if InputPressed("f5") then config.isRunning = not config.isRunning end


    if not config.showDebugMod and config.showGrid and InputDown("lmb") then
        controls.spawnTile = true
    elseif not config.showDebugMod and config.showGrid and InputDown("rmb") then
        controls.deleteTile = true
    end


    if config.isRunning then

        -- Player
        TickPlayer()
        HighlightPlayerTile(Player, Tiles, TileSize)

        -- Grid
        UpdateTiles()
        ManageDynamicTileGeneration()
        UpdateBoundaries()
        ManageInput()

        DebugMod()

        -- if config.flashTiles then config.flashTiles() end

    end

    ResetControls()

end


function Update()
end


function Draw()

    local zoom = Player.camera.zoom.value

    UiFont("bold.ttf", (20 * 30/zoom))
    UiAlign("center middle")
    UiColor(0,0,0,1)
    UiTextOutline(1,1,1, 0.5, 0.2)

    drawDebug()

    if config.isRunning and config.showGrid then
        DrawWorldGrid(Player, Grid.dim[1], Grid.dim[3], TileSize)
    end

    if config.showGridBoundaries then
        DrawBounds(Procgen.boundaries, 1,1,1, 1)
        DrawBounds(GetBoundsOffset(Procgen.container, Player.gridTr.pos), 0,0,1, 1)
        DrawBounds(GetBoundsOffset(Procgen.bounds, Player.gridTr.pos), 0,1,0, 1)
    end

end


function ManageInput()

    if InputPressed("f8") then
        RegenerateTiles()
    end

    if InputPressed("mmb") then
        PlayerMode = not PlayerMode
    end

end


---Set all controls to false.
function ResetControls()
    for key, _ in pairs(controls) do
        controls[key] = false
    end
end