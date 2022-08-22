function InitGrid()

    CellSize = 4

    local gridDim = CellSize * 3

    --- Context grid.
    Grid = {}
    Grid.pos     = { x = 0, y = 0,  z = 0 } -- Selected tile.
    Grid.dim     = Vec(gridDim, 0, gridDim) -- Draw dimensions of the grid.
    Grid.bounds  = CreateBounds2dBox(gridDim)

end


function SetGridBounds(tb_bounds, offset)

    offset = offset or Vec(0,0,0)

    return {
        tb_bounds.min[1] + offset[1],
        tb_bounds.min[3] + offset[3],
        tb_bounds.max[1] + offset[1],
        tb_bounds.max[3] + offset[3],
    }

end
