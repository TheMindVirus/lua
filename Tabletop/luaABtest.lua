function onLoad()
  print("[MAUL]: Loading...")
  --Bob, Do Something!...Bob?...Bob!?...
  TTSMod:onAddAssetBundle(TTSMod, AB.new())
  print(TTSMod.LuaScript)
  print(TTSMod.LuaScriptState)
  print(TTSMod.XmlUI)
end

AB = {}
TTS = {}
TTSMod = {}

function AB:new()
  --...Bob!?!?...
  local x = {}
  for i,v in pairs(AB) do x[i] = AB[i] end
  --ipairs does not work for this
  return x
end

function AB:find() --self is automatic...not intuititive.
  --...Bob!?!?!?...
  local x = {}
  x[0] = self
  return x
end

function TTS:construct(self, AB)
  --...Bob!?!?!?!?...
  self.LuaScript = "LuaScript"
  self.LuaScriptState = "LuaScriptState"
  self.XmlUI = "XmlUI"
  return self
end

function TTSMod:onAddAssetBundle(self, AB)
  TTS.construct(self, AB)
  self.LuaScript = AB.find("*.lua")[0]
  self.LuaScriptState = AB.find("*.lss")[0]
  self.XmlUI = AB.find("*.xml")[0]
end