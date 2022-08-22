Tiles = {}
TileIndex = 1

TileSize = CellSize
TileLocX = {} --- Used to find a tile by x location such as TileLocations[x][z].
TileLocZ = {} --- Used to find a tile by z location such as TileLocations[z][x].


----------------------------------------------------------------
-- Never change the index of a tile in Tiles.
----------------------------------------------------------------


function UpdateTiles()

    -- Set grid pos to player pos.
    Grid.pos = Vec(
        RoundToCellSize(Player.tr.pos[1], TileSize),
        0,
        RoundToCellSize(Player.tr.pos[3], TileSize)
    )

    -- Set grid pos to camera pos.
    Grid.pos = {
        x = RoundToCellSize(Player.camera.tr.pos[1], TileSize),
        z = RoundToCellSize(Player.camera.tr.pos[3], TileSize)
    }

    -- local shapes = FindShapes("procgen_tile", true)
    -- for _, shape in ipairs(shapes) do
    --     SetBodyDynamic(GetShapeBody(shape), false)
    -- end

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
    SetGridBounds(Procgen.bounds, Vec(Grid.pos.x, 0, Grid.pos.z))
end


---
---@param Tiles any
---@param tilePos table Tile pos from origin. Example, player grid pos.
function GetTilesOutsideBoundary(Tiles, tilePos)
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

    local px = RoundToCellSize(Player.tr.pos[1], TileSize)
    local pz = RoundToCellSize(Player.tr.pos[3], TileSize)

    if CheckTileValid(px, pz) then

        local tile = GetTile(px, pz)

        if tile then
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

    end

end


function flashTiles()

    flashCount = 4

    config.flashTiles = config.flashTiles or {}

    for i = 1, flashCount do

        flash = config.flashTiles[flashCount]

        lastTime1 = lastTime1 or 0

        rx1 = rx1 or RoundToCellSize(math.random(-Grid.dim[1], Grid.dim[1]) + Grid.pos.x, TileSize)
        rz1 = rz1 or RoundToCellSize(math.random(-Grid.dim[3], Grid.dim[3]) - Grid.pos.z, TileSize)

        if GetTime() - lastTime1 >= 1/4 then
            lastTime1 = GetTime()
            rx1 = RoundToCellSize(math.random(-Grid.dim[1], Grid.dim[1]) + Grid.pos.x, TileSize)
            rz1 = RoundToCellSize(math.random(-Grid.dim[3], Grid.dim[3]) - Grid.pos.z, TileSize)
        end

        local tile = GetTile(rx1, -rz1) or Tiles[1]
        DrawBodyOutline(tile.body, 1,1,1, 1)

    end

end

function CreateFlasheObjects(flashCount)
end

function CheckTileValid(ix, iz)
    if TileLocX[ix] and TileLocZ[iz] then return true end
    return false
end
