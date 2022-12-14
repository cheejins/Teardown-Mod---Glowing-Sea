--[[TIMERS]]
do

    function TimerCreate(time, rpm)
        return DeepCopy({time = time, rpm = rpm})
    end

    ---Run a timer and a table of functions.
    ---@param timer table -- = {time, rpm}
    ---@param funcs_and_args table -- Table of functions that are called when time = 0. functions = {{func = func, args = {args}}}
    ---@param runTime boolean -- Decrement time when calling this function.
    function TimerRunTimer(timer, funcs_and_args, runTime)
        if timer.time <= 0 then
            TimerResetTime(timer)

            for i = 1, #funcs_and_args do
                funcs_and_args[i]()
            end

        elseif runTime then
            TimerRunTime(timer)
        end
    end

    -- Only runs the timer countdown if there is time left.
    function TimerRunTime(timer, stopPoint)
        if timer.time > (stopPoint or 0) then
            timer.time = timer.time - GetTimeStep()
        end
    end

    -- Set time left to 0.
    function TimerEndTime(timer)
        timer.time = 0
    end

    -- Reset time to start (60/rpm).
    function TimerResetTime(timer)
        timer.time = 60/timer.rpm
    end

    function TimerConsumed(timer)
        return timer.time == 0
    end

end


-- function CheckExplosions(cmd)

--     words = splitString(cmd, " ")
--     if #words == 5 then
--         if words[1] == "explosion" then

--             local strength = tonumber(words[2])
--             local x = tonumber(words[3])
--             local y = tonumber(words[4])
--             local z = tonumber(words[5])

--             -- DebugPrint('explosion: ')
--             -- DebugPrint('strength: ' .. strength)
--             -- DebugPrint('x: ' .. x)
--             -- DebugPrint('y: ' .. y)
--             -- DebugPrint('z: ' .. z)
--             -- DebugPrint('')

--         end
--     end

--     if #words == 8 then
--         if words[1] == "shot" then

--             local strength = tonumber(words[2])
--             local x = tonumber(words[3])
--             local y = tonumber(words[4])
--             local z = tonumber(words[5])
--             local dx = tonumber(words[6])
--             local dy = tonumber(words[7])
--             local dz = tonumber(words[8])

--             -- DebugPrint('shot: ')
--             -- DebugPrint('strength: ' .. strength)
--             -- DebugPrint('x: ' .. x)
--             -- DebugPrint('y: ' .. y)
--             -- DebugPrint('z: ' .. z)
--             -- DebugPrint('dx: ' .. dx)
--             -- DebugPrint('dy: ' .. dy)
--             -- DebugPrint('dz: ' .. dz)
--             -- DebugPrint('')

--         end
--     end

-- end


function AimSteerVehicle()

    local v = GetPlayerVehicle()
    if v ~= 0 then AimSteerVehicle(v) end

    local vTr = GetVehicleTransform(v)
    local camFwd = TransformToParentPoint(GetCameraTransform(), Vec(0,0,-1))

    local pos = TransformToLocalPoint(vTr, camFwd)
    local steer = pos[1] / 10

    DriveVehicle(v, 0, steer, false)

end