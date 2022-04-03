-- For use with CC:Tweaked 1.12.2 with Plethora
-- Must be run using an enabled Command Computer

_G["scanner"] = peripheral.wrap("top")
_G["player"] = peripheral.wrap("back")

local previous = scanner.scan()

function detect()
  world = scanner.scan()
  for i,v in pairs(world) do
    if world[i].name ~= previous[i].name then
      local label = previous[i].name .. " -> "
      label = label .. world[i].name .. " ("
      label = label .. tostring(world[i].x) .. ", "
      label = label .. tostring(world[i].y) .. ", "
      label = label .. tostring(world[i].z) .. ")"
      print(label)
      local command = "/setblock ~"
      command = command .. tostring(world[i].x) .. " ~"
      command = command .. tostring(world[i].y + 1) .. " ~"
      command = command .. tostring(world[i].z) .. " "
      command = command .. previous[i].name
      commands.exec(command)
      world = scanner.scan() -- Bug: Race condition!
    end
  end
  previous = world
end _G["detect"] = detect

while true do detect() end
