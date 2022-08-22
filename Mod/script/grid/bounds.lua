function CreateBounds(min, max) return { min = DeepCopy(min), max = DeepCopy(max) } end
function CreateBounds2d(minX, minZ, maxX, maxZ)
    return { min = Vec(minX, 0 , minZ), max = Vec(maxX, 0 , maxZ) }
end
function CreateBounds2dBox(length, scale)
    local ls = length * (scale or 1)
    return CreateBounds2d(-ls,-ls,ls,ls)
end


function SetBounds(bounds, min, max)
    bounds.min = DeepCopy(min)
    bounds.max = DeepCopy(max)
end


---Find the min and max indexes by iterating and comparing them.
function SetBoundsMinMax(bounds, offset, TileSize)

    offset = offset or Vec(0,0,0)

    bounds.min[1] = math.huge
    bounds.min[3] = math.huge
    bounds.max[1] = -math.huge
    bounds.max[3] = -math.huge

    -- Determine min and max x values.
    for k, v in pairs(TileLocX) do
        bounds.min[1] = math.min(k, bounds.min[1] + offset[1])
        bounds.max[1] = math.max(k, bounds.max[1] + offset[1])
    end

    -- Determine min and max z values.
    for k, v in pairs(TileLocZ) do
        bounds.min[3] = math.min(k, bounds.min[3] + offset[3])
        bounds.max[3] = math.max(k, bounds.max[3] + offset[3])
    end

    return bounds

end


---Get 2d bounds top left pos.
function GetBound2d_TL(bounds, v_offset) return VecAdd(Vec(vx(bounds.min), 0, vz(bounds.min)), v_offset) end
---Get 2d bounds top right pos.
function GetBound2d_TR(bounds, v_offset) return VecAdd(Vec(vx(bounds.max), 0, vz(bounds.min)), v_offset) end
---Get 2d bounds bottom left pos.
function GetBound2d_BL(bounds, v_offset) return VecAdd(Vec(vx(bounds.min), 0, vz(bounds.max)), v_offset) end
---Get 2d bounds bottom right pos.
function GetBound2d_BR(bounds, v_offset) return VecAdd(Vec(vx(bounds.max), 0, vz(bounds.max)), v_offset) end


---Add offset vec to each bounds vec.
function GetBoundsOffset(bounds, offsetPos) return { min = VecAdd(bounds.min, offsetPos), max = VecAdd(bounds.max, offsetPos) } end

---Return bounds offset
function BoundsScale(bounds, scale) return { min = VecScale(bounds.min, scale), max = VecScale(bounds.max, scale) } end

function DrawBounds(bounds, r,g,b, a)

    local VecTileX = Vec(TileSize, 0, 0)
    local VecTileZ = Vec(0, 0, TileSize)
    local VecTileXZ = Vec(TileSize, 0, TileSize)

    DebugLine(
        GetBound2d_TL(bounds),
        GetBound2d_TR(bounds, VecTileX),
        r or 1, g or 1, b or 1, a or 1) -- Top edge

    DebugLine(
        GetBound2d_BL(bounds, VecTileZ),
        GetBound2d_BR(bounds, VecTileXZ),
        r or 1, g or 1, b or 1, a or 1) -- Bottom edge

    DebugLine(
        GetBound2d_TL(bounds),
        GetBound2d_BL(bounds, VecTileZ),
        r or 1, g or 1, b or 1, a or 1) -- Left edge

    DebugLine(
        GetBound2d_TR(bounds, VecTileX),
        GetBound2d_BR(bounds, VecTileXZ),
        r or 1, g or 1, b or 1, a or 1) -- Right edge

end


-- function BoundsPrint(bounds) print(unpack(bounds)) end
