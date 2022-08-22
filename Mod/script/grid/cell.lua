---Get a value closest to tile spacing of the grid.
function RoundToCellSize(n, TileSize) return n - (n % TileSize) end -- Remove distance beyond grid point.
