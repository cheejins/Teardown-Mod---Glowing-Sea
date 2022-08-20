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
    TileLocations = { x = {}, z = {},}

end
