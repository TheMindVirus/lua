local tick = 0
local seconds = 0
function onFixedUpdate()
  tick = tick + 1
  if tick > 90 then
    tick = 0
    seconds = seconds + 1
    local decals =
    {
        {
            name     = "API Icon",
            url      = "https://api.tabletopsimulator.com/img/TSIcon.png",
            position = {0, 5, seconds},
            rotation = {90, 0, 0},
            scale    = {1, 1, 1},
        }
    }
    Global.setDecals(decals)

    --print("[TICK]")
  end
end