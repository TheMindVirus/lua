-- For use with CC:Tweaked 1.12.2 with Plethora
-- Must be run using an enabled Command Computer

-- Diamond Pickaxe Mines 1 Extra Block Downwards
-- Wooden Axe Mines A 3x3x1 Grid Around The Block
-- Anything Else Causes The Block To Be Replaced 

_G["scanner"] = peripheral.wrap("top")
_G["player"] = peripheral.wrap("back")

local previousWorld = scanner.scan()

function log(block, previous)
  local label = tostring(previous.name) .. " -> "
  label = label .. tostring(block.name) .. " ("
  label = label .. tostring(block.x) .. ", "
  label = label .. tostring(block.y) .. ", "
  label = label .. tostring(block.z) .. ")"
  print(label)
end _G["log"] = log

function mine(x, y, z, block)
  if block == nil then block = "minecraft:air" end
  -- TODO: Check if block is within bounds of 3D Game Window!
  -- TODO: Also check if block is not of mineral type!
  -- TODO: Randomly Generate Mineral Sprites and keep track of score!
  local command = "/setblock ~"
  command = command .. tostring(x) .. " ~"
  command = command .. tostring(y + 1) .. " ~"
  command = command .. tostring(z) .. " "
  command = command .. tostring(block)
  commands.exec(command)
end _G["mine"] = mine

function detect()
  world = scanner.scan()
  for i,v in pairs(world) do
    if world[i].name ~= previousWorld[i].name then
      log(world[i], previousWorld[i])
      local tool = player.getEquipment().getItem(1).getMetadata()
      if tool.name == "minecraft:diamond_pickaxe" then
        mine(world[i].x, world[i].y, world[i].z)
        mine(world[i].x, world[i].y - 1, world[i].z)
      elseif tool.name == "minecraft:wooden_axe" then
        mine(world[i].x - 1, world[i].y, world[i].z - 1)
        mine(world[i].x    , world[i].y, world[i].z - 1)
        mine(world[i].x + 1, world[i].y, world[i].z - 1)
        mine(world[i].x - 1, world[i].y, world[i].z    )
        mine(world[i].x    , world[i].y, world[i].z    )
        mine(world[i].x + 1, world[i].y, world[i].z    )
        mine(world[i].x - 1, world[i].y, world[i].z + 1)
        mine(world[i].x    , world[i].y, world[i].z + 1)
        mine(world[i].x + 1, world[i].y, world[i].z + 1)
      else
        mine(world[i].x, world[i].y, world[i].z, previousWorld[i].name)
      end
      world = scanner.scan() -- BUG: Old state causes Race Condition!
    end
  end
  previousWorld = world
end _G["detect"] = detect

while true do detect() end
