local hovering = nil
local previous = nil
function onObjectHover(player, object)
  hovering = object
  local invalid = false
  if previous ~= nil then previous.highlightOff() end
  if hovering == nil then invalid = true
  else
    hovering.highlightOn(Color.red)
    local data = object.getData()
    if data ~= nil then
      local nickname = data["Nickname"]
      if nickname ~= nil and nickname == "Origin" then
        local transform = data["Transform"]
        if transform ~= nil then
          local x = math.floor(transform["posX"] + 34)
          local y = math.floor(transform["posZ"] + 18)
          onMouse(x, y, nil)
        else invalid = true end
      else invalid = true end
    else invalid = true end
  end
  if invalid == true then onMouse(-1, -1, -1) end
  previous = hovering
end

function onObjectPickUp(player, object)
  onMouse(nil, nil, 1)
end
function onObjectDrop(player, object)
  onMouse(nil, nil, 0)
end

local mouse_x = 0
local mouse_y = 0
local mouse_z = 0
function onMouse(x, y, z)
  if x == -1 and y == -1 and z == -1 then
    print("Mouse Out")
    return
  end
  if x ~= nil then mouse_x = tonumber(x) end
  if y ~= nil then mouse_y = tonumber(y) end
  if z ~= nil then mouse_z = tonumber(z) end
  print(tostring(mouse_x) .. ", " .. tostring(mouse_y)
                          .. ", " .. tostring(mouse_z))
end