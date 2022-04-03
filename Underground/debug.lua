-- For use with CC:Tweaked 1.12.2 with Plethora
-- Must be run using an enabled Command Computer

-- Diamond Pickaxe Mines 1 Extra Block Downwards
-- Wooden Axe Mines A 3x3x1 Grid Around The Block
-- Anything Else Causes The Block To Be Replaced 

_G["scanner"] = peripheral.wrap("top")
_G["player"] = peripheral.wrap("back")
_G["monitor"] = peripheral.wrap("monitor_0")
_G["resetbtn"] = peripheral.wrap("redstone_integrator_0")
_G["modem"] = peripheral.wrap("right")
_G["wifi"] = peripheral.wrap("left")

local previousWorld = scanner.scan()
local playerScore = 0

function score()
  monitor.clear()
  monitor.setBackgroundColor(colors.black)
  monitor.setTextColor(colors.white)
  monitor.setTextScale(5)
  monitor.setCursorPos(1, 1)
  monitor.write(tostring(playerScore))
end _G["score"] = score

function log(block, previous)
  local label = tostring(previous.name) .. " -> "
  label = label .. tostring(block.name) .. " ("
  label = label .. tostring(block.x) .. ", "
  label = label .. tostring(block.y) .. ", "
  label = label .. tostring(block.z) .. ")"
  print(label)
end _G["log"] = log

function test(block)
  check = true
  if block.name ~= "minecraft:coarse_dirt" then
    check = false
  end
  if block.x > 6 or block.x < -6 then
    check = false
  end
  if block.z > 4 or block.z < -5 then
    check = false
  end
  if block.y > 4 or block.y < 1 then
    check = false
  end
  return check
end _G["test"] = test

function mine(x, y, z, block, previous)
  if test(previous) == false then return end
  if block == nil then block = "minecraft:air" end
  local command = "/setblock ~"
  command = command .. tostring(x) .. " ~"
  command = command .. tostring(y + 1) .. " ~"
  command = command .. tostring(z) .. " "
  command = command .. tostring(block)
  commands.exec(command)
end _G["mine"] = mine

function setup()
  for i in 0, 10, 10 do
    print()
  end  
end _G["setup"] = setup

function loop()
  world = scanner.scan()
  for i,v in pairs(world) do
    if world[i].name ~= previousWorld[i].name then
      log(world[i], previousWorld[i])
      local tool = player.getEquipment().getItem(1).getMetadata()
      if tool.name == "minecraft:diamond_pickaxe" then
        mine(world[i].x, world[i].y, world[i].z, previousWorld[i])
        mine(world[i].x, world[i].y - 1, world[i].z, previousWorld[i])
      elseif tool.name == "minecraft:wooden_axe" then
        mine(world[i].x - 1, world[i].y, world[i].z - 1, previousWorld[i])
        mine(world[i].x    , world[i].y, world[i].z - 1, previousWorld[i])
        mine(world[i].x + 1, world[i].y, world[i].z - 1, previousWorld[i])
        mine(world[i].x - 1, world[i].y, world[i].z    , previousWorld[i])
        mine(world[i].x    , world[i].y, world[i].z    , previousWorld[i])
        mine(world[i].x + 1, world[i].y, world[i].z    , previousWorld[i])
        mine(world[i].x - 1, world[i].y, world[i].z + 1, previousWorld[i])
        mine(world[i].x    , world[i].y, world[i].z + 1, previousWorld[i])
        mine(world[i].x + 1, world[i].y, world[i].z + 1, previousWorld[i])
      else
        mine(world[i].x, world[i].y, world[i].z, previousWorld[i])
      end
      world = scanner.scan() -- BUG: Old state causes Race Condition!
    end
  end
  previousWorld = world
  -- TODO: Get Redstone Button State
  playerScore = resetbtn.getAnalogInput("top")
  score()
end _G["loop"] = loop

while true do loop() end
