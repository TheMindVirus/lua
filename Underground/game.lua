-- For use with CC:Tweaked 1.12.2 with Plethora
-- Must be run using an enabled Command Computer

-- Diamond Pickaxe Mines 1 Extra Block Downwards
-- Wooden Axe Mines A 3x1x3 Grid Around The Block
-- Anything Else Causes The Block To Be Replaced 

_G["scanner"] = peripheral.wrap("top")
_G["player"] = peripheral.wrap("back")
_G["monitor"] = peripheral.wrap("monitor_0")
_G["resetbtn"] = peripheral.wrap("redstone_integrator_0")
_G["modem"] = peripheral.wrap("right")
_G["wifi"] = peripheral.wrap("left")

local previousWorld = scanner.scan()
local playerScore = 0
local earthQuake = 0
local lock = false

local minx = -6
local maxx = 6
local miny = 2
local maxy = 5
local minz = -5
local maxz = 4

local defaultBlock = "minecraft:clay"
local airBlock = "minecraft:air"
local plankBlock = "minecraft:planks"
local stairsBlock = "minecraft:oak_stairs"
local chance = 0.25
local minerals =
{
  "minecraft:gold_block",
  "minecraft:diamond_block",
  "minecraft:emerald_block",
  "pixelmon:ruby_block",
  "pixelmon:sapphire_block",
}

function score(n, q)
  if n == nil then n = 0 end
  if q == nil then q = 0 end
  if earthQuake < (maxx - minx) then
    playerScore = playerScore + n
    earthQuake = earthQuake + q
  end
  if n < 0 then playerScore = 0 end
  if q < 0 then earthQuake = 0 end
  
  monitor.clear()
  monitor.setBackgroundColor(colors.black)
  monitor.setTextColor(colors.white)
  monitor.setTextScale(3)
  monitor.setCursorPos(1, 1)
  monitor.write(tostring(playerScore))
  
  for x = minx, maxx, 1 do
    mine(x, maxy, maxz + 1, plankBlock, true)
    mine(x, maxy, maxz + 2, plankBlock, true)
  end
  for x = 1, earthQuake + 1, 1 do
    local oddeven = x % 2
    local block = stairsBlock .. " 3"
    local newz = maxz + 1
    if oddeven < 1 then
       block = stairsBlock .. " 2"
       newz = newz + 1 
    end
    mine(minx + (x - 1), maxy, newz, block, true)
  end  
end _G["score"] = score

function log(block, previous)
  local label = tostring(previous.name) .. " -> "
  label = label .. tostring(block.name) .. " ("
  label = label .. tostring(block.x) .. ", "
  label = label .. tostring(block.y) .. ", "
  label = label .. tostring(block.z) .. ")"
  print(label)
end _G["log"] = log

function test(block, compare)
  if compare == nil then compare = defaultBlock end
  for i,v in pairs(minerals) do
    if block.name == v then score(1, 0) end
  end
  
  if block.name ~= compare
  or block.x < minx
  or block.x > maxx
  or block.y < miny
  or block.y > maxy
  or block.z < minz
  or block.z > maxz
  then return false end
  return true
end _G["test"] = test

function mine(x, y, z, block, condition)
  if condition == nil then condition = true end
  if condition == false then return end
  if block == nil then block = airBlock end
  local command = "/setblock ~"
  command = command .. tostring(x) .. " ~"
  command = command .. tostring(y + 1) .. " ~"
  command = command .. tostring(z) .. " "
  command = command .. tostring(block)
  commands.exec(command)
end _G["mine"] = mine

function setup()
  score(-1, -1)
  monitor.clear()
  monitor.setCursorPos(1, 1)
  monitor.write("__")  
  for x = minx, maxx, 1 do
    for y = miny, maxy, 1 do
      for z = minz, maxz, 1 do
        local block = defaultBlock
        local luck = math.random()
        if y ~= maxy and luck < chance then
          local id = math.floor(math.random() * table.getn(minerals)) + 1
          block = minerals[id]
        end
        mine(x, y, z, block, true)
      end
    end
  end
  score()
  lock = false
end _G["setup"] = setup

function loop()
  os.queueEvent("yield", 1)
  os.pullEvent()
  if lock == false
  and resetbtn.getAnalogInput("top") > 0 then
    lock = true
    setup()
  end
  if lock == true then return end
    
  world = scanner.scan()
  for i,v in pairs(world) do
    if world[i].name ~= previousWorld[i].name then
      log(world[i], previousWorld[i])
      local tool = player.getEquipment().getItem(1).getMetadata()
      if tool.name == "minecraft:diamond_pickaxe" then
        mine(world[i].x, world[i].y, world[i].z, nil, test(previousWorld[i]))
        mine(world[i].x, world[i].y - 1, world[i].z, nil, test(previousWorld[i]))
        score(0, 1)
      elseif tool.name == "minecraft:wooden_axe" then
        mine(world[i].x - 1, world[i].y, world[i].z - 1, nil, test(previousWorld[i]))
        mine(world[i].x    , world[i].y, world[i].z - 1, nil, test(previousWorld[i]))
        mine(world[i].x + 1, world[i].y, world[i].z - 1, nil, test(previousWorld[i]))
        mine(world[i].x - 1, world[i].y, world[i].z    , nil, test(previousWorld[i]))
        mine(world[i].x    , world[i].y, world[i].z    , nil, test(previousWorld[i]))
        mine(world[i].x + 1, world[i].y, world[i].z    , nil, test(previousWorld[i]))
        mine(world[i].x - 1, world[i].y, world[i].z + 1, nil, test(previousWorld[i]))
        mine(world[i].x    , world[i].y, world[i].z + 1, nil, test(previousWorld[i]))
        mine(world[i].x + 1, world[i].y, world[i].z + 1, nil, test(previousWorld[i]))
        score(0, 1)
      else
        mine(world[i].x, world[i].y, world[i].z, previousWorld[i].name)
      end
      world = scanner.scan()
      previousWorld = world
    end
  end
  previousWorld = world
end _G["loop"] = loop

while true do loop() end
