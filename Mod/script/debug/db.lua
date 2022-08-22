
function drawDebug()

    if InputPressed("backspace") then
        config.showDebugMod = not config.showDebugMod
    end

    if config.showDebugMod then

        UiMakeInteractive()

        margin(UiCenter(), 500)
        AutoContainer(800, 500, 2, false, true)

        -- AutoText("Procgen.bounds = " .. Procgen.bounds.max[3]*2, 20, true, 0)
        AutoText("Procgen.bounds = " .. Procgen.bounds.max[1], 20, true, 0)
        UiTranslate(0, 24)

        local length = AutoSlider(Procgen.bounds.max[1], 0, TileSize*10, TileSize, 0, 0, 0)
        Procgen.bounds = CreateBounds2dBox(length)

        -- Grid.dim[1] = AutoSlider(Grid.dim[1], 0, TileSize*10, TileSize, 0, 0, 0)
        -- Grid.dim[3] = Grid.dim[1]

        margin(0, 40)
        AutoSpreadHorizontal(1)
            db = AutoButton(db, "debug mode", 30, 0, 0, true, 0)
        AutoSpreadEnd()

        margin(0, 40)
        -- AutoSpreadHorizontal(3)
        config.showGrid = AutoButton(config.showGrid, "config.showGrid", 30, 0, 0, true, 0)
        margin(0, 40)
        config.showGridBoundaries = AutoButton(config.showGridBoundaries, "config.showGridBoundaries", 30, 0, 0, true, 0)
        margin(0, 40)
            config.flashTiles = AutoButton(config.flashTiles, "config.flashTiles", 30, 0, 0, true, 0)
        -- AutoSpreadEnd()

    end

end


function DebugMod()

    dbw('px', RoundToCellSize(Player.tr.pos[1], TileSize))
    dbw('pz', RoundToCellSize(Player.tr.pos[3], TileSize))

    -- dbw('Grid.corner[1]', Grid.corner[1])
    -- dbw('Grid.corner[3]', Grid.corner[3])
    dbw('Grid.dim[1]', Grid.dim[1])
    dbw('Grid.dim[3]', Grid.dim[3])

    dbw('Grid.pos[1]', Grid.pos[1])
    dbw('Grid.pos[3]', Grid.pos[3])

    -- dbw('Player.tr.pos[1]', sfn(Player.tr.pos[1]))
    -- dbw('Player.tr.pos[3]', sfn(Player.tr.pos[3]))

    dbw('TileIndex', TileIndex)
    dbw('#Tiles', #Tiles)
    dbw('#TileLocX', #TileLocX)
    dbw('#TileLocZ', #TileLocZ)
    dbw('#Shapes', #FindShapes("", true))
    dbw('#Bodies', #FindBodies("", true))

end
