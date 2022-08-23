 
---No Description
--- 
--- ---
--- Example
---```lua
---radius = GetFloat("radius", 5.2)
---```
---@param name string Parameter name
---@param defaultValue number Default value
function GetFloat(name, defaultValue) end

---No Description
--- 
--- ---
--- Example
---```lua
---steps = GetInt("steps", 5)
---```
---@param name string Parameter name
---@param defaultValue number Default value
function GetInt(name, defaultValue) end

---No Description
--- 
--- ---
--- Example
---```lua
---file = GetString("file", "MOD/test.vox")
---```
---@param name string Parameter name
---@param defaultValue string Default value
function GetString(name, defaultValue) end

---No Description
--- 
--- ---
--- Example
---```lua
---brick = CreateMaterial("masonry", 0.6, 0.5, 0.3, 0, 0.1, 0, 0)
---```
---@param type string Material type
---@param r number Red color
---@param g number Green color
---@param b number Blue color
---@param a number Alpha
---@param reflect number reflectivity
---@param shiny number Shininess
---@param metal number Metallic
---@param emissive number Emissive
---@return number material Material handle
function CreateMaterial(type, r, g, b, a, reflect, shiny, metal, emissive) end

---Create a brush that can be used as material. An objec tin the vox file 
---can be specified using colon (:) delimiter.
---If a brush uses local coordinates, the brush offset will be relative the 
---current drawn Box or Sphere. Global coordinates will be relative the current
---Vox origo.
--- 
--- ---
--- Example
---```lua
---brickWall = CreateBrush("MOD/brickwall.vox")
---SetMaterial(brickWall)
---Box(0, 0, 0, 10, 10, 10)
---
---swedishFlag = CreateBrush("MOD/flags.vox:sweden")
---SetMaterial(swedishFlag)
---Box(0, 0, 0, 20, 15, 1)
---```
---@param path string Vox file path and optional object
---@param local boolean Use local coordinates for all operations. Default false.
function CreateBrush(path, local) end

---Apply a flip transformation on the brush
--- 
--- ---
--- Example
---```lua
---FlipBrush(brush, "x")
---Material(brush)
---Box(0, 0, 0, 20, 15, 5)
---```
---@param brush number Brush handle
---@param axes string Any combination of x, y and z
function FlipBrush(brush, axes) end

---Apply a rotation transformation on the brush
--- 
--- ---
--- Example
---```lua
-----Draw box with brush rotated 90 degrees around y axis
---RotateBrush(brush, "y", 90)
---Material(brush)
---Box(0, 0, 0, 10, 10, 10)
---```
---@param brush number Brush handle
---@param axis string "x", "y" or "z"
---@param angle number Rotation angle in degrees
function RotateBrush(brush, axis, angle) end

---Apply a translation on the brush
--- 
--- ---
--- Example
---```lua
---TranslateBrush(brush, 5, 0, 0)
---Material(brush)
---Box(0, 0, 0, 10, 10, 10)
---```
---@param brush number Brush handle
---@param x number Offset along x axis
---@param y number Offset along y axis
---@param z number Offset along z axis
function TranslateBrush(brush, x, y, z) end

---Return brush size in voxels
--- 
--- ---
--- Example
---```lua
---local xs, ys, zs = GetBrushSize(brush)
---```
---@param brush number Brush handle
---@return number x Size along x axis
---@return number y Size along y axis
---@return number z Size along z axis
function GetBrushSize(brush) end

---Set current material or brush. Pass in zero to remove content.
--- 
--- ---
--- Example
---```lua
---brick = CreateMaterial("masonry", 0.6, 0.5, 0.3, 0, 0.1, 0, 0)
---SetMaterial(brick)
---Box(0, 0, 0, 10, 10, 10)
---
-----Make box hollow
---SetMaterial(0)
---Box(2, 2, 2, 8, 8, 8)
---```
---@param material number Material or brush handle
function Material(material) end

---Load PNG image from file
--- 
--- ---
--- Example
---```lua
---LoadImage("MOD/image.png")
---```
---@param path string Path to PNG image
function LoadImage(path) end

---Return image size
--- 
--- ---
--- Example
---```lua
---LoadImage("MOD/image.png")
---local w, h = GetImageSize()
---```
---@return number width Image width
---@return number height Image height
function GetImageSize() end

---Return color value for image pixel
--- 
--- ---
--- Example
---```lua
---LoadImage("MOD/image.png")
---local r,g,b,a = GetImagePixel(50, 50)
---```
---@param x number X coordinate
---@param y number Y coordinate
---@return number r Red
---@return number g Greeen
---@return number b Blue
---@return number a Alpha
function GetImagePixel(x, y) end

---Create new shape
--- 
--- ---
--- Example
---```lua
-----Create vox shape
---Vox(0, 0, 0)
---
-----We can now fill it with content
---Material(mat)
---Box(0, 0, 0, 10, 10, 10)
---Sphere(10, 10, 10, 5)
---```
---@param x number X position
---@param y number Y position
---@param z number Z position
---@param rx number Rotation around X in degrees
---@param ry number Rotation around Y in degrees
---@param rz number Rotation around Z in degrees
function Vox(x, y, z, rx, ry, rz) end

---Draw solid box into the current vox shape using the current material
--- 
--- ---
--- Example
---```lua
---Material(mat)
---Box(0, 0, 0, 10, 10, 10)
---```
---@param x0 number X start
---@param y0 number Y start
---@param z0 number Z start
---@param x1 number X end
---@param y1 number Y end
---@param z1 number Z end
function Box(x0, y0, z0, x1, y1, z1) end

---Draw solid sphere into current vox shape using the current material
--- 
--- ---
--- Example
---```lua
---Material(mat)
---Sphere(0, 0, 0, 15)
---```
---@param x number X center
---@param y number Y center
---@param z number Z center
---@param r number Radius
function Sphere(x, y, z, r) end

---Special function to create heightmap based on loaded image into current vox shape
---Red channel = height
---Green channel = grass amount
---Blue channel = special
--- 
--- ---
--- Example
---```lua
---LoadImage("MOD/heightmap.png")
---Heightmap(0, 0, 100, 100, 255)
---```
---@param x0 number X start
---@param y0 number Y start
---@param x1 number X end
---@param y1 number Y end
---@param height number Height scale
function Heightmap(x0, y0, x1, y1, height) end