function InitProcgen()

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

        bounds      = CreateBounds(-40, -40, 40, 40), -- Allow tiles to exist within these bounds relative to thegrid pos
        boundaries  = CreateBounds(-100, -100, 100, 100), -- The tiles outside of this range will be disabled/deleted.

        container   = CreateBounds(0,0,0,0) -- The bounds that all tiles are in.

    }

end


---Return the min and max points by iterating and comparing them.
---@param tb_bounds any
---@param offset any
---@param TileSize any
---@return any
function SetBoundsMinMax(tb_bounds, offset, TileSize)

    offset = offset or Vec(0,0,0)

    tb_bounds.min.x = math.huge
    tb_bounds.max.x = -math.huge
    tb_bounds.min.z = math.huge
    tb_bounds.max.z = -math.huge

    -- Determine min and max x values.
    for k, v in pairs(TileLocX) do
        tb_bounds.min.x = math.min(k, tb_bounds.min.x + offset[1])
        tb_bounds.max.x = math.max(k, tb_bounds.max.x + offset[1])
    end

    -- Determine min and max z values.
    for k, v in pairs(TileLocZ) do
        tb_bounds.min.z = math.min(k, tb_bounds.min.z + offset[3])
        tb_bounds.max.z = math.max(k, tb_bounds.max.z + offset[3])
    end

    return tb_bounds

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


function CreateBounds(minX, minZ, maxX, maxZ)
    return { min = {x = minX, z = minZ}, max = {x = maxX, z = maxZ} }
end
