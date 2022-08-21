function DebugMod()

    dbw('px', RoundToTileSize(Player.tr.pos[1], TileSize))
    dbw('pz', RoundToTileSize(Player.tr.pos[3], TileSize))

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
