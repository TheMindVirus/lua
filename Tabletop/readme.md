# Introducing `gcall()` for Tabletop Simulator Moonsharp Lua 5.2 Version 2.0.0.0

https://github.com/TheMindVirus/lua/blob/600cb07aa6efd98caa0c45c39060eec7c1eab0af/Tabletop/gcall.lua#L100

![gcall](/Tabletop/gcall.png)

`gcall()` is a workaround for obscure errors encountered in Lua Scripting \
for Tabletop Simulator. It performs step-over behaviour, allowing code to \
complete execution while still providing feedback of what went wrong. \
The default behaviour is to halt in the middle of execution which is problematic.

Whilst TTS is based on Unity and Mono with a common language runtime, \
the running of C# .NET scripts from the UnityEditor is not allowed. \
Therefore, most object behaviours have to be transcribed into Lua \
because it is supported but has too heavily a sandboxed environment.

The process for adding the Lua scripts to the objects in the game \
are completely manual and hand-written, requiring manual editing \
of either the in-game scripting console or the .json save state. \
This can be really problematic for modders of Tabletop Simulator.

`gcall()` is one step towards making it easier to reimplement \
the required code by reintroducing lua to try/catch exception handling. \
It requires a custom `invoke()` function and can also be used \
with the built-in `pcall()` and `xpcall()` functions, as even they halt.

Numerous other bugs were encountered in the development of `gcall()` \
such as Hinge Joints with Child-Objects of Prefabs not working as expected.

TODO: Add an option which silences forcibly raised errors during `gcall()`
