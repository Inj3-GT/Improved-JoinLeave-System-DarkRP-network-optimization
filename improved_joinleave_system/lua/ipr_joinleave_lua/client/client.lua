-- // SCRIPT BY INJ3
-- // https://steamcommunity.com/id/Inj3/

local function ipr_Chat(i, n, s, t)
    return (t == "joinleave") and true
end

do
    if (ipr_JLS.Config.OptimizeDarkRP) and (string.lower(engine.ActiveGamemode()) == "darkrp") then
        local function ipr_Notif()
            local ipr_l, ipr_t, ipr_s = net.ReadUInt(3), net.ReadUInt(16), net.ReadString()

            MsgC(Color(255, 20, 20, 255), "[JLS] ", Color(200, 200, 200, 255), ipr_s, "\n")
            notification.AddLegacy(ipr_s, ipr_t, ipr_l)
            surface.PlaySound(GAMEMODE.Config.notificationSound)
        end
        local function ipr_Console()
            local ipr_t =  {}
            for i = 1, 3 do
                ipr_t[i] = net.ReadUInt(8)
            end
            local ipr_c, ipr_n = Color(ipr_t[1], ipr_t[3], ipr_t[2]), (ipr_b) and net.ReadString() or DarkRP.deLocalise(net.ReadString() .."\n")
            MsgC(Color(255,0,0), "[JLS] ", ipr_c, ipr_n)

            hook.Call("DarkRPLogPrinted", nil, ipr_n, ipr_c)
        end

        local ipr_Receive = {
            [0] = function() ipr_Console() end,
            [1] = function() ipr_Notif() end,
        }
        
        net.Receive("ipr_darkrp_notify", function()
            local ipr_NetRead = net.ReadUInt(1)
            ipr_Receive[ipr_NetRead]()
        end)
    end
end

local function ipr_JoinLeave()
    local ipr_u = net.ReadUInt(2) + 1
    local ipr_n = net.ReadString()

    chat.AddText(ipr_JLS.Config.Client.ColorNameServer, ipr_JLS.Config.Client.NameServer.. " : ", ipr_JLS.Config.Client.ColorPlayerJoin, ipr_n, ipr_JLS.Config.Client[ipr_u].c, ", " ..ipr_JLS.Config.Client[ipr_u].t)
end

net.Receive("ipr_jls", ipr_JoinLeave)
hook.Add("ChatText", "ipr_JoinLeaveSys_ChatText", ipr_Chat)
