local interval = 0
local timeout = 90

function onLoad()
  self.addTag("ping")
end

function onFixedUpdate()
  if interval >= timeout then
    interval = 0
    for i,v in pairs(getAllObjects()) do
      if v ~= nil and v.hasTag("ping") then
        v.call("ping", { src = self.guid, dst = v.guid })
      end
    end
  end
  interval = interval + 1
end

function ping(data)
  print("[_MSG]: " .. tostring(data["src"]) .. " -> " .. tostring(data["dst"]))
end

