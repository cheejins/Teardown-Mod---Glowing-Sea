showDebugMod = false
showGrid = true
flashTiles = false
showGridBoundaries = true


function drawDebug()

    if InputPressed("backspace") then
        showDebugMod = not showDebugMod
    end

    if showDebugMod then

        UiMakeInteractive()

        margin(UiCenter(), 500)
        AutoContainer(800, 500, 2, false, true)

        AutoText("Grid.dim.x = " .. Grid.dim.x, 20, true, 0)
        UiTranslate(0, 24)
        Grid.dim.x = AutoSlider(Grid.dim.x, 0, TileSize*10, TileSize, 0, 0, 0)
        Grid.dim.z = Grid.dim.x

        margin(0, 40)
        AutoSpreadHorizontal(1)
            db = AutoButton(db, "debug mode", 30, 0, 0, true, 0)
        AutoSpreadEnd()

        margin(0, 40)
        -- AutoSpreadHorizontal(3)
        showGrid = AutoButton(showGrid, "showGrid", 30, 0, 0, true, 0)
        margin(0, 40)
        showGridBoundaries = AutoButton(showGridBoundaries, "showGridBoundaries", 30, 0, 0, true, 0)
        margin(0, 40)
            flashTiles = AutoButton(flashTiles, "flashTiles", 30, 0, 0, true, 0)
        -- AutoSpreadEnd()

    end

end


function DebugMod()

    dbw('px', RoundToCellSize(Player.tr.pos[1], TileSize))
    dbw('pz', RoundToCellSize(Player.tr.pos[3], TileSize))

    -- dbw('Grid.corner.x', Grid.corner.x)
    -- dbw('Grid.corner.z', Grid.corner.z)
    dbw('Grid.dim.x', Grid.dim.x)
    dbw('Grid.dim.z', Grid.dim.z)

    dbw('Grid.pos[1]', Grid.pos[1])
    dbw('Grid.pos[3]', Grid.pos[3])

    -- dbw('Player.tr.pos[1]', sfn(Player.tr.pos[1]))
    -- dbw('Player.tr.pos[3]', sfn(Player.tr.pos[3]))

    dbw('#Tiles', #Tiles)
    dbw('#Shapes', #FindShapes("", true))
    dbw('#Bodies', #FindBodies("", true))

end
