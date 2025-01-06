-- // SCRIPT BY INJ3
-- // https://steamcommunity.com/id/Inj3/

hook.Add("ChatText", "ipr_JoinLeaveSys_ChatText", function(index, name, text, type)
    return (type == "joinleave")
end)

local function ipr_Console()
    local ipr_TColor =  {}
    for i = 1, 3 do
        ipr_TColor[i] = net.ReadUInt(8)
    end
    ipr_TColor = Color(ipr_TColor[1], ipr_TColor[3], ipr_TColor[2])
    local ipr_String = net.ReadString().. "\n"

    MsgC(ipr_JLS.Config.Client[5].c, "[JLS] ", ipr_TColor, ipr_String)
    hook.Call("DarkRPLogPrinted", nil, ipr_String, ipr_TColor)
end

local function ipr_Notif()
    local ipr_Time = net.ReadUInt(10)
    local ipr_Type = net.ReadUInt(3)
    local ipr_String = net.ReadString()

    MsgC(ipr_JLS.Config.Client[5].c, "[JLS] ", color_white, ipr_String, "\n")
    notification.AddLegacy(ipr_String, ipr_Type, ipr_Time)

    surface.PlaySound(GAMEMODE.Config.notificationSound)
end

local ipr_GameMode = (string.lower(engine.ActiveGamemode()) == "darkrp") 
local ipr_Receive = {
    [0] = function() ipr_Console() end,
    [1] = function() ipr_Notif() end,
}

net.Receive("ipr_darkrp_notify", function()
    if not ipr_JLS.Config.OptimizeDarkRP or not ipr_GameMode then
        return
    end

    local ipr_NetRead = net.ReadUInt(1)
    ipr_Receive[ipr_NetRead]()
end)

net.Receive("ipr_jls", function()
    local ipr_TConfig = net.ReadUInt(2) + 1
    local ipr_String = net.ReadString()

    chat.AddText(ipr_JLS.Config.Client.ColorNameServer, ipr_JLS.Config.Client.NameServer.. " : ", ipr_JLS.Config.Client.ColorPlayerJoin, ipr_String, ipr_JLS.Config.Client[ipr_TConfig].c, ", " ..ipr_JLS.Config.Client[ipr_TConfig].t)
end)