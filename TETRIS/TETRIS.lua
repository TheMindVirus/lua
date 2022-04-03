function TETRISSetup()
  clear()
  print("TETRIS")
  _G["stackPoints"] = 10
  _G["rowPoints"] = 100
  _G["score"] = 0
  _G["state"] = 0
  _G["block"] = {}
  block[1] = { 0, 0, 0, 0, 0 }
  block[2] = { 0, 0, 0, 0, 0 }
  block[3] = { 0, 0, 0, 0, 0 }
  block[4] = { 0, 0, 0, 0, 0 }
  updateScoreboard(score)
  while true do 
    os.startTimer(0.5)
    event, param = os.pullEvent()
	   if (event == "timer") then
	     controls = redstone.getBundledInput("back")
	     if (colors.test(controls, colors.red)) then moveLeft() end
	     if (colors.test(controls, colors.green)) then rotateLeft() end
	     if (colors.test(controls, colors.blue)) then rotateRight() end
	     if (colors.test(controls, colors.yellow)) then moveRight() end
      mainLoop()
      updateScoreboard(score)
    end
  end
end _G["TETRISSetup"] = TETRISSetup

function mainLoop()
  if (state == 0) then
    if (not newBlock(math.random(1, 7))) then
	     state = 3
	   else
	     state = 1
	   end
  elseif (state == 1) then
    if (not moveDown()) then
	     state = 2
	   end
  elseif (state == 2) then
    score = score + stackPoints
	   for y = height,1,-1 do 
	     rowDone = true
	     for x = 1,width,1 do
	       if (test(x, y) == clearc) then
		        rowDone = false
		        break
	      	end
	     end
	     if (rowDone) then
	       score = score + rowPoints
		      for y2 = y,1,-1 do 
		        for x2 = 1,width,1 do 
		          c = clearc 
            if (y2 > 1) then
			           c = test(x2, y2 - 1)
            end
            draw(x2, y2, red)
			         draw(x2, y2, c)
	         end
        end
      end
    end
	   state = 0
  else
    print("Game Over! You scored " .. score .. " points!")
	   score = 0
   	state = 0
    clear()
    print("TETRIS")
  end
end _G["mainLoop"] = mainLoop

function newBlock(n)
  cx = (width / 2) + 1
  cy = 1
  if (n < 1) or (n > 7) then n = 1 end
  if (n == 1) then
    block[1] = { cx, -1, cy, 0, cyan }
    block[2] = { cx,  0, cy, 0, cyan }
    block[3] = { cx,  1, cy, 0, cyan }
    block[4] = { cx,  2, cy, 0, cyan }
  elseif (n == 2) then
    block[1] = { cx, -1, cy, 1, blue }
    block[2] = { cx, -1, cy, 0, blue }
    block[3] = { cx,  0, cy, 0, blue }
    block[4] = { cx,  1, cy, 0, blue }
  elseif (n == 3) then
    block[1] = { cx,  1, cy, 1, orange }
    block[2] = { cx, -1, cy, 0, orange }
    block[3] = { cx,  0, cy, 0, orange }
    block[4] = { cx,  1, cy, 0, orange }
  elseif (n == 4) then
    block[1] = { cx, -1, cy, 1, yellow }
    block[2] = { cx,  0, cy, 1, yellow }
    block[3] = { cx, -1, cy, 0, yellow }
    block[4] = { cx,  0, cy, 0, yellow }
  elseif (n == 5) then
    block[1] = { cx,  0, cy, 1, magenta }
    block[2] = { cx, -1, cy, 0, magenta }
    block[3] = { cx,  0, cy, 0, magenta }
    block[4] = { cx,  1, cy, 0, magenta }
  elseif (n == 6) then
    block[1] = { cx,  0, cy, 1, green }
    block[2] = { cx,  1, cy, 1, green }
    block[3] = { cx, -1, cy, 0, green }
    block[4] = { cx,  0, cy, 0, green }
  elseif (n == 7) then
    block[1] = { cx, -1, cy, 1, red }
    block[2] = { cx,  0, cy, 1, red }
    block[3] = { cx,  0, cy, 0, red }
    block[4] = { cx,  1, cy, 0, red }
  end
  retval = true
  for i = 1,4,1 do  
    x = block[i][1] + block[i][2]
    y = block[i][3] + block[i][4]
    if (test(x, y) ~= clearc) then
      retval = false
      break
    end
  end
  showBlock()
  return retval 
end _G["newBlock"] = newBlock 

function showBlock()
  for i = 1,4,1 do 
    x = block[i][1] + block[i][2]
    y = block[i][3] + block[i][4]
    c = block[i][5]
    draw(x, y, c)
  end
end _G["showBlock"] = showBlock

function hideBlock()
  for i = 1,4,1 do 
    x = block[i][1] + block[i][2]
    y = block[i][3] + block[i][4]
    draw(x, y, clearc)
  end
end _G["hideBlock"] = hideBlock

function moveDown()
  hideBlock()
  retval = true
  for i = 1,4,1 do 
    x = block[i][1] + block[i][2]
    y = block[i][3] + block[i][4] + 1
    if (y > height)
    or (test(x, y) ~= clearc) then
      retval = false
      break
    end
  end
  if (retval) then
    for i = 1,4,1 do
	     block[i][3] = block[i][3] + 1
	   end
  end
  showBlock()
  return retval
end _G["moveDown"] = moveDown 

function moveLeft()
  hideBlock()
  retval = true
  for i = 1,4,1 do 
    x = block[i][1] + block[i][2] - 1
    y = block[i][3] + block[i][4]
    if (x < 1) or (test(x, y) ~= clearc) then
      retval = false
      break
    end
  end
  if (retval) then
    for i = 1,4,1 do
      block[i][1] = block[i][1] - 1
	   end
  end
  showBlock()
  return retval
end _G["moveLeft"] = moveLeft

function moveRight()
  hideBlock()
  retval = true
  for i = 1,4,1 do 
    x = block[i][1] + block[i][2] + 1
    y = block[i][3] + block[i][4]
    if (x > width)
    or (test(x, y) ~= clearc) then
      retval = false
      break
    end
  end
  if (retval) then
    for i = 1,4,1 do
	     block[i][1] = block[i][1] + 1
   	end
  end
  showBlock()
  return retval
end _G["moveRight"] = moveRight

function rotateLeft()
  hideBlock()
  retval = true
  for i = 1,4,1 do 
    rx = block[i][1] + (block[i][4] * -1)
	   ry = block[i][2] + block[i][3]
	   if (rx < 1) or (rx > width)
    or (test(rx, ry) ~= clearc) then
	     retval = false
	     break
   	end
  end
  if (retval) then
    for i = 1,4,1 do 
	     tmp = block[i][2]
	     block[i][2] = block[i][4] * -1
	     block[i][4] = tmp
	   end
  end
  showBlock()
  return retval
end _G["rotateLeft"] = rotateLeft

function rotateRight()
  hideBlock()
  retval = true
  for i = 1,4,1 do 
    rx = block[i][1] + (block[i][4] * -1)
	   ry = block[i][2] + block[i][3]
	   if (rx < 1) or (rx > width)
    or (test(rx, ry) ~= clearc) then
	     retval = false
	     break
   	end
  end
  if (retval) then
    for i = 1,4,1 do
	     tmp = block[i][4]
	     block[i][4] = block[i][2] * -1
	     block[i][2] = tmp
	   end
  end
  showBlock()
  return retval
end _G["rotateRight"] = rotateRight

TETRISSetup()
