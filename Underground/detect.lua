-- For use with CC:Tweaked 1.12.2 with Plethora

_G["scanner"] = peripheral.wrap("top") -- Equip with 17x17x17 Block Scanner Module
_G["player"] = peripheral.wrap("back") -- Equip with Player-Bound Introspection Module

local previous = scanner.scan()

function detect()
  world = scanner.scan()
  for i,v in pairs(world) do
    --for a,b in pairs(v) do
    --  print(world[i].name)
    --end
    if world[i].name ~= previous[i].name then
      local label = ""
      label = label .. previous[i].name .. " -> "
      label = label .. world[i].name .. " ("
      label = label .. tostring(world[i].x) .. ", "
      label = label .. tostring(world[i].y) .. ", "
      label = label .. tostring(world[i].z) .. ")"
      print(label)
    end
  end
  previous = world
end _G["detect"] = detect

while true do detect() end
