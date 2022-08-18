--[[MATH]]
do

    -- If n is less than zero, return a small number.
    function GTZero(n) if n <= 0 then return 1/math.huge end return n end

    -- Return a positive non-zero number if n == 0.
    function NZero(n) if n == 0 then return 1/math.huge end return n end

    ---Return a random number.
    function Random(min, max) return math.random(min, max - 1) + math.random() end

    ---Contrain a number between two numbers.
    function Clamp(value, min, max)
        if value < min then value = min end
        if value > max then value = max end
        return value
    end

    ---Oscillate a value between 0 and 1 based on time.
    ---@param time number Seconds to complete a oscillation period.
    function Oscillate(time)
        local a = (GetTime() / (time or 1)) % 1
        a = a * math.pi
        return math.sin(a)
    end

    ---Linear interpolation between two values.
    function Lerp(a,b,t) return a + (b-a) * 0.5 * t end

    ---Round a number to n decimals.
    function Round(x, n)
        n = 10 ^ (n or 0)
        x = x * n
        if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
        return x / n
    end

    ---Approach a value at a specified rate.
    function ApproachValue(value, target, rate)
        if value >= target then

            if value - rate < target then
                return target
            else
                return value - rate
            end

        elseif value < target then

            if value + rate > target then
                return target
            else
                return value + rate
            end

        end
    end

end


--[[QUERY]]
do
    ---comment
    ---@param tr table -- Source transform.
    ---@param distance number -- Max raycast distance. Default is 300.
    ---@param rad number -- Raycst radius.
    ---@param rejectBodies table -- Table of bodies to reject.
    ---@param rejectShapes table -- Table of shapes to reject.
    ---@param returnNil boolean -- If true, return nil if no raycast hit. If false, return the end point of the raycast based on the transfom and distance.
    ---@return boolean h
    ---@return table p
    ---@return table s
    ---@return table b
    ---@return number d
    ---@return number n
    function RaycastFromTransform(tr, distance, rad, rejectBodies, rejectShapes, returnNil)

        if distance == nil then distance = 300 end

        if rejectBodies ~= nil then for i = 1, #rejectBodies do QueryRejectBody(rejectBodies[i]) end end
        if rejectShapes ~= nil then for i = 1, #rejectShapes do QueryRejectShape(rejectShapes[i]) end end

        returnNil = returnNil or false

        local direction = QuatToDir(tr.rot)
        local h, d, n, s = QueryRaycast(tr.pos, direction, distance, rad)
        if h then
            local p = TransformToParentPoint(tr, Vec(0, 0, d * -1))
            local b = GetShapeBody(s)
            return h, p, s, b, d, n
        elseif not returnNil then
            return true, TransformToParentPoint(tr, Vec(0,0,-300)) ---@return table A pos 300m infront of the player.
        end
    end

end


--[[BOOLEAN]]
function boolflip(bool) return not bool end