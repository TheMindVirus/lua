function displaySetup()
  commands.gamerule("commandBlockOutput", false)
  LUT()
  _G["screen"] = peripheral.wrap("left")
  _G["width"] = 18
  _G["height"] = 19
  _G["itemid"] = 1246
  _G["clearc"] = black
  _G["shades"] = "0123456789abcdef"
end _G["displaySetup"] = displaySetup 

function LUT()
  _G["white"] = 0
  _G["orange"] = 1
  _G["magenta"] = 2
  _G["lightblue"] = 3
  _G["yellow"] = 4
  _G["lime"] = 5
  _G["pink"] = 6
  _G["grey"] = 7
  _G["lightgrey"] = 8
  _G["cyan"] = 9
  _G["purple"] = 10
  _G["blue"] = 11
  _G["brown"] = 12
  _G["green"] = 13
  _G["red"] = 14
  _G["black"] = 15
end _G["LUT"] = LUT 

function shade(c)
  c = c + 1
  return string.sub(shades, c, c)
end _G["shade"] = shade 

function clear()
  print("clearing...")
  for x = 1,width,1 do 
    for y = 1,height,1 do 
      draw(x, y, red)
      draw(x, y, clearc)
    end
  end
end _G["clear"] = clear 

function draw(x, y, c)
  if (x < 1) then x = 1 end
  if (y < 1) then y = 1 end
  if (x > width) then x = width end
  if (y > height) then y = height end
  if (c < 0) or (c > 15) then c = clearc end
  screen.setCursorPos(x, y)
  screen.blit(" ", " ", shade(c))
  cx, cy, cz = coords(x, y)
  commands.setblock(cx, cy, cz, itemid, c)
end _G["draw"] = draw 

function test(x, y)
  cx, cy, cz = coords(x, y)
  return commands.getBlockInfo(cx, cy, cz).metadata
end _G["test"] = test 

function coords(x, y)
  return 1744, 31 - y, 2286 - x 
end _G["coords"] = coords 

function tprint(tabl)
  print(textutils.serialise(tabl))
end _G["tprint"] = tprint 

function pause()
  io.write("Press Any Key To Continue...")
  io.read()  
end _G["pause"] = pause 

function updateScoreboard(value)
  scoreboard = peripheral.wrap("top")
  scoreboard.clear()
  scoreboard.setTextScale(2)
  scoreboard.setCursorPos(1, 1)
  scoreboard.write(tostring(tonumber(value)))
end _G["updateScoreboard"] = updateScoreboard 
