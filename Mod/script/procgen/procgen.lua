Grid = { x = 0, y = 0 } -- Root grid used by the entire mod.
GridDimensions = { x = 25, z = 25 }

Tiles = {}
TileSize = 5

-- Used to find a tile reference by location.
TileLocations = {}

TileBounds = { x = 0, y = 0 }


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

    local px = GetTileScalePos(Player.tr.pos[1], TileSize)
    local pz = GetTileScalePos(Player.tr.pos[3], TileSize)

    dbw('Player.tr.pos[1]', sfn(Player.tr.pos[1]))
    dbw('Player.tr.pos[3]', sfn(Player.tr.pos[3]))
    dbw('px', px)
    dbw('pz', pz)
    dbw('Grid.x', Grid.x)
    dbw('Grid.z', Grid.z)
    dbw('#Tiles', #Tiles)


    local gxStart = -gx/2 -- Bottom left corner of origin.
    local gzStart = -gz/2

    Grid.x = px + gxStart -- Top left corner of the grid.
    Grid.z = pz + gzStart -- Top left corner of the grid.

    for x = gxStart, gx/2, spacing do
        for z = gzStart, gz/2, spacing do

            local pos = Vec(x + px, 0, z + pz)
            local ux, uy = UiWorldToPixel(pos)

            UiFont("bold.ttf", 18)
            UiAlign("center middle")
            UiColor(0,0,0,1)
            UiTextOutline(1,1,1, 0.3, 0.3)

            UiPush()

                UiTranslate(ux, uy)
                UiImageBox("ui/common/dot.png", 8,8, 0,0)

                UiTranslate(0, 20)
                local gdx = x + px
                local gdz = z + pz
                local coord = '(' .. gdx .. ' , ' .. gdz .. ')'
                UiText(coord)

            UiPop()

        end
    end

end


function GenerateTiles()

    local gd = GridDimensions

    -- Create tile based on dimensions.
    for tx = -gd.x, gd.x-1, TileSize do
        for tz = -gd.z, gd.z-1, TileSize do
            CreateTile(tx, tz, 10)
            -- print(tx,tz)
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
        -- print(xml)

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

    -- Update tile bounds.
    -- TileBounds.x =
    -- TileBounds.y =

    lastTime = lastTime or 0

    rx = rx or math.random(1, 4) * 5 * ternary(math.random() > 0.5, 1, -1)
    rz = rz or math.random(1, 4) * 5 * ternary(math.random() > 0.5, 1, -1)

    if GetTime() - lastTime >= 1 then
        lastTime = GetTime()
        rx = math.random(1, 4) * 5 * ternary(math.random() > 0.5, 1, -1)
        rz = math.random(1, 4) * 5 * ternary(math.random() > 0.5, 1, -1)
    end

    DrawBodyOutline(GetTile(rx, rz).body, 1,1,1, 1)

end

function GenerateDynamicTiles()

    -- Balance between deleting and spawning old and new tiles sequentially. (spread out linear processing to reduce lag spikes).

    local valid = false


    local tilesToDelete = {}

    -- -- Scan for tiles to remove.
    -- for i = 1, #TileLocations[x] do
    --     local tile = Tiles[i]
    -- end


    for index, tileToDelete in ipairs(tilesToDelete) do
        -- DeleteTile(Tiles, tileToDelete)
        table.remove(Tiles, tileToDelete)
    end


    -- Scan for tiles to add.

end

function DeleteTile(Tiles, i)

    for index, shape in ipairs(GetBodyShapes(Tiles[i])) do
        Delete(shape)
    end

    table.remove(Tiles, i)

end


function HighlightPlayerTile(Player, Tiles, TileSize)

    local px = GetTileScalePos(Player.tr.pos[1], TileSize)
    local pz = GetTileScalePos(Player.tr.pos[3], TileSize)

    -- Get player pos in tile scale
    DrawBodyOutline(GetTile(px, pz).body, 1,1,1, 1)
    DrawBodyHighlight(GetTile(px, pz).body, 1)

end

---Get a value closest to tile spacing of the grid.
---@param x any
---@param TileSize any
---@return integer
function GetTileScalePos(x, TileSize)
    return math.floor(x) - (math.floor(x) % TileSize)
end