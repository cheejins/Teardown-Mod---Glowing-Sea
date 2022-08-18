--[[VECTORS]]
do
    --- Distance between two vectors.
    VecDist = function(a, b) return VecLength(VecSub(a, b)) end

    --- Divide a vector by another vector's components.
    VecDiv = function(a, b) return Vec(a[1] / b[1], a[2] / b[2], a[3] / b[3]) end

    VecMult = function(vec1, vec2)
        local vec = Vec(0,0,0)
        for i = 1, 3 do vec[i] = vec1[i] * vec2[i] end
        return vec
    end

    --- Add a table of vectors together.
    VecAddAll = function(vtb) local v = Vec(0,0,0) for i = 1, #vtb do VecAdd(v, vtb[i]) end return v end

    --- Returns a vector with random values.
    VecRandom = function(length)
        local v = VecNormalize(Vec(math.random(-10000000,10000000), math.random(-10000000,10000000), math.random(-10000000,10000000)))
        return VecScale(v, length)
    end

    --- Print QuatEulers or vectors.
    VecPrint = function(vec, label, decimals)
        DebugPrint((label or "") ..
        "  " .. sfn(vec[1], decimals or 2) ..
        "  " .. sfn(vec[2], decimals or 2) ..
        "  " .. sfn(vec[3], decimals or 2))
    end

    VecApproach = function(startPos, endPos, speed)
        local subtractedPos = VecScale(VecNormalize(VecSub(endPos, startPos)), speed)
        return VecAdd(startPos, subtractedPos)
    end
end


