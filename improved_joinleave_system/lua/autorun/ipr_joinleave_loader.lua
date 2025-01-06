-- // SCRIPT BY INJ3
-- // https://steamcommunity.com/id/Inj3/

local ipr_Cf = file.Find("ipr_joinleave_configuration/*", "LUA")
local ipr_Cl = file.Find("ipr_joinleave_lua/client/*", "LUA")

Ipr_JoinLeave_Sys = Ipr_JoinLeave_Sys or {}
Ipr_JoinLeave_Sys.Config = Ipr_JoinLeave_Sys.Config or {}

if (SERVER) then
    for i = 1, #ipr_Cf do
        include("ipr_joinleave_configuration/"..ipr_Cf[i])
        AddCSLuaFile("ipr_joinleave_configuration/"..ipr_Cf[i])
    end

    util.AddNetworkString("ipr_jls")
    util.AddNetworkString("ipr_darkrp_notify")

    local ipr_Sv = file.Find("ipr_joinleave_lua/server/*", "LUA")
    for i = 1, #ipr_Sv do
        include("ipr_joinleave_lua/server/"..ipr_Sv[i])
    end

    for i = 1, #ipr_Cl do
        AddCSLuaFile("ipr_joinleave_lua/client/"..ipr_Cl[i])
    end

    print("Improved Join/Leave System By Inj3 - Loaded")
else
    for i = 1, #ipr_Cf do
        include("ipr_joinleave_configuration/"..ipr_Cf[i])
    end

    for i = 1, #ipr_Cl do
        include("ipr_joinleave_lua/client/"..ipr_Cl[i])
    end
end