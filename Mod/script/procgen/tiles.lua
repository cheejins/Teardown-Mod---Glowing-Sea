Tiles = {}
TileIndex = 1

TileSize = CellSize
TileLocX = {} --- Used to find a tile by x location such as TileLocations[x][z].
TileLocZ = {} --- Used to find a tile by z location such as TileLocations[z][x].


----------------------------------------------------------------
-- Never change the index of a tile in Tiles.
----------------------------------------------------------------


function UpdateTiles()

    -- Set grid pos to camera pos.
    Grid.pos = {
        x = RoundToCellSize(Player.camera.tr.pos[1], TileSize),
        z = RoundToCellSize(Player.camera.tr.pos[3], TileSize)
    }


end


---Find a tile based on its world position.
---@param x number
---@param z number
---@return table tile tile object.
function GetTile(x, z)
    -- Match x and z to the same table.
    return TileLocX[x][z]
end

function CheckTileValid(ix, iz)

    if TileLocX[ix] then
        if TileLocX[ix][iz]then
            return true
        end
    end

    if TileLocZ[iz] then --todo optimize
        if TileLocZ[iz][ix]then
            return true
        end
    end

    return false
end

---The min and max positions of all tiles.
function UpdateBoundaries()
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
    TileIndex = 0

    TileSize = CellSize
    TileLocX = {} --- Used to find a tile by x location such as TileLocations[x][z].
    TileLocZ = {} --- Used to find a tile by z location such as TileLocations[z][x].

end


---Remove and completely delete a tile.
function DeleteTile(Tiles, x, z) --todo convert to 3d

    local tile = GetTile(x, z)

    Delete(tile.body)

    Tiles[tile.index] = nil
    TileLocX[x][z] = nil -- Remove tile reference from the TileLocX.
    TileLocZ[z][x] = nil -- Remove tile reference from the TileLocZ.

    if TableLength(TileLocX[x]) == 0 then TileLocX[x] = nil end -- Delete empty row/col tables.
    if TableLength(TileLocZ[z]) == 0 then TileLocZ[z] = nil end -- Delete empty row/col tables.

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
                    dbp("body not found")
                end
            end
        end

    end

end


-- function flashTiles()

--     flashCount = 4

--     config.flashTiles = config.flashTiles or {}

--     for i = 1, flashCount do

--         flash = config.flashTiles[flashCount]

--         lastTime1 = lastTime1 or 0

--         rx1 = rx1 or RoundToCellSize(math.random(-Grid.dim[1], Grid.dim[1]) + Grid.pos.x, TileSize)
--         rz1 = rz1 or RoundToCellSize(math.random(-Grid.dim[3], Grid.dim[3]) - Grid.pos.z, TileSize)

--         if GetTime() - lastTime1 >= 1/4 then
--             lastTime1 = GetTime()
--             rx1 = RoundToCellSize(math.random(-Grid.dim[1], Grid.dim[1]) + Grid.pos.x, TileSize)
--             rz1 = RoundToCellSize(math.random(-Grid.dim[3], Grid.dim[3]) - Grid.pos.z, TileSize)
--         end

--         local tile = GetTile(rx1, -rz1) or Tiles[1]
--         DrawBodyOutline(tile.body, 1,1,1, 1)

--     end

-- end

-- function CreateFlasheObjects(flashCount)
-- end


