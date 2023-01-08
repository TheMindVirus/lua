local cable = null
local droideka1 = null
local droideka2 = null

function onLoad()
  print("Something")
  cable = getObjectFromGUID("db15de")
  droideka1 = getObjectFromGUID("c53af5")
  droideka2 = getObjectFromGUID("cd4264")
  print(cable)
  print(droideka1)
  print(droideka2)
  updateCables()
end

function onFixedUpdate()
  updateCables()
end

function updateCables()
  cable.setPosition(Vector(0.0, 1.0, 0.0))
  cable.locked = true
  wire = cable.getMaterialsInChildren()[1]
  wire.set("_Position1", droideka1.getPosition())
  wire.set("_Position2", droideka2.getPosition())
end