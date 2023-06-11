--- Script By Inj3 
--- Script By Inj3 
--- Script By Inj3
local function Ipr_Chat(i, n, s, t)
     return (t == "joinleave") and true
end

do
     if (Ipr_JoinLeave_Sys.Config.OptimizeDarkrp) and (string.lower(engine.ActiveGamemode()) == "darkrp") then
         local function Ipr_JLS_Notif()
             local ipr_l, ipr_t, ipr_s = net.ReadUInt(3), net.ReadUInt(16), net.ReadString()
             
             MsgC(Color(255, 20, 20, 255), "[JLS] ", Color(200, 200, 200, 255), ipr_s, "\n")
             notification.AddLegacy(ipr_s, ipr_t, ipr_l)
             
             surface.PlaySound(GAMEMODE.Config.notificationSound)
         end

         local function Ipr_JLS_Console()
             local ipr_t =  {}
             for i = 1, 3 do
                 ipr_t[i] = net.ReadUInt(8)
             end
             local ipr_c, ipr_n = Color(ipr_t[1], ipr_t[3], ipr_t[2]), (ipr_b) and net.ReadString() or DarkRP.deLocalise(net.ReadString() .."\n")
             MsgC(Color(255,0,0), "[JLS] ", ipr_c, ipr_n)
 
             hook.Call("DarkRPLogPrinted", nil, ipr_n, ipr_c)
         end

         net.Receive("ipr_dkntf", Ipr_JLS_Notif)
         net.Receive("ipr_dkcsl", Ipr_JLS_Console)
     end
end 

local function Ipr_Log()
     local ipr_u = net.ReadUInt(3)
     local ipr_n = net.ReadString()
     
     if (ipr_u == 3) and Ipr_JoinLeave_Sys.Config.Client.ScriptEnabled and not Ipr_JoinLeave_Sys.Config.Client.Group[LocalPlayer():GetUserGroup()] then
         return
     end
     chat.AddText(Ipr_JoinLeave_Sys.Config.Client.ColorNameServer, Ipr_JoinLeave_Sys.Config.Client.NameServer.. " : ", Ipr_JoinLeave_Sys.Config.Client.ColorPlayerJoin, ipr_n, Ipr_JoinLeave_Sys.Config.Client[ipr_u].Color, ", " ..Ipr_JoinLeave_Sys.Config.Client[ipr_u].Texte)
end

net.Receive("ipr_joinleave", Ipr_Log)
hook.Add("ChatText", "ipr_JoinLeaveSys_ChatText", Ipr_Chat)