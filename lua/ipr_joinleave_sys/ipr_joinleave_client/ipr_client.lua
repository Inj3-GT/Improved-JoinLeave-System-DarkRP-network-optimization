--- Script By Inj3 
--- Script By Inj3 
--- Script By Inj3 
local function Ipr_HideJoinLeaveDefault(index, name, text, typ)
     if (typ == "joinleave") then
          return true
     end
end

local function Ipr_FuncReceive()
     local Ipr_NetUI = net.ReadUInt(2)
     local Ipr_NamePly = net.ReadString()

     if ImprovedJoinLeaveSys.HideLeavePlayer["Enable/Disable"] and (Ipr_NetUI == 3) and not ImprovedJoinLeaveSys.HideLeavePlayer["Group"][LocalPlayer():GetUserGroup()] then
          return
     end

     chat.AddText( ImprovedJoinLeaveSys.JoinLeaveTbl["ColorNameServer"], ImprovedJoinLeaveSys.JoinLeaveTbl["NameServer"].. " : ", ImprovedJoinLeaveSys.JoinLeaveTbl["ColorPlayerJoin"], Ipr_NamePly, ImprovedJoinLeaveSys.JoinLeaveTbl[Ipr_NetUI].Color, ", " ..ImprovedJoinLeaveSys.JoinLeaveTbl[Ipr_NetUI].Texte)
end

hook.Add("ChatText", "Ipr_HideJoinLeaveDefault", Ipr_HideJoinLeaveDefault)
net.Receive("Ipr_JoinLeave", Ipr_FuncReceive)