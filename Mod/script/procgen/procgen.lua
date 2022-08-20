-- VoxBoxes = {
--     planes = {25,50,100}
-- }


---comment
---@param gx number grid x pos
---@param gz number grid z pos
---@param spacing any
function DrawWorldGrid(Player, gx, gz, spacing)

    DebugLine(Vec(0,0,0), Vec(-10,0,0), 1,0,0, 1)
    -- DebugLine(Vec(0,0,0), Vec(0,-10,0), 0,1,0, 1)
    DebugLine(Vec(0,0,0), Vec(0,0,-10), 0,0,1, 1)

    spacing = spacing or 10

    local px = math.floor(Player.tr.pos[1]) - (math.floor(Player.tr.pos[1]) % spacing)
    local pz = math.floor(Player.tr.pos[3]) - (math.floor(Player.tr.pos[3]) % spacing)

    dbw('px', px)
    dbw('pz', pz)

    local gxStart = -gx/2 -- Bottom left corner of origin.
    local gzStart = -gz/2

    for x = gxStart, gx/2, spacing do
        for z = gzStart, gz/2, spacing do

            local pos = Vec(x + px, 0, z + pz)
            local ux, uy = UiWorldToPixel(pos)

            UiFont("regular.ttf", 20)
            UiAlign("center top")
            UiTextOutline(0,0,0, 0.4, 0.4)

            UiPush()
                UiTranslate(ux, uy)
                UiImageBox("ui/common/dot.png", 10,10, 0,0)

                UiTranslate(0, 20)

                local coord = '(' .. x + px .. ' , ' .. z + pz .. ')'
                UiText(coord)

            UiPop()

        end
    end

end
