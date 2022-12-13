function onPickedUp()
    print("picked up")
    self.AssetBundle.playLoopingEffect(0)
end

function onDrop()
    print("dropped")
    self.AssetBundle.playLoopingEffect(1)
end