function onLoad()
  obj = getObjectFromGUID("687656")
  recurse(obj)
  --obj = {}
  --obj.a = 5
  --print(obj.a)
  --print(_G)
  --for i in pairs(_G) do print(i) end
  --for i in pairs(os) do print(i) end
  --print(divzero(1))
  --deadcall()
  print()
  print(invoke(deadcall))
  print(invoke(deadcall, 0, 1))
  print(invoke(notdeadcall))
  print(invoke(notdeadcall, 0, 1, 2))
  --print(pcall(deadcall))
  --print(xpcall(deadcall, notdeadcall)) -- will cause fatal crash
  --print(xpcall(deadcall, function() print("error") end)) -- prints falsevoid
  --print(startLuaCoroutine(Global, "global_coro"))
end

function recurse(obj)
  if not obj then return end
  print("[" .. tostring(obj) .. "]")
  local a = has(obj, "getComponents")
  print(a)
  --print(invoke(obj.getComponents)) --even this breaks
  local b = gcall(obj.getComponents) --really shouldn't need this
  print(b)
  if b then
    for i,v in ipairs(obj.getComponents()) do print(v) end
  end
  local c = has(obj, "getChildren")
  print(c)
  if c then
    for i,v in ipairs(obj.getChildren()) do recurse(v) end
  end
end

function invoke(fn, ...)
  if not fn then return nil end
  arg = {...}
  if ... == nil then arg = nil end
  retval = nil
  wrap = function()
    if arg == nil then retval = fn() else retval = fn(arg) end
    --print("Done!")
    coroutine.yield()
  end
  coro = coroutine.create(wrap)
  --print(coroutine.status(coro))
  coroutine.resume(coro)
  return retval
end

function has(base, attr)
  if not base then return false end
  retval = false
  coro = coroutine.create(function()
    local a = base[attr]
    retval = true
    coroutine.yield()
  end)
  coroutine.resume(coro)
  return retval
end

function divzero(x)
  return x / 0
end -- returns Infinity

function deadcall(...)
  a.call()
end

function notdeadcall(...)
  if not ... then return nil end
  for i,v in ipairs(...) do print(v) end
  return ...
end

-- STEP OVER FUNCTIONALITY FOR HARD MOONSHARP ERRORS --
local global_call_input = nil
local global_call_extra = nil
local global_call_output = nil
function global_call()
  print("global_call")
  --print("BEGIN INPUT")
  --print(_G.global_call_input)
  --print(_G.global_call_extra)
  --print("END")
  _G.global_call_output = invoke(_G.global_call_input,
    _G.global_call_extra)
  --print("BEGIN OUTPUT")
  --print(_G.global_call_output)
  --print("END")
  return 1 -- to get rid of stupid unknown error from docs
end
function gcall(fn, ...)
  _G.global_call_input = fn
  _G.global_call_extra = ...
  _G.global_call_output = nil
  startLuaCoroutine(Global, "global_call")
  local retval = _G.global_call_output
  _G.global_call_input = nil
  _G.global_call_extra = nil
  _G.global_call_output = nil
  return retval
end
-- ALSO REQUIRES invoke() GOOGLE ALPHABET --

--[[
physics_inspection loading...
Loading Complete.
[Custom_AssetBundle(Clone)(LuaGameObjectScript)]
true
global_call
table: 0000C563
Transform
MeshFilter
MeshRenderer
Rigidbody
AudioSource
true
[Cube(Clone)]
true
global_call
table: 0000C580
Transform
BoxCollider
true
[Cube1_1]
true
global_call
Error in Script(Global) function
<startLuaCoroutine/global_call>: Object reference not set to an
instance of an object
nil
true
[Cube2_1]
true
global_call
table: 0000C5A8
Transform
MeshFilter
BoxCollider
MeshRenderer
true
[Cube3_1]
true
global_call
table: 0000C5C2
Transform
MeshFilter
BoxCollider
MeshRenderer
true
[Cube4_1]
true
global_call
table: 0000C5DC
Transform
MeshFilter
BoxCollider
MeshRenderer
true

nil
nil
nil
0
1
2
table: 0000C5F7
]]--