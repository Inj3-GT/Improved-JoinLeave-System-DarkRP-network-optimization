--- Script By Inj3 
--- Script By Inj3 
--- Script By Inj3 

--- Override and optimize network logging on Gamemode DarkRP !
do
    if (Ipr_JoinLeave_Sys.Config.OptimizeDarkrp) and (string.lower(engine.ActiveGamemode()) == "darkrp") then
        util.AddNetworkString("ipr_dkcsl")
        util.AddNetworkString("ipr_dkntf")

        local function Ipr_LogNotif(p, t, l, m, b)
            if (hook.Run("onNotify", (b) and player.GetAll() or p, t, l, m)) then
                return
            end

            net.Start("ipr_dkntf")
            net.WriteUInt(l or 1, 3)
            net.WriteUInt(t or 3, 16)
            net.WriteString(m)

            if (b) then
                net.Broadcast()
                return
            end
            local ipr_f = RecipientFilter()
            for _, v in ipairs(p) do
                ipr_f:AddPlayer(v)
            end

            net.Send(ipr_f)
        end

        local function Ipr_LogConsole(m, c, p)
            net.Start("ipr_dkcsl")       
            for _, n in pairs(c) do
                net.WriteUInt(n, 8)
            end
            net.WriteString(m)

            local ipr_f = RecipientFilter()
            for _, v in ipairs(p) do
                local ipr_h = hook.Call("canSeeLogMessage", GAMEMODE, v, m, c)
                if not ipr_h then
                    continue
                end

                ipr_f:AddPlayer(v)
            end
            
            net.Send(ipr_f)
        end

        local function Ipr_OverrideFunc()
            if (DarkRP) then
                if not file.IsDir("darkrp_logs", "DATA") then
                    file.CreateDir("darkrp_logs")
                end

                DarkRP.notify = function(p, t, l, m)
                    Ipr_LogNotif(not istable(p) and {p} or p, t, l, m)
                end
                DarkRP.notifyAll = function(t, l, m)
                    Ipr_LogNotif(nil, t, l, m, true)
                end
                local ipr_x = false
                DarkRP.log = function(t, c, n)
                    if (c) then
                        c.a = nil
                        CAMI.GetPlayersWithAccess("DarkRP_SeeEvents", fp{Ipr_LogConsole, t, c})
                    end
                    if not GAMEMODE.Config.logging or (n) then
                        return
                    end
                    local ipr_o, ipr_od = os.date("%m_%d_%Y %I_%M %p"), os.date()
                    if not ipr_x then
                        ipr_x = true
                        file.Write("darkrp_logs/" ..ipr_o.. ".txt", ipr_od .."\t"..t)
                        return
                    end

                    file.Append("darkrp_logs/" ..ipr_o.. ".txt", "\n" ..ipr_od.. "\t" ..(t or ""))
                end
            end
        end
        hook.Add("PostGamemodeLoaded", "Ipr_JLS_DarkRPOver", Ipr_OverrideFunc)
    end
end  
 
------- Optimized for gamemodes
gameevent.Listen("player_connect")
util.AddNetworkString("ipr_jls")
local ipr_cur, ipr_grp, ipr_bits = {}, {}, 2

local function Ipr_TableCreate(t, n)
    for _, v in ipairs(t) do
        if not ipr_grp[n] then
            ipr_grp[n] = {}
        end
        v = (n == "block") and v:lower() or v
        
        if not ipr_grp[n][v] then
            ipr_grp[n][v] = {}
        end
        ipr_grp[n][v] = true
    end
end

local function Ipr_SendNet(u, s)
    net.Start("ipr_jls")
    net.WriteUInt(u, ipr_bits)
    net.WriteString(s)
    net.Broadcast()
end

local function Ipr_Init(p)
    timer.Simple(5, function()
        if not IsValid(p) then
            return
        end
        local ipr_g = p:GetUserGroup()
        if (Ipr_JoinLeave_Sys.Config.Server.HideNotification_GameLoaded[1]) and not ipr_grp["join"][ipr_g] then
            return
        end

        local ipr_n = p:Nick()
        Ipr_SendNet(1, ipr_n)
    end)
end

local function Ipr_Login(ipr_n)
    if (Ipr_JoinLeave_Sys.Config.Server.HideNotification_GameInit) then
        return
    end
    local ipr_c = CurTime()
    if (ipr_c < (ipr_cur[ipr_n] or 0)) then
        return
    end

    Ipr_SendNet(0, ipr_n)
    ipr_cur[ipr_n] = ipr_c + Ipr_JoinLeave_Sys.Config.Server.AntiSpam
end

local function Ipr_Logout(p)
     if (ipr_cur[p] and CurTime() < ipr_cur[p]) then
          return
     end
     local ipr_g = p:GetUserGroup()
     if (Ipr_JoinLeave_Sys.Config.Server.HideNotification_GameLeave[1]) and not ipr_grp["leave"][ipr_g] then
        return
     end
     
     local ipr_t, ipr_n = p:IsTimingOut() and 3 or 2, p:Nick()
     Ipr_SendNet(ipr_t, ipr_n)
     ipr_cur[ipr_n] = nil
end 

local function Ipr_Event(data)
    local ipr_n = data.name
    ipr_n = ipr_n:lower()
    local ipr_d = data.userid

    for k in string.gmatch(ipr_n, "[^%s//]+" ) do
        if (ipr_grp["block"][k]) then
            timer.Simple(1, function()
                if not player.GetByID(ipr_d) then
                    return
                end
                game.KickID(ipr_d, "Votre nom '" ..k.. "' ne respect pas les règles du serveur" )
                print("Le joueur '" ..k.. "' à était kick, car il ne respect pas les noms autorisés sur le serveur.")
            end)
        end
        break
    end
end

Ipr_TableCreate(Ipr_JoinLeave_Sys.Config.Server.BlockName, "block")
Ipr_TableCreate(Ipr_JoinLeave_Sys.Config.Server.HideNotification_GameLoaded.group, "join")
Ipr_TableCreate(Ipr_JoinLeave_Sys.Config.Server.HideNotification_GameLeave.group, "leave")
hook.Add( "PlayerConnect", "Ipr_JLS_Login", Ipr_Login)
hook.Add( "PlayerInitialSpawn", "Ipr_JLS_Init", Ipr_Init)
hook.Add( "PlayerDisconnected", "Ipr_JLS_Logout", Ipr_Logout)
hook.Add( "player_connect", "Ipr_JLS_Event", Ipr_Event)