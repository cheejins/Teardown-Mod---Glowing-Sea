Tiles = {}
TileSize = 5


Grid = {
    corner = { x = 0,  y = 0 }, -- Top left corner of the grid.
    pos    = { x = 0,  y = 0 }, -- Root grid used by the entire mod.
    dim    = { x = 25, z = 25 }, -- Draw dimensions of the grid.
}

TileBounds = { x = 50, z = 50 } -- Allow tiles to exist within these bounds relative to the grid pos
TileBoundaries = { x = 100, z = 100} -- Delete tiles outside of this range.


TileLocations = {} --- Used to find a tile reference by location such as TileLocations[x][z].


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
    if not TileLocations[x] then
        TileLocations[x] = {}
    else
        TileLocations[x][z] = tile
    end


    return tile

end


---Find a tile based on its world position.
---@param x number
---@param z number
---@return table tile tile object.
function GetTile(x, z)
    -- Match x and z to the same table.
    return TileLocations[x][z]
end


---Draw a world point grid with coordinates.
---@param gx number grid x pos.
---@param gz number grid z pos.
---@param spacing number space between points.
function DrawWorldGrid(Player, gx, gz, spacing)

    DebugLine(Vec(0,0,0), Vec(-10,0,0), 1,0,0, 1)
    -- DebugLine(Vec(0,0,0), Vec(0,-10,0), 0,1,0, 1)
    DebugLine(Vec(0,0,0), Vec(0,0,-10), 0,0,1, 1)

    spacing = spacing or 10
    local zoom = Player.camera.zoom.value

    local px = RoundToTileSize(Player.tr.pos[1], TileSize)
    local pz = RoundToTileSize(Player.tr.pos[3], TileSize)

    local gxStart = -gx/2 -- Bottom left corner of origin.
    local gzStart = -gz/2

    Grid.corner.x = px + gxStart -- Top left corner of the grid.
    Grid.corner.z = pz + gzStart -- Top left corner of the grid.

    for x = gxStart, gx/2, spacing do
        for z = gzStart, gz/2 - 1, spacing do

            local pos = Vec(x + px, 0, z + pz)
            local ux, uy = UiWorldToPixel(pos)

            UiFont("bold.ttf", (20 * 30/zoom))
            UiAlign("center middle")
            UiColor(0,0,0,1)
            UiTextOutline(1,1,1, 0.5, 0.2)

            UiPush()

                UiTranslate(ux, uy)
                UiImageBox("ui/common/dot.png", 8 * 30/zoom, 8 * 30/zoom, 0,0)

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

---Spawn all tiles in the Tiles table.
function GenerateTiles()

    local gd = Grid.dim

    -- Create tile based on dimensions.
    for tx = -gd.x, gd.x, TileSize do
        for tz = -gd.z, gd.z-1, TileSize do
            CreateTile(tx, tz, 10)
        end
    end

    for index, tile in ipairs(Tiles) do

        local tx = tile.tr.pos[1]
        local tz = tile.tr.pos[3]

        local xml = '<body dynamic="false">' .. '<voxbox tags="procgen_tile" pos="'..
            tx ..
            ' -0.1 ' ..
            tz ..
            '" texture="" size="' .. TileSize * 10 .. ' 1 ' .. TileSize * 10 .. '" color="' ..
            tile.color[1] .. " "..
            tile.color[2] .. " "..
            tile.color[3] .. '"/>' .. '</body>'

        local entities = Spawn(xml, Transform(Vec(0, 0, 0)))

        for index, entity in ipairs(entities) do
            if GetEntityType(entity) == "body" then
                tile.body = entity
            end
        end

    end

    local shapes = FindShapes("procgen_tile", true)
    for index, shape in ipairs(shapes) do
        SetBodyDynamic(GetShapeBody(shape), false)
    end


end

function UpdateTiles()

    -- Set grid pos to player pos.
    Grid.pos = {
        x = RoundToTileSize(Player.tr.pos[1], TileSize),
        z = RoundToTileSize(Player.tr.pos[3], TileSize)
    }

    -- -- Set grid pos to camera pos.
    -- Grid.pos = {
    --     x = GetTileScalePos(Player.camera.tr.pos[1], TileSize),
    --     z = GetTileScalePos(Player.camera.tr.pos[3], TileSize)
    -- }


    -- Update tile bounds.
    -- TileBounds.x =
    -- TileBounds.y =

    -- lastTime = lastTime or 0

    -- rx = rx or math.random(1, 4) * 5 * ternary(math.random() > 0.5, 1, -1)
    -- rz = rz or math.random(1, 4) * 5 * ternary(math.random() > 0.5, 1, -1)

    -- if GetTime() - lastTime >= 1 then
    --     lastTime = GetTime()
    --     rx = math.random(1, 4) * 5 * ternary(math.random() > 0.5, 1, -1)
    --     rz = math.random(1, 4) * 5 * ternary(math.random() > 0.5, 1, -1)
    -- end

    -- local tile = GetTile(rx, rz)
    -- DrawBodyOutline(tile.body, 1,1,1, 1)

end

function ManageDynamicTiles()

    -- Balance between deleting and spawning old and new tiles sequentially. (spread out linear processing to reduce lag spikes).

    local valid = false

    local tilesToDelete = {}


    -- Scan for tiles to remove.
    for i = 1, #Tiles do
        local tile = Tiles[i]

        local gpx = Grid.pos.x
        local gpz = Grid.pos.z


        -- -- Check and remove tile if outside of boundaries
        -- for x = Grid.x, TileSize do -- Check x values
        --     for z = Grid.z, TileSize do -- Check x values

        --         -- if  then

        --         -- end

        --     end
        -- end


        -- Check and add tile is within bounds to generate

    end


    -- for index, tileToDelete in ipairs(tilesToDelete) do
    --     -- DeleteTile(Tiles, tileToDelete)
    --     table.remove(Tiles, tileToDelete)
    -- end


    -- Scan for tiles to add.

end

function DeleteTile(Tiles, i)

    for index, shape in ipairs(GetBodyShapes(Tiles[i])) do
        Delete(shape)
    end

    table.remove(Tiles, i)

end

---Highlight the tile the player is on.
---@param Player any
---@param Tiles any
---@param TileSize any
function HighlightPlayerTile(Player, Tiles, TileSize)

    local px = RoundToTileSize(Player.tr.pos[1], TileSize)
    local pz = RoundToTileSize(Player.tr.pos[3], TileSize)

    -- Get player pos in tile scale
    DrawBodyOutline(GetTile(px, pz).body, 1,1,1, 1)
    DrawBodyHighlight(GetTile(px, pz).body, 1)

end

---Get a value closest to tile spacing of the grid.
---@param x any
---@param TileSize any
---@return integer
function RoundToTileSize(x, TileSize)
    return math.floor(x) - (math.floor(x) % TileSize) -- Remove distance beyond grid point.
end
