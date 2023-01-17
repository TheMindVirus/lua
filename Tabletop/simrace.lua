local interval = 0
local timeout = 90

local car1 = getObjectFromGUID("d8872d")

local data = {}

function onFixedUpdate()
  if interval >= timeout then
    interval = 0
    WebRequest.get("http://localhost:65432", poll)
  end
  interval = interval + 1
end

function poll(request)
  if request.error ~= nil then
    print("[WARN]: " .. tostring(request.error))
  end
  if request.response_code == 200 then
    --print("[INFO]: " .. tostring(request.text))
    data = JSON.decode(request.text)
    for key in pairs(data) do
      print(tostring(key) .. ": " .. tostring(data[key]))
    end
    move(car1)
  end
end

function move(car)
  local fb = 0
  local lr = 0
  if data["angle"] ~= nil then lr = data["angle"] end
  if data["drive"] ~= nil then fb = data["drive"] end
  local front = car.getTransformRight()
  if car ~= nil then
    car.addTorque(Vector(0, lr, 0))
    car.addForce(Vector(fb, fb, fb) * front)
  end
end