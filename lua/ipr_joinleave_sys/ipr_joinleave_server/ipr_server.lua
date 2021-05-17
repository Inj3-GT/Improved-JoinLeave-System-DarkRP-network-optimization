--- Script By Inj3 
--- Script By Inj3 
--- Script By Inj3 
util.AddNetworkString( "Ipr_JoinLeave" )
gameevent.Listen( "player_connect" )

local Ipr_SysTblSv = Ipr_SysTblSv or {}

local function Impr_LogPlayer(name, ip)
     local Ipr_CurTime = CurTime()

     if Ipr_CurTime > (Ipr_SysTblSv[name] or 0) then
          net.Start("Ipr_JoinLeave")
          net.WriteUInt( 1, 2 )
          net.WriteString(name)
          net.Broadcast()

          Ipr_SysTblSv[name] = Ipr_CurTime + ImprovedJoinLeaveSys.AntiSpam
     end
end

local function Impr_InitPlayer(player, transition)
     local ImprovedJoinLeavePlayer = player:Nick()

     timer.Simple(5, function()
     if not IsValid(player) then
          return
     end

     net.Start("Ipr_JoinLeave")
     net.WriteUInt( 2, 2 )
     net.WriteString(ImprovedJoinLeavePlayer)
     net.Broadcast()
     end)
end

local function Impr_InitDiscoPlayer(player)
     local ImprovedJoinLeavePlayer = player:Nick()
     if Ipr_SysTblSv[ImprovedJoinLeavePlayer] and CurTime() < Ipr_SysTblSv[ImprovedJoinLeavePlayer] then
          return
     end

     net.Start("Ipr_JoinLeave")
     net.WriteUInt( 3, 2 )
     net.WriteString(ImprovedJoinLeavePlayer)
     net.Broadcast()

     Ipr_SysTblSv[ImprovedJoinLeavePlayer] = nil
end

local function Impr_LogNameKick(data)
     local ImprovedJoinLeavePlayer = data.name
     local ImprovedJoinLeaveID = data.userid

     for k in string.gmatch( ImprovedJoinLeavePlayer, "[^%s//]+" ) do
          for _, d in pairs(ImprovedJoinLeaveSys.BlockName) do
               if string.find( k:lower(), d:lower() )  then

                    timer.Simple(1, function()
                    if not player.GetByID( ImprovedJoinLeaveID ) then
                         return
                    end
                    game.KickID( ImprovedJoinLeaveID, "Votre nom '" ..k:lower().. "' ne respect pas les règles du serveur" )
                    print("Le joueur '" ..k:lower().. "' à était kick, car il ne respect pas les noms autorisés sur le serveur.")
                    end)
                    break
               end
          end
          break
     end
end

hook.Add( "PlayerConnect", "Impr_LogPlayer", Impr_LogPlayer )
hook.Add( "PlayerInitialSpawn", "Impr_InitPlayer", Impr_InitPlayer )
hook.Add( "PlayerDisconnected", "Impr_InitDiscoPlayer", Impr_InitDiscoPlayer )
hook.Add( "player_connect", "Impr_LogNameKick", Impr_LogNameKick)
