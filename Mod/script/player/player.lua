ShowCamera = true
PlayerMode = true

Player = {

    camera = {
        tr = Transform(),
        zoom = { value = 10, min = 10, max = 100, rate = 5 },
        pan = { value = 0, min = 1, max = 10, rate = 3 },
    },

    movement = {
        speed = 20,
        dirs = {
            { key ='w', dir = Vec(0,0,-1) },
            { key ='s', dir = Vec(0,0,1)  },
            { key ='a', dir = Vec(-1,0,0) },
            { key ='d', dir = Vec(1,0,0)  },
        }

    },

    tr = Transform()

}



function InitPlayer()

    Player.body = FindBody('playerbody', true)
    Player.camera.tr.rot = QuatEuler(-90, 0, 0)

end

function TickPlayer()

    Player.tr = GetBodyTransform(Player.body)
    Player.tr.pos = AabbGetBodyCenterPos(Player.body)

    DrawBodyOutline(Player.body, 0,1,0.5, 1)
    PointLight(VecAdd(Player.tr.pos, Vec(0, 0.5, 0)), 1,1,1, 0.5)

    if PlayerMode then
        PlayerRunCamera()
        PlayerRunMovement()
    end

end

function PlayerRunMovement()

    local movement = Player.movement
    local dirs = Player.movement.dirs

    local moving = false -- Check if player is being moved by movement keys.
    local moveDir = Vec(0,0,0) -- Default movement = no movent.
    for _, dir in ipairs(dirs) do
        if InputDown(dir.key) then -- If a movement key is active.

            moveDir = VecAdd(moveDir, dir.dir) -- Add all active movement directions.
            moving = true

        end
    end

    if moving then

        moveDir = VecNormalize(moveDir)
        if VecLength(vel) <= 10 then -- Check if under velocity limit.
            SetBodyVelocity(Player.body, VecScale(VecNormalize(moveDir), movement.speed)) -- Move player. Normalize movement direction.
        end

    else
        SetBodyVelocity(Player.body, Vec(0,0,0)) -- Slow player down when no movement key is active.
    end

end

function PlayerRunCamera()

    -- Zoom camera.
    local zoom = Player.camera.zoom
    local zoomNew = zoom.value - (InputValue("mousewheel") * zoom.rate)
    zoom.value = Clamp(zoomNew, zoom.min, zoom.max)


    -- -- Pan camera.
    -- local cam = Player.camera
    -- cam.tr.pos[1] = cam.tr.pos[1] - InputValue("mousedx")/100 * cam.pan.rate
    -- cam.tr.pos[2] = zoom.value
    -- cam.tr.pos[3] = cam.tr.pos[3] - InputValue("mousedy")/100 * cam.pan.rate

    -- Follow player camera.
    local cam = Player.camera
    cam.tr.pos[1] = GetBodyTransform(Player.body).pos[1]
    cam.tr.pos[2] = zoom.value
    cam.tr.pos[3] = GetBodyTransform(Player.body).pos[3]

    SetCameraTransform(Player.camera.tr)

end
