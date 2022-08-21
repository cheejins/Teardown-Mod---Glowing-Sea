#include "debug/db.lua"
#include "player/player.lua"
#include "procgen/procgen.lua"
#include "procgen/tiles.lua"
#include "ui/drawDebug.lua"


isRunning = true
RunArgs = {} ---Arguements for main.lua (master script).
tdsu = {} --- Functions


function Init()

    InitArgs() -- Init the args for the master script.

    InitPlayer()
    GenerateTiles()
    GetTilesBounds()

    print('Mod  initialized.')
end

function Tick()

    if InputPressed("f5") then
        isRunning = not isRunning
    end

    if isRunning then

        TickPlayer()
        UpdateTiles()
        ManageDynamicTiles()
        HighlightPlayerTile(Player, Tiles, TileSize)

        GetTilesOutsideBoundary(Tiles, Grid.pos)

        UpdateTilesBoundaries()

        if InputPressed("f8") then
            RegenerateTiles()
        end

        if InputPressed("rmb") then
            PlayerMode = not PlayerMode
        end

        if flashTiles then
            FlashTiles()
        end

        DebugMod()

    end

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


    if isRunning and showGrid then
        DrawWorldGrid(Player, Grid.dim.x, Grid.dim.z, TileSize)
    end

    if isRunning and showGridBoundaries then
        DrawTileBoundaries()
    end


    -- for index, shape in ipairs(FindShapes("procgen_tile", true)) do
    --     local x = GetTagValue(shape, "x")
    --     local z = GetTagValue(shape, "z")
    --     UiPush()
    --         ux, uz = UiWorldToPixel(Vec(x, 0, z))
    --         UiTranslate(ux, uz)
    --         UiText(sfn(x,0) .. " , " .. sfn(z,0))
    --     UiPop()
    --     -- local pos = VecAdd(GetShapeWorldTransform(shape).pos, Vec(0,1,0))
    -- end

    -- for index, tile in ipairs(Tiles) do
    --     if tile.tr.pos[3] == -50 then

    --         DrawDot(tile.tr.pos, 1,1, 1,1,1, 1)
    --         DrawBodyOutline(tile.body, 1,1,1, 1)

    --         UiPush()
    --             local ux, uz = UiWorldToPixel(tile.tr.pos)
    --             UiTranslate(ux, uz)
    --             UiText(sfn(tile.tr.pos[1],0) .. " , " .. sfn(tile.tr.pos[3],0))
    --         UiPop()

    --     end
    -- end

end


---Arguements for main.lua (master script).
function SetRunArgs(debug_script) RunArgs.debug_script = debug_script end
function InitArgs()
    -- if RunArgs.debug_script then DB = true end -- Debug the debugger (toggle on/off).
end
