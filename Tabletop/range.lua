function onDebug()
  local unit1 = getObjectFromGUID("c53af5")
  local unit2 = getObjectFromGUID("cd4264")
  local range = unit2.getPosition():distance(unit1.getPosition())
  range = range / 6.283185307179586
  print("[INFO]: Range: " .. tostring(range))
end