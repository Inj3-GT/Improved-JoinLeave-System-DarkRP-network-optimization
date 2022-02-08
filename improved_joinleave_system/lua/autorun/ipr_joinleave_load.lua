--- Script By Inj3 
--- Script By Inj3 
--- Script By Inj3 
ImprovedJoinLeaveSys = ImprovedJoinLeaveSys or {}
local Ipr_ConfigurationSys = file.Find("ipr_joinleave_sys/configuration/*", "LUA")
local Ipr_ClientSys = file.Find("ipr_joinleave_sys/lua_file/ipr_joinleave_client/*", "LUA")

if SERVER then
     local Ipr_ServerSys = file.Find("ipr_joinleave_sys/lua_file/ipr_joinleave_server/*", "LUA")

     for count, file in pairs(Ipr_ConfigurationSys) do
          include("ipr_joinleave_sys/configuration/"..file)
          AddCSLuaFile("ipr_joinleave_sys/configuration/"..file)
     end

     for count, file in pairs(Ipr_ServerSys) do
          include("ipr_joinleave_sys/lua_file/ipr_joinleave_server/"..file)
     end

     for count, file in pairs(Ipr_ClientSys) do
          AddCSLuaFile("ipr_joinleave_sys/lua_file/ipr_joinleave_client/"..file)
     end
     
     print("Improved Join/Leave System By Inj3 - Loaded")
end

if CLIENT then
     for count, file in pairs(Ipr_ConfigurationSys) do
          include("ipr_joinleave_sys/configuration/"..file)
     end

     for count, file in pairs(Ipr_ClientSys) do
          include("ipr_joinleave_sys/lua_file/ipr_joinleave_client/"..file)
     end
end