--[[AABB]]
do
    function AabbDimensions(min, max) return Vec(max[1] - min[1], max[2] - min[2], max[3] - min[3]) end
    function AabbDraw(v1, v2, r, g, b, a)
        r = r or 1
        g = g or 1
        b = b or 1
        a = a or 1
        local x1 = v1[1]
        local y1 = v1[2]
        local z1 = v1[3]
        local x2 = v2[1]
        local y2 = v2[2]
        local z2 = v2[3]
        -- x lines top
        DebugLine(Vec(x1,y1,z1), Vec(x2,y1,z1), r, g, b, a)
        DebugLine(Vec(x1,y1,z2), Vec(x2,y1,z2), r, g, b, a)
        -- x lines bottom
        DebugLine(Vec(x1,y2,z1), Vec(x2,y2,z1), r, g, b, a)
        DebugLine(Vec(x1,y2,z2), Vec(x2,y2,z2), r, g, b, a)
        -- y lines
        DebugLine(Vec(x1,y1,z1), Vec(x1,y2,z1), r, g, b, a)
        DebugLine(Vec(x2,y1,z1), Vec(x2,y2,z1), r, g, b, a)
        DebugLine(Vec(x1,y1,z2), Vec(x1,y2,z2), r, g, b, a)
        DebugLine(Vec(x2,y1,z2), Vec(x2,y2,z2), r, g, b, a)
        -- z lines top
        DebugLine(Vec(x2,y1,z1), Vec(x2,y1,z2), r, g, b, a)
        DebugLine(Vec(x2,y2,z1), Vec(x2,y2,z2), r, g, b, a)
        -- z lines bottom
        DebugLine(Vec(x1,y1,z2), Vec(x1,y1,z1), r, g, b, a)
        DebugLine(Vec(x1,y2,z2), Vec(x1,y2,z1), r, g, b, a)
    end
    function AabbCheckOverlap(aMin, aMax, bMin, bMax)
        return
        (aMin[1] <= bMax[1] and aMax[1] >= bMin[1]) and
        (aMin[2] <= bMax[2] and aMax[2] >= bMin[2]) and
        (aMin[3] <= bMax[3] and aMax[3] >= bMin[3])
    end
    function AabbCheckPointInside(aMin, aMax, pos)
        return
        (pos[1] <= aMax[1] and pos[1] >= aMin[1]) and
        (pos[2] <= aMax[2] and pos[2] >= aMin[2]) and
        (pos[3] <= aMax[3] and pos[3] >= aMin[3])
    end
    function AabbClosestEdge(pos, shape)

        local shapeAabbMin, shapeAabbMax = GetShapeBounds(shape)
        local bCenterY = VecLerp(shapeAabbMin, shapeAabbMax, 0.5)[2]
        local edges = {}
        edges[1] = Vec(shapeAabbMin[1], bCenterY, shapeAabbMin[3]) -- a
        edges[2] = Vec(shapeAabbMax[1], bCenterY, shapeAabbMin[3]) -- b
        edges[3] = Vec(shapeAabbMin[1], bCenterY, shapeAabbMax[3]) -- c
        edges[4] = Vec(shapeAabbMax[1], bCenterY, shapeAabbMax[3]) -- d

        local closestEdge = edges[1] -- find closest edge
        local index = 1
        for i = 1, #edges do
            local edge = edges[i]

            local edgeDist = VecDist(pos, edge)
            local closesEdgeDist = VecDist(pos, closestEdge)

            if edgeDist < closesEdgeDist then
                closestEdge = edge
                index = i
            end
        end
        return closestEdge, index
    end
    --- Sort edges by closest to startPos and closest to endPos. Return sorted table.
    function AabbSortEdges(startPos, endPos, edges)
        local s, startIndex = aabbClosestEdge(startPos, edges)
        local e, endIndex = aabbClosestEdge(endPos, edges)
        --- Swap first index with startPos and last index with endPos. Everything between stays same.
        edges = tableSwapIndex(edges, 1, startIndex)
        edges = tableSwapIndex(edges, #edges, endIndex)
        return edges
    end
    function AabbGetShapeCenterPos(shape)
        local mi, ma = GetShapeBounds(shape)
        return VecLerp(mi,ma,0.5)
    end
    function AabbGetBodyCenterPos(body)
        local mi, ma = GetBodyBounds(body)
        return VecLerp(mi,ma,0.5)
    end
    function AabbGetShapeCenterTopPos(shape, addY)
        addY = addY or 0
        local mi, ma = GetShapeBounds(shape)
        local v =  VecLerp(mi,ma,0.5)
        v[2] = ma[2] + addY
        return v
    end
    function AabbGetBodyCenterTopPos(body, addY)
        addY = addY or 0
        local mi, ma = GetBodyBounds(body)
        local v =  VecLerp(mi,ma,0.5)
        v[2] = ma[2] + addY
        return v
    end
end

--[[OBB]]
do
    function ObbDrawShape(shape)

        local shapeTr = GetShapeWorldTransform(shape)
        local shapeDim = VecScale(Vec(sx, sy, sz), 0.1)
        local maxTr = Transform(TransformToParentPoint(shapeTr, shapeDim), shapeTr.rot)

        for i = 1, 3 do

            local vec = Vec(0,0,0)

            vec[i] = shapeDim[i]

            DebugLine(shapeTr.pos, maxTr.pos)
            DebugLine(shapeTr.pos, TransformToParentPoint(shapeTr, vec), 0,1,0, 1)
            DebugLine(maxTr.pos, TransformToParentPoint(maxTr, VecScale(vec, -1)), 1,0,0, 1)

        end

    end
end

--[[PHYSICS]]
do
    -- Reduce the angular body velocity by a certain rate each frame.
    function DiminishBodyAngVel(body, rate)
        local angVel = GetBodyAngularVelocity(body)
        local dRate = rate or 0.99
        local diminishedAngVel = Vec(angVel[1]*dRate, angVel[2]*dRate, angVel[3]*dRate)
        SetBodyAngularVelocity(body, diminishedAngVel)
    end
    function IsMaterialUnbreakable(mat, shape)
        return mat == 'rock' or mat == 'heavymetal' or mat == 'unbreakable' or mat == 'hardmasonry' or
            HasTag(shape,'unbreakable') or HasTag(GetShapeBody(shape),'unbreakable')
    end
end

GetCrosshairWorldPos = function(rejectBodies)

    local crosshairTr = getCrosshairTr()
    -- rejectAllBodies(rejectBodies)
    local crosshairHit, crosshairHitPos = RaycastFromTransform(crosshairTr, 200)
    if crosshairHit then
        return crosshairHitPos
    else
        return nil
    end

end

GetCrosshairCameraTr = function(pos, x, y)

    pos = pos or GetCameraTransform()

    local crosshairDir = UiPixelToWorld(x or UiCenter(), y or UiMiddle())
    local crosshairQuat = DirToQuat(crosshairDir)
    local crosshairTr = Transform(GetCameraTransform().pos, crosshairQuat)

    return crosshairTr

end