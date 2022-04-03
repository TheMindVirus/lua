i = 1
w = 1
h = 1
c = 0

function blocks(b) 
  if b == nil then return "minecraft:air"
  elseif b == 0  then return "minecraft:white_wool"
  elseif b == 1  then return "minecraft:orange_wool"
  elseif b == 2  then return "minecraft:magenta_wool"
  elseif b == 3  then return "minecraft:light_blue_wool"
  elseif b == 4  then return "minecraft:yellow_wool"
  elseif b == 5  then return "minecraft:lime_wool"
  elseif b == 6  then return "minecraft:pink_wool"
  elseif b == 7  then return "minecraft:gray_wool"
  elseif b == 8  then return "minecraft:light_gray_wool"
  elseif b == 9  then return "minecraft:cyan_wool"
  elseif b == 10 then return "minecraft:purple_wool"
  elseif b == 11 then return "minecraft:blue_wool"
  elseif b == 12 then return "minecraft:brown_wool"
  elseif b == 13 then return "minecraft:green_wool"
  elseif b == 14 then return "minecraft:red_wool"
  elseif b == 15 then return "minecraft:black_wool"
  else return "minecraft:air"
  end
end
block = 0

file = fs.open("/disk/img.txt", "rb")
print(file)
data = file.readAll()
file.close()

prev = 0
skip = false
while true do
  os.queueEvent("yield")
  os.pullEvent("yield")
  skip = false
  pos = string.find(data, "\n", prev)
  if pos == (prev + 1) then
    w = 1
    h = h + 1
    skip = true
  end
  if not skip then
    c = tonumber(string.sub(data, prev, pos))

    istr = tostring(i)
    wstr = tostring(w)
    hstr = tostring(h)
    cstr = tostring(c)
    print(istr.." : "..wstr.." x "..hstr.." = "..cstr)
  
    commands.setblock(w, 0, h, blocks(c))
  
    w = w + 1
  end
  if pos == nil then break
  else prev = pos + 1 end
  i = i + 1
end

print("Done!")
