-- // SCRIPT BY INJ3
-- // https://steamcommunity.com/id/Inj3/

local Ipr_Cf = file.Find("ipr_joinleave_configuration/*", "LUA")
local Ipr_Cl = file.Find("ipr_joinleave_lua/client/*", "LUA")

Ipr_JoinLeave_Sys = Ipr_JoinLeave_Sys or {}
Ipr_JoinLeave_Sys.Config = Ipr_JoinLeave_Sys.Config or {}

if (SERVER) then
    for i = 1, #Ipr_Cf do
        include("ipr_joinleave_configuration/"..Ipr_Cf[i])
        AddCSLuaFile("ipr_joinleave_configuration/"..Ipr_Cf[i])
    end

    local Ipr_Sv = file.Find("ipr_joinleave_lua/server/*", "LUA")
    for i = 1, #Ipr_Sv do
        include("ipr_joinleave_lua/server/"..Ipr_Sv[i])
    end

    for i = 1, #Ipr_Cl do
        AddCSLuaFile("ipr_joinleave_lua/client/"..Ipr_Cl[i])
    end

    print("Improved Join/Leave System By Inj3 - Loaded")
else
    for i = 1, #Ipr_Cf do
        include("ipr_joinleave_configuration/"..Ipr_Cf[i])
    end

    for i = 1, #Ipr_Cl do
        include("ipr_joinleave_lua/client/"..Ipr_Cl[i])
    end
end