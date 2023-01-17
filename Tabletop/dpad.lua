local fd = { 0 }
local bk = { 0 }
local lt = { 0 }
local rt = { 0 }

function forward(player)
  local p = player.steam_id
  if fd[p] == 1 then fd[p] = 0
  else fd[p] = 1 end
  bk[p] = 0
  print(tostring(p) .. " Forward:" .. tostring(fd[p]))
end

function backward(player)
  local p = player.steam_id
  if bk[p] == 1 then bk[p] = 0
  else bk[p] = 1 end
  fd[p] = 0
  print(tostring(p) .. " Backward:" .. tostring(bk[p]))
end

function left(player)
  local p = player.steam_id
  if lt[p] == 1 then lt[p] = 0
  else lt[p] = 1 end
  rt[p] = 0
  print(tostring(p) .. " Left:" .. tostring(lt[p]))
end

function right(player)
  local p = player.steam_id
  if rt[p] == 1 then rt[p] = 0
  else rt[p] = 1 end
  lt[p] = 0
  print(tostring(p) .. " Right:" .. tostring(rt[p]))
end