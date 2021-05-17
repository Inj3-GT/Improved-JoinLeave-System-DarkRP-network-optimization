--- Script By Inj3 
--- Script By Inj3 
--- Script By Inj3 
local Ipr_ConfigurationSys = file.Find("configuration/*", "LUA")
local Ipr_ClientSys = file.Find("ipr_joinleave_sys/ipr_joinleave_client/*", "LUA")

if SERVER then
     local Ipr_ServerSys = file.Find("ipr_joinleave_sys/ipr_joinleave_server/*", "LUA")

     for count, file in pairs(Ipr_ConfigurationSys) do
          include("configuration/"..file)
          AddCSLuaFile("configuration/"..file)
     end

     for count, file in pairs(Ipr_ServerSys) do
          include("ipr_joinleave_sys/ipr_joinleave_server/"..file)
     end

     for count, file in pairs(Ipr_ClientSys) do
          AddCSLuaFile("ipr_joinleave_sys/ipr_joinleave_client/"..file)
     end

     print("Improved Join/Leave System ServerSide By Inj3 - Loaded")
end

if CLIENT then
     for count, file in pairs(Ipr_ConfigurationSys) do
          include("configuration/"..file)
     end

     for count, file in pairs(Ipr_ClientSys) do
          include("ipr_joinleave_sys/ipr_joinleave_client/"..file)
     end

     print("Improved Join/Leave System ClientSide By Inj3 - Loaded")
end