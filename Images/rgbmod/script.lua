i = 1
w = 1
h = 1
c = 0

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
    c = tonumber(string.sub(data, prev, pos)) - 16777216

    istr = tostring(i)
    wstr = tostring(w)
    hstr = tostring(h)
    cstr = tostring(c)
    print(istr.." : "..wstr.." x "..hstr.." = "..cstr)
  
    commands.setblock(w, 0, h, "rgbblocks:wool")
    commands.data("modify", "block", w, 0, h, "color", "set", "value", c)
  
    w = w + 1
  end
  if pos == nil then break
  else prev = pos + 1 end
  i = i + 1
end

print("Done!")
