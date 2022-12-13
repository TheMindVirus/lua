--[[ Lua code. See documentation: https://api.tabletopsimulator.com/ --]]

--[[ The onLoad event is called after the game save finishes loading. --]]
function onLoad()
    --[[ print('onLoad!') --]]
end

--[[ The onUpdate event is called once per frame. --]]
function onUpdate()
    --[[ print('onUpdate loop!') --]]
end

function onObjectCollisionEnter(obj, info)
  obj2 = info.collision_object
  print(tostring(obj) .. " collided with " .. tostring(obj2))
  if (tostring(obj2):sub(1, 5) == "Table") then
    self = obj2
    self.interactable = true
    self.locked = false 
    self.scale(0)
    self.destruct()
  end
end

function onDebug()
  print("__Objects__")
  for i,v in ipairs(getAllObjects()) do
    print(tostring(i) .. ": " .. tostring(v) .. "\nGUID: " .. tostring(v.guid))
    v.registerCollisions(true)
  end
end

function onDebug2()
  obj = getObjectFromGUID("06099a")
  print(obj)
  --destroyObject(obj)
end