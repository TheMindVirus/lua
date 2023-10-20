local interval = 0
local timeout = 90
local payload = ""
local headers = { self.guid }

local SERVER_URL = "http://localhost:65432/HANrouter"

function onFixedUpdate()
  if interval >= timeout then
    interval = 0
    WebRequest.custom(SERVER_URL, "POST", true, animations(), headers, poll)
  end
  interval = interval + 1
end

function animations()
  local animation_list = {}
  local object_list = getObjects()
  if object_list ~= nil then
    for key in pairs(object_list) do
      local item = object_list[key]
      if item ~= nil and item.AssetBundle ~= nil then
        local looping = item.AssetBundle.getLoopingEffects()
        local trigger = item.AssetBundle.getTriggerEffects()
        local effects = {}
        effects["name"] = item.getName()
        if looping ~= nil then effects["looping"] = looping else effects["looping"] = {} end
        if trigger ~= nil then effects["trigger"] = trigger else effects["trigger"] = {} end
        animation_list[item.guid] = effects
      end
    end
  end
  return JSON.encode(animation_list)
end

function poll(request)
  if request.error ~= nil then
    print("[WARN]: " .. tostring(request.error))
  end
  if request.response_code == 200 then
    print("[INFO]: " .. tostring(request.text))
    command_list = JSON.decode(request.text)
    for key in pairs(command_list) do
      local thing = getObjectFromGUID(key)
      local command = command_list[key]
      play(thing, command)
    end
  end
end

function play(thing, command)
  local looping = true
  if string.sub(command, 0, 1) == "-" then looping = false end
  local id = math.abs(tonumber(command))
  if thing ~= nil and thing.AssetBundle ~= nil then
    if looping == true then
      thing.AssetBundle.playLoopingEffect(id)
    else
      thing.AssetBundle.playTriggerEffect(id)
    end
  end
end