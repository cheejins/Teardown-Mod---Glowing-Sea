Tiles = {}
TileIndex = 1

TileSize = 4
TileLocX = {} --- Used to find a tile by x location such as TileLocations[x][z].
TileLocZ = {} --- Used to find a tile by z location such as TileLocations[z][x].


----------------------------------------------------------------
-- Never change the index of a tile in Tiles.
----------------------------------------------------------------


function UpdateTiles()

    -- Set grid pos to player pos.
    Grid.pos = Vec(
        RoundToTileSize(Player.tr.pos[1], TileSize),
        0,
        RoundToTileSize(Player.tr.pos[3], TileSize)
    )

    -- Set grid pos to camera pos.
    Grid.pos = {
        x = RoundToTileSize(Player.camera.tr.pos[1], TileSize),
        z = RoundToTileSize(Player.camera.tr.pos[3], TileSize)
    }

    local shapes = FindShapes("procgen_tile", true)
    for _, shape in ipairs(shapes) do
        SetBodyDynamic(GetShapeBody(shape), false)
    end

end

function ManageDynamicTiles()

    -- Balance between deleting and spawning old and new tiles sequentially. (spread out linear processing to reduce lag spikes).

    -- Create new tiles within grid context

    local px = RoundToTileSize(Player.tr.pos[1], TileSize)
    local pz = RoundToTileSize(Player.tr.pos[3], TileSize)

    for x = -Grid.dim.x + px, Grid.dim.x + px, TileSize do
        for z = -Grid.dim.z + pz, Grid.dim.z + pz, TileSize do

            if not TileLocX[x] then
                TileLocX[x] = {}
            end

            if not TileLocX[x][z] then
                local tile = CreateTile(x, z, TileSize)
                SpawnTile(tile, TileSize)
            end
        end
    end

end


---Spawn all tiles in the Tiles table.
function GenerateTiles()

    local initBounds = Procgen.initBounds


    -- Create tile based on grid dimensions.
    for tx = -initBounds.x, initBounds.x, TileSize do
        for tz = -initBounds.z, initBounds.z, TileSize do
            CreateTile(tx, tz, TileSize)
        end
    end

    for _, tile in ipairs(Tiles) do
        SpawnTile(tile, TileSize)
    end

    -- PrintTable(Tiles, 4)
    -- PrintTable(TileLocations, 3)

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

    for _, e in ipairs(entities) do
        if GetEntityType(e) == "body" then
            tile.body = e
        end
    end

    tile.spawned = true

end


---Find a tile based on its world position.
---@param x number
---@param z number
---@return table tile tile object.
function GetTile(x, z)
    -- Match x and z to the same table.
    return TileLocX[x][z]
end


---The min and max positions of all tiles.
function UpdateBoundaries()

    SetBoundsMinMax(Procgen.boundaries, nil, TileSize)
    SetContextBounds(Procgen.bounds, Vec(Grid.pos.x, 0, Grid.pos.z), TileSize)

end

---
---@param Tiles any
---@param tilePos table Tile pos from origin. Example, player grid pos.
function GetTilesOutsideBoundary(Tiles, tilePos)

    -- local pgd = Procgen.boundaries

    -- for x =  do
    --     for z =  do

    --     end
    -- end

    -- local i = -25 + tilePos[1] -TileSize
    -- local lim = -100 + tilePos[1]

    -- -- Delete lower set
    -- for x = i, lim, -TileSize do
    --     if TileLocX[x] then
    --         for tz, tl in pairs(TileLocX[x]) do -- All tiles in row x

    --             DrawBodyHighlight(TileLocX[x][tz].body, 1)

    --             if InputPressed("lmb") then

    --                 -- DeleteTile(Tiles, TileLocX[x][tz].index)

    --                 local tile = TileLocX[x][tz]
    --                 print(tile.pos)

    --                 -- Tiles[]

    --             end

    --         end
    --     end
    -- end


    -- -- Delete higher set
    -- for x = 25 + tilePos[1] + TileSize, 100 + tilePos[1], TileSize do
    --     if TileLocX[x] then
    --         for tz, tl in pairs(TileLocX[x]) do -- All tiles in row x

    --             DrawBodyHighlight(TileLocX[x][tz].body, 1)

    --             if InputPressed("lmb") then
    --                 DeleteTile(Tiles, GetTile(x, tz).index)
    --             end

    --         end
    --     end
    -- end


    -- -- Delete lower set
    -- for z = -25 + tilePos[3] -TileSize, -100 + tilePos[3], -TileSize do
    --     if TileLocZ[z] then
    --         for tz, tl in pairs(TileLocZ[z]) do -- All tiles in row x

    --             DrawBodyHighlight(TileLocZ[z][tz].body, 1)

    --             if InputPressed("lmb") then
    --                 DeleteTile(Tiles, GetTile(tz, z).index)
    --             end

    --         end
    --     end
    -- end

    -- -- Delete higher set
    -- for z = 25 + tilePos[3] + TileSize, 100 + tilePos[3], TileSize do
    --     if TileLocZ[z] then
    --         for tz, tl in pairs(TileLocZ[z]) do -- All tiles in row x

    --             DrawBodyHighlight(TileLocZ[z][tz].body, 1)

    --             if InputPressed("lmb") then
    --                 DeleteTile(Tiles, GetTile(tz, z).index)
    --             end

    --         end
    --     end
    -- end

