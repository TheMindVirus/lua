function onDebug()
  this = getObjectFromGUID("e0cb56")
  data = this.getMaterialsInChildren()
  raw = nil
  for i,v in ipairs(data) do 
    if i == 1 then raw = v end
  end
  if raw ~= nil then
    local keyword = "_Intensity"
    local value = 2.0
    raw.set(keyword, value)
    local n = raw.get(keyword)
    print("[INFO]: " .. keyword .. ": " .. tostring(n))
  end
end