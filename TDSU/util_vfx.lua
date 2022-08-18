--[[COLOR]]
do
    Colors = {
        white   = Vec(1,1,1),
        black   = Vec(0,0,0),
        grey    = Vec(0,0,0),
        red     = Vec(1,0,0),
        blue    = Vec(0,0,1),
        yellow  = Vec(1,1,0),
        purple  = Vec(1,0,1),
        green   = Vec(0,1,0),
        orange  = Vec(1,0.5,0),
    }

    function DrawDot(pos, l, w, r, g, b, a, dt) DrawImage("ui/hud/dot-small.png", pos, l, w, r, g, b, a, dt) end

end


--[[]]
do
end