function onLoad()
  this = getObjectFromGUID("fc1303")
  print(this)
  shma = this.getMaterialsInChildren()
  shma1 = nil
  for i,v in ipairs(shma) do 
    print(v)
    if i == 1 then shma1 = v end
  end
  print(shma1)
  
  --rend = this.getComponent("MeshRenderer")
  --print(rend)
  --gobj = rend.game_object
  --print(gobj)
  --shma2 = gobj.getMaterialsInChildren()
  --for i,v in ipairs(shma2) do print(v) end

  if shma1 ~= nil then
    for i in pairs(shma1.getVars()) do print(i) end
    --shma1._Thickness = 2.0
    --shma1["_Thickness"] = 2.0
    shma1.set("_Thickness", 4.0)
  end
end