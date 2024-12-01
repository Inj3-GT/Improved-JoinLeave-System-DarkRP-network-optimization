--- Script By Inj3 
--- Script By Inj3 
--- Script By Inj3 
local Ipr_Cf = file.Find("ipr_joinleave_sys/configuration/*", "LUA")
local Ipr_Cl = file.Find("ipr_joinleave_sys/lua_file/ipr_joinleave_client/*", "LUA")
  
Ipr_JoinLeave_Sys = Ipr_JoinLeave_Sys or {}
Ipr_JoinLeave_Sys.Config = Ipr_JoinLeave_Sys.Config or {}

if (SERVER) then
     for _, f in pairs(Ipr_Cf) do
         include("ipr_joinleave_sys/configuration/"..f)
         AddCSLuaFile("ipr_joinleave_sys/configuration/"..f)
     end

     local Ipr_Sv = file.Find("ipr_joinleave_sys/lua_file/ipr_joinleave_server/*", "LUA")
     for _, f in pairs(Ipr_Sv) do
         include("ipr_joinleave_sys/lua_file/ipr_joinleave_server/"..f)
     end
     for _, f in pairs(Ipr_Cl) do
         AddCSLuaFile("ipr_joinleave_sys/lua_file/ipr_joinleave_client/"..f)
     end
 
     print("Improved Join/Leave System By Inj3 - Loaded")
 else
     for _, f in pairs(Ipr_Cf) do
         include("ipr_joinleave_sys/configuration/"..f)
     end
     for _, f in pairs(Ipr_Cl) do
         include("ipr_joinleave_sys/lua_file/ipr_joinleave_client/"..f)
     end
end