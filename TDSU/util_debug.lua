---Handles the toggling of debug mode.
---@param tb_keys table Table of combo key strings which activate/deactivate debug mode when pressed together.
function debug(tb_keys)

    if tb_keys == nil then tb_keys = {'ctrl', 'shift', 'alt'} end

    db = GetBool('savegame.mod.debugMode')
    if InputDown('ctrl') and InputDown('shift') and InputDown('alt')  then
        SetBool('savegame.mod.debugMode', not GetBool('savegame.mod.debugMode'))
        db = GetBool('savegame.mod.debugMode')
    end

end


---Run a function if db is true.
---@param func function The global function to run.
---@param tb_args table Table of arguements for the function.
function dbfunc(func, tb_args) if db then func(table.unpack(tb_args)) end end


function dbw(str, value) if db then DebugWatch(str, value) end end -- DebugWatch()
function dbp(str) if db then print(str .. '(' .. sfnTime() .. ')') end end -- DebugPrint()
function dbpc(str, newLine) if db then print(str .. ternary(newLine, '\n', '')) end end -- DebugPrint() to external console only.


function dbl(p1, p2, c1, c2, c3, a) if db then DebugLine(p1, p2, c1, c2, c3, a) end end -- DebugLine()
function dbdd(pos,w,l,r,g,b,a,dt) if db then DrawDot(pos,w,l,r,g,b,a,dt) end end -- Draw a dot sprite at the specified position.
function dbray(tr, dist, c1, c2, c3, a) dbl(tr.pos, TransformToParentPoint(tr, Vec(0,0,-dist)), c1, c2, c3, a) end -- Debug a ray segement from a transform.
function dbcr(pos, r,g,b, a) if db then DebugCross(pos, r or 1, g or 1, b or 1, a or 1) end end -- DebugCross() at a specified position.



--[[DEBUG SOUNDS]]
function beep(pos, vol) PlaySound(LoadSound("warning-beep"),    pos or GetCameraTransform().pos, vol or 0.3) end
function buzz(pos, vol) PlaySound(LoadSound("light/spark0"),    pos or GetCameraTransform().pos, vol or 0.3) end
function chime(pos, vol) PlaySound(LoadSound("elevator-chime"), pos or GetCameraTransform().pos, vol or 0.3) end
function shine(pos, vol) PlaySound(LoadSound("valuable.ogg"),   pos or GetCameraTransform().pos, vol or 0.3) end
