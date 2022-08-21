TileSize = 4


--- Context grid.
Grid = {
    pos     = { x = 0,  z = 0 }, -- Selected tile.
    dim     = { x = 12, z = 12 }, -- Draw dimensions of the grid.
    corner  = { x = 0,  z = 0 }, -- Top left corner of the grid.
}

-- Properties used to manage tiles.
Procgen = {
    pos         = { x = 0,  z = 0 },
    initBounds  = { x = 20, z = 20 }, -- Initial tile generation dimensions.
    bounds      = { x = 20, z = 20 }, -- Allow tiles to exist within these bounds relative to thegrid pos
    boundaries  = { -- The tiles outside of this range will be disabled/deleted.
        min = {
            x = -60,
            z = -60
        },
        max = {
            x = 60,
            z = 60
        }
    },
}


---Draw a world point grid with coordinates.
---@param gx number grid x pos.
---@param gz number grid z pos.
---@param spacing number space between points.
function DrawWorldGrid(Player, gx, gz, spacing)

    DebugLine(Vec(0,0,0), Vec(-10,0,0), 1,0,0, 1)
    -- DebugLine(Vec(0,0,0), Vec(0,-10,0), 0,1,0, 1)
    DebugLine(Vec(0,0,0), Vec(0,0,-10), 0,0,1, 1)

    spacing = spacing or TileSize
    local zoom = Player.camera.zoom.value

    local px = RoundToTileSize(Player.tr.pos[1], TileSize)
    local pz = RoundToTileSize(Player.tr.pos[3], TileSize)

    local gxStart = -Grid.dim.x -- Bottom left corner of origin.
    local gzStart = -Grid.dim.z

    UiPush()
        local ux, uy = UiWorldToPixel(Vec(0,0,0))
        UiTranslate(ux, uy)
        UiColor(1,1,1, 1)
        UiImageBox("ui/common/dot.png", 20 * 30/zoom, 20 * 30/zoom, 0,0)
    UiPop()

    for x = gxStart, Grid.dim.x, spacing do
        for z = gzStart, Grid.dim.z, spacing do

            local pos = Vec(x + px, 0, z + pz)
            local ux, uy = UiWorldToPixel(pos)

            UiFont("bold.ttf", 100/zoom*TileSize)
            UiAlign("center middle")
            UiColor(0,0,0,1)
            UiTextOutline(1,1,1, 0.5, 0.3)

            UiPush()

                UiTranslate(ux, uy)
                UiImageBox("ui/common/dot.png", 8 * 40/zoom, 8 * 40/zoom, 0,0)

            UiPop()

            UiPush()

                local pos = Vec(x + px + (spacing/2), 0, z + pz + (spacing/2))
                local ux, uy = UiWorldToPixel(pos)

                UiTranslate(ux, uy)
                local gdx = x + px
                local gdz = z + pz

                UiAlign("right middle")
                UiColor(1,0,0,1)
                UiText(gdx)

                UiAlign("center top")
                UiColor(0,0,0,1)
                UiText(",")

                UiAlign("left middle")
                UiColor(0,0,1,1)
                UiText(gdz)

            UiPop()

        end
    end

end



function DrawTileBoundaries()

    local TL = Vec(
        Procgen.boundaries.min.x,
        0,
        Procgen.boundaries.min.z
    )

    local TR = Vec(
        Procgen.boundaries.max.x + TileSize,
        0,
        Procgen.boundaries.min.z
    )

    local BL = Vec(
        Procgen.boundaries.min.x,
        0,
        Procgen.boundaries.max.z + TileSize
    )

    local BR = Vec(
        Procgen.boundaries.max.x + TileSize,
        0,
        Procgen.boundaries.max.z + TileSize
    )


    -- UiLine(min, max, 3, 1,0,0, 1) -- top
    -- UiLine(min, max, 3, 1,0,0, 1) -- bottom
    -- UiLine(uMinX, uMinZ, uMinX, uMaxZ, 3, 0,0,1, 1)
    -- UiLine(-100, -100, 100, 100, 3, 1,0,0, 1) -- top


    DebugLine(TL, TR, 1,0,0, 1)
    DebugLine(BL, BR, 1,0,0, 1)

    DebugLine(TL, BL, 1,0,0, 1)
    DebugLine(TR, BR, 1,0,0, 1)

end
