function mid(A, B, P)
  return A + ((B - A) * P) 
end

function build(x, z, s, c)
  s = s + 1
  miny = 1
  maxy = 255
  ax = x
  bx = x 
  cx = x + s
  dx = x + s
  ay = math.random(miny, maxy)
  by = math.random(miny, maxy)
  cy = math.random(miny, maxy)
  dy = math.random(miny, maxy)
  az = z
  bz = z + s
  cz = z + s
  dz = z
  block = 211
  blockc = 0
  world = require("component").debug.getWorld()
  loader = 644
  world.setBlock(ax+1, miny+1, az+1, loader, 0)
  meta = world.getTileNBT(ax+1, miny+1, az+1)
  if (meta ~= nil) then
    meta.value.radius.value = 5
    world.setTileNBT(ax+1, miny+1, az+1, meta)
  end
  for i = 0,s,1 do
    aby = mid(ay, by, (i/s))
    bcy = mid(by, cy, (i/s))
    cdy = mid(cy, dy, (i/s))
    day = mid(dy, ay, (i/s))
    world.setBlocks(ax, miny, az+i, ax, aby, az+i, block, blockc)
    world.setBlocks(bx+i, miny, bz, bx+i, bcy, bz, block, blockc)
    world.setBlocks(cx, miny, cz-i, cx, cdy, cz-i, block, blockc)
    world.setBlocks(dx-i, miny, dz, dx-i, day, dz, block, blockc)
  end
  h = math.max(ay, by, cy, dy)
  agentx = math.random(0, s)
  agenti = math.random(-1,1)
  light = 211
  for i = miny,h,1 do
    agentx = agentx + agenti
    if (agentx > s) then agentx = s end
    if (agentx < 0) then agentx = 0 end
    if (math.random(1, 1000) >= 900) then
      agenti = math.random(-1,1)
    end
    if (world.getBlockId(ax, i, az+agentx) ~= 0) then
      world.setBlock(ax, i, az+agentx, light, c)
    end
    if (world.getBlockId(bx+agentx, i, bz) ~= 0) then
      world.setBlock(bx+agentx, i, bz, light, c)
    end
    if (world.getBlockId(cx, i, cz-agentx) ~= 0) then
      world.setBlock(cx, i, cz-agentx, light, c)
    end
    if (world.getBlockId(dx-agentx, i, dz) ~= 0) then
      world.setBlock(dx-agentx, i, dz, light, c)
    end
  end
  print("Built "..x..", "..z..", "..s..", "..c)
end _G["build"] = build 

--build(0, 500, 10, 3)

function city()
  clist = { 6, 11, 13 }
  ci = math.random(1, #clist)
  for x = 35,1000,35 do
    for z = 0,1000,35 do
      if (math.random(1, 1000) >= 600) then
        ci = math.random(1, #clist)
      end
      build(x, z, math.random(5, 15), clist[ci])
    end
  end
end _G["city"] = city 

city()