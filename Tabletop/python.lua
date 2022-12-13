--[[ Lua code. See documentation: https://api.tabletopsimulator.com/ --]]

--[[ The onLoad event is called after the game save finishes loading. --]]
function onLoad()
    print('onLoad!') --this sends a messageID 2 packet to python
end

--[[ The onUpdate event is called once per frame. --]]
function onUpdate()
    --print('onUpdate loop!')
end

function onExternalMessage(data)
  print(data)
end