end


function ClearTiles()

    for _, tileShape in ipairs(FindShapes("procgen_tile", true)) do
        Delete(tileShape)
        Delete(GetShapeBody(tileShape))
    end

    Tiles = {}
    TileLocX = { x = {}, z = {} }

end


---Remove and completely delete a tile.
function DeleteTile(Tiles, i)
    Delete(Tiles[i].body)
    Tiles[i] = nil
end


---Get a value closest to tile spacing of the grid.
---@param x number
---@param TileSize any
---@return integer
function RoundToTileSize(x, TileSize)
    return x - (x % TileSize) -- Remove distance beyond grid point.
end


function RegenerateTiles()
    ClearTiles()
    InitProcgen()
    GenerateTiles()
end


---Highlight the tile the player is on.
---@param Player any
---@param Tiles any
---@param TileSize any
function HighlightPlayerTile(Player, Tiles, TileSize)

    local px = RoundToTileSize(Player.tr.pos[1], TileSize)
    local pz = RoundToTileSize(Player.tr.pos[3], TileSize)

    local tile = GetTile(px, pz)

    if tile.tr.pos[1] == px and tile.tr.pos[3] == pz then
        -- Get player pos in tile scale
        if tile.body then
            DrawBodyOutline(tile.body, 1,1,1, 1)
            DrawBodyHighlight(tile.body, 1)
        else
            print("body not found")
        end
    end

end


function FlashTiles()

    lastTime1 = lastTime1 or 0

    rx1 = rx1 or RoundToTileSize(math.random(-Grid.dim.x, Grid.dim.x) + Grid.pos.x, TileSize)
    rz1 = rz1 or RoundToTileSize(math.random(-Grid.dim.z, Grid.dim.z) - Grid.pos.z, TileSize)

    if GetTime() - lastTime1 >= 1/4 then
        lastTime1 = GetTime()
        rx1 = RoundToTileSize(math.random(-Grid.dim.x, Grid.dim.x) + Grid.pos.x, TileSize)
        rz1 = RoundToTileSize(math.random(-Grid.dim.z, Grid.dim.z) - Grid.pos.z, TileSize)
    end

    local tile = GetTile(rx1, -rz1)
    DrawBodyOutline(tile.body, 1,1,1, 1)



    lastTime2 = lastTime2 or 0

    rx2 = rx2 or RoundToTileSize(math.random(-Grid.dim.x, Grid.dim.x) + Grid.pos.x, TileSize)
    rz2 = rz2 or RoundToTileSize(math.random(-Grid.dim.z, Grid.dim.z) - Grid.pos.z, TileSize)

    if GetTime() - lastTime2 >= 1/4 then
        lastTime2 = GetTime()
        rx2 = RoundToTileSize(math.random(-Grid.dim.x, Grid.dim.x) + Grid.pos.x, TileSize)
        rz2 = RoundToTileSize(math.random(-Grid.dim.z, Grid.dim.z) - Grid.pos.z, TileSize)
    end

    local tile = GetTile(rx2, -rz2)
    DrawBodyOutline(tile.body, 1,1,1, 1)



    lastTime3 = lastTime3 or 0

    rx3 = rx3 or RoundToTileSize(math.random(-Grid.dim.x, Grid.dim.x) + Grid.pos.x, TileSize)
    rz3 = rz3 or RoundToTileSize(math.random(-Grid.dim.z, Grid.dim.z) - Grid.pos.z, TileSize)

    if GetTime() - lastTime3 >= 1/4 then
        lastTime3 = GetTime()
        rx3 = RoundToTileSize(math.random(-Grid.dim.x, Grid.dim.x) + Grid.pos.x, TileSize)
        rz3 = RoundToTileSize(math.random(-Grid.dim.z, Grid.dim.z) - Grid.pos.z, TileSize)
    end

    local tile = GetTile(rx3, -rz3)
    DrawBodyOutline(tile.body, 1,1,1, 1)

end
