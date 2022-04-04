function mid(A, B, P)
  return A + ((B - A) * P) 
end

function build(x, z, s, c)
  s = s + 1
  miny = 2
  maxy = 202
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
  block = "minecraft:concrete"
  blockc = 7
  for i = 0,s,1 do
    aby = mid(ay, by, (i/s))
    bcy = mid(by, cy, (i/s))
    cdy = mid(cy, dy, (i/s))
    day = mid(dy, ay, (i/s))
    commands.fill(ax, miny, az+i, ax, aby, az+i, block, blockc)
    commands.fill(bx+i, miny, bz, bx+i, bcy, bz, block, blockc)
    commands.fill(cx, miny, cz-i, cx, cdy, cz-i, block, blockc)
    commands.fill(dx-i, miny, dz, dx-i, day, dz, block, blockc)
  end
  h = math.max(ay, by, cy, dy)
  agentx = math.random(0, s)
  agenti = math.random(-1,1)
  light = "coloredlights:colored_lamp_inverted"
  for i = miny,h,1 do
    agentx = agentx + agenti
    if (agentx > s) then agentx = s end
    if (agentx < 0) then agentx = 0 end
    if (math.random(1, 1000) >= 900) then
      agenti = math.random(-1,1)
    end
    commands.fill(ax, i, az+agentx, ax, u, az+agentx, light, c, "replace", block, blockc)
    commands.fill(bx+agentx, i, bz, bx+agentx, i, bz, light, c, "replace", block, blockc)
    commands.fill(cx, i, cz-agentx, cx, i, cz-agentx, light, c, "replace", block, blockc)
    commands.fill(dx-agentx, i, dz, dx-agentx, i, dz, light, c, "replace", block, blockc)
  end
  print("Built "..x..", "..z..", "..s..", "..c)
end _G["build"] = build 

--build(0, 300, 10, 1)

function city()
  for x = 35,1700,35 do
    for z = 0,1200,35 do
      build(x, z, 10, 14)
    end
  end
end _G["city"] = city 

city()
