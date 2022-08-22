function InitProcgen()

    TileSize = 4

    -- Properties used to manage tiles.
    Procgen = {

        initBounds  = CreateBounds2dBox(2,  TileSize),  -- Initial tile generation bounds from center of the grid.
        bounds      = CreateBounds2dBox(4,  TileSize),  -- The bounds that all tiles are in.
        boundaries  = CreateBounds2dBox(10, TileSize), -- The tiles outside of this range will be disabled/deleted.
        container   = CreateBounds2dBox(10, TileSize)  -- Allow tiles to exist within these bounds relative to thegrid pos

    }

end


function ManageDynamicTileGeneration()

    -- Balance between deleting and spawning old and new tiles sequentially. (spread out linear processing to reduce lag spikes).
    -- Create new tiles within grid context


    local tiles = {} -- Tile indexes to spawn or delete.


    local px = RoundToCellSize(Player.tr.pos[1], TileSize)
    local pz = RoundToCellSize(Player.tr.pos[3], TileSize)

    for x = Procgen.bounds.min[1] + px, Procgen.bounds.max[1] + px, TileSize do
        for z = Procgen.bounds.min[3] + pz, Procgen.bounds.max[3] + pz, TileSize do

            if controls.spawnTile then

                SpawnDynamicTile(Vec(x, 0, z))

            elseif controls.deleteTile then

                if CheckTileValid(x, z) then
                    -- print("tile = ", x, z)
                    Explosion(GetTile(x,z).tr.pos, 1)
                end

            end

        end
    end

    -- for  do
    --     DeleteTile(Tiles, GetTile(x, z).index)
    -- end

end


function SpawnDynamicTile(grid_pos)

    if not TileLocX[grid_pos[1]] then
        TileLocX[grid_pos[1]] = {}
    end

    if not TileLocX[grid_pos[1]][grid_pos[3]] then
        local tile = CreateTile(grid_pos[1], grid_pos[3], TileSize)
        SpawnTile(tile, TileSize)
    end

end


---Spawn all tiles in the Tiles table.
function GenerateTiles(initBounds)

    local ib = Procgen.initBounds -- Initial bounds for tile spawn

    -- Create tile based on grid dimensions.
    for tx = ib.min[1], ib.max[1], TileSize do
        for tz = ib.min[3], ib.max[3], TileSize do
            CreateTile(tx, tz, TileSize)
        end
    end

    for _, tile in ipairs(Tiles) do
        SpawnTile(tile, TileSize)
    end

    -- PrintTable(Tiles, 2)
    -- PrintTable(TileLocX)
    -- PrintTable(TileLocZ)

end


---Create a tile object, instantiate and create references for it.
---@param x number
---@param z number
---@param tileSize number Used for grid spacing.
---@param color table A predefined color from the Colors table.
---@return table
function CreateTile(x, z, tileSize, color)

    lastColor = lastColor or Vec(0.5, 0.5, 0.5)

    for i = 1, 3 do
        lastColor[i] = lastColor[i] + (math.random() - 0.5)/5
    end

    local tile = {
        index = TileIndex,
        tr = Transform(Vec(x,0,z)),
        size = { x = tileSize or 0, y = tileSize or 0 },
        color = color or Vec(
            (1/4 + math.random() * 3/4 ),
            (1/4 + math.random() * 3/4 ),
            (1/4 + math.random() * 3/4 )),
        -- color = color or Vec(
        --     lastColor[1],
        --     lastColor[2],
        --     lastColor[3]),
        -- index = {}
    }

    -- Add tile to Tiles.
    table.insert(Tiles, tile)

    -- Used to reference tile by location.
    if not TileLocX[x] then
        TileLocX[x] = {} -- Create a x row if it does not exist.
        TileLocX[x][z] = tile
    else
        TileLocX[x][z] = tile
    end

    -- Used to reference tile by location.
    if not TileLocZ[z] then
        TileLocZ[z] = {} -- Create a z row if it does not ezist.
        TileLocZ[z][x] = tile
    else
        TileLocZ[z][x] = tile
    end

    tile.spawned = false

    TileIndex = TileIndex + 1

    return tile

end


function SpawnTile(tile, TileSize)

    local tx = tile.tr.pos[1]
    local tz = tile.tr.pos[3]

    local t_pgen = "procgen_tile "
    local t_x = "x=" .. tx .. " "
    local t_z = "z=" .. tz .. ""
    local tags = 'tags="' .. t_pgen .. t_x .. t_z .. '"'

    local xml = '<body dynamic="false">' .. '<voxbox ' .. tags .. ' pos="'..
        tx ..
        ' -0.1 ' ..
        tz ..
        '" texture="" size="' .. TileSize * 10 .. ' 1 ' .. TileSize * 10 .. '" color="' ..
        tile.color[1] .. " "..
        tile.color[2] .. " "..
        tile.color[3] .. '"/>' .. '</body>'

    local entities = Spawn(xml, Transform(Vec(0, 0, 0)))

    for _, b in ipairs(entities) do
        if GetEntityType(b) == "body" then
            tile.body = b
            SetBodyDynamic(b, false)
        end
    end

    tile.spawned = true

end
