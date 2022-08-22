function InitProcgen()

    TileSize = 4

    -- Properties used to manage tiles.
    Procgen = {

        pos         = { x = 0,  z = 0 }, -- pos of
        initBounds  = { x = 20, z = 20 }, -- Initial tile generation dimensions.

        bounds      = CreateBounds(-40, -40, 40, 40), -- Allow tiles to exist within these bounds relative to thegrid pos
        boundaries  = CreateBounds(-100, -100, 100, 100), -- The tiles outside of this range will be disabled/deleted.

        container   = CreateBounds(0,0,0,0) -- The bounds that all tiles are in.

    }

end


function SetContextBounds(tb_bounds, offset, TileSize)

    offset = offset or Vec(0,0,0)

    return {
        tb_bounds.min.x + offset[1],
        tb_bounds.max.x + offset[1],
        tb_bounds.min.z + offset[3],
        tb_bounds.max.z + offset[3],
    }

end
