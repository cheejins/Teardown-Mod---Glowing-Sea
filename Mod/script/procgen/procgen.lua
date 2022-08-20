Grid = { x = 0, y = 0 } -- Root grid used by the entire mod.

Tiles = {}
TileSize = 5

-- Used to find a tile reference by location.
TileLocations = {
    x = {},
    z = {},
}


---Create a tile object, instantiate and create references for it.
---@param x number
---@param z number
---@param tileSize number Used for grid spacing.
---@param color table A predefined color from the Colors table.
---@return table
function CreateTile(x, z, tileSize, color)

    lastColor = lastColor or Vec(0.5, 0.5, 0.5)

    local col = Vec()
    for i = 1, 3 do
        lastColor[i] = lastColor[i] + (math.random()-0.5)/5
    end

    local tile = {
        tr = Transform(Vec(x,0,z)),
        size = { x = tileSize or 0, y = tileSize or 0 },
        color = color or Vec(1/3 + math.random() * 2/3, 1/3 + math.random() * 2/3, 1/3 + math.random() * 2/3),
        -- color = color or Vec(
        --     lastColor[1],
        --     lastColor[2],
        --     lastColor[3]),
        -- index = {}
    }

    -- Used to reference tile by location.
    TileLocations.x[x] = x
    TileLocations.z[z] = y

    -- Add tile to Tiles.
    table.insert(Tiles, tile)

    return tile

end


---Find a tile based on its world position.
---@param x number
---@param z number
---@return table tile tile object.
function FindTile(x, z)
    -- Match x and y as same table.
    if TileLocations.x[x] == TileLocations.x[z] then
        return TileLocations.x[x]
    end
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

    local px = math.floor(Player.tr.pos[1]) - (math.floor(Player.tr.pos[1]) % spacing)
    local pz = math.floor(Player.tr.pos[3]) - (math.floor(Player.tr.pos[3]) % spacing)

    dbw('Player.tr.pos[1]', sfn(Player.tr.pos[1]))
    dbw('Player.tr.pos[3]', sfn(Player.tr.pos[3]))
    dbw('px', px)
    dbw('pz', pz)
    dbw('Grid.x', Grid.x)
    dbw('Grid.z', Grid.z)

    local gxStart = -gx/2 -- Bottom left corner of origin.
    local gzStart = -gz/2

    Grid.x = px + gxStart --
    Grid.z = pz + gzStart --

    for x = gxStart, gx/2, spacing do
        for z = gzStart, gz/2, spacing do

            local pos = Vec(x + px, 0, z + pz)
            local ux, uy = UiWorldToPixel(pos)

            UiFont("regular.ttf", 20)
            UiAlign("center middle")
            UiColor(0,0,0,1)
            UiTextOutline(1,1,1, 0.4, 0.4)

            UiPush()
                UiTranslate(ux, uy)
                UiImageBox("ui/common/dot.png", 10,10, 0,0)

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

    -- Create tile based on dimensions.
    for tx = -30, 30, TileSize do
        for tz = -30, 30, TileSize do
            CreateTile(tx, tz, 10)
            print(tx,tz)
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

        local entity = Spawn(xml, Transform(Vec(0, 0, 0)))

    end

    local shapes = FindShapes("procgen_tile", true)
    for index, shape in ipairs(shapes) do
        SetBodyDynamic(GetShapeBody(shape), false)
    end

end

function GenerateDynamicTiles()

    -- Balance between deleting and spawning old and new tiles sequentially. (spread out linear processing to reduce lag spikes).

    -- Scan for tiles to remove.
    for i = 1, TileSize do



    end

    -- Scan for tiles to add.

end

function RegenerateTiles()

    ClearTiles()

    for index, tileShape in ipairs(FindShapes("procgen_tile", true)) do
        Delete(tileShape)
    end

    GenerateTiles()

end

function ClearTiles()

    local index = math.random(1,3)

    for i = 1, 3 do
        if i == index then
            lastColor[i] = 0.75
        else
            lastColor[i] = Clamp(math.random(), 0.25, 0.75)
        end
    end

    Tiles = {}

    TileLocations = {
        x = {},
        z = {},
    }

end
