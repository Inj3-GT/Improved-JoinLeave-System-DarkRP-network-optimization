--- Script By Inj3 
--- Script By Inj3 
--- Script By Inj3 

do
    --- Override and optimize network logging on Gamemode DarkRP !
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
local ipr_cur, ipr_grp, ipr_bits = {}, {}, 2

local function Ipr_SortValue(t, n)
    if not ipr_grp[n] then
        ipr_grp[n] = {}
    end

    for _, v in ipairs(t) do
        v = (n == "1") and v:lower() or v
        if not ipr_grp[n][v] then
            ipr_grp[n][v] = {}
        end
        ipr_grp[n][v] = true
    end
end

local function Ipr_SortNet(u, s, g)
    local Ipr_Player = ents.FindByClass("player")

    for _, v in ipairs(Ipr_Player) do
        if not IsValid(v) then
           continue
        end
        local ipr_vgroup = v:GetUserGroup()
        if (g) and not ipr_grp[g][ipr_vgroup] then
           continue
        end

        net.Start("ipr_jls")
        net.WriteUInt(u, ipr_bits)
        net.WriteString(s)
        net.Send(v)
    end
end

local function Ipr_GameLoaded(p)
    timer.Simple(7, function()
        if not IsValid(p) then
            return
        end

        local ipr_n = p:Nick()
        Ipr_SortNet(1, ipr_n, Ipr_JoinLeave_Sys.Config.Server.HideNotification_GameLoaded[1] and "2" or nil)
    end)
end

local function Ipr_GameInit(p)
    local ipr_c = CurTime()
    if (ipr_c < (ipr_cur[p] or 0)) then
        return
    end

    Ipr_SortNet(0, p, Ipr_JoinLeave_Sys.Config.Server.HideNotification_GameInit and "4" or nil)
    ipr_cur[p] = ipr_c + Ipr_JoinLeave_Sys.Config.Server.AntiSpam
end

local function Ipr_GameLeave(p)
    local ipr_c = CurTime()
    if (ipr_cur[p]) and (ipr_c < ipr_cur[p]) then
        return
    end

    local ipr_t, ipr_n = p:IsTimingOut() and 3 or 2, p:Nick()
    Ipr_SortNet(ipr_t, ipr_n, Ipr_JoinLeave_Sys.Config.Server.HideNotification_GameLeave[1] and "3" or nil)
    ipr_cur[ipr_n] = nil
end

local function Ipr_GameConnect(data)
    local ipr_n = data.name
    ipr_n = ipr_n:lower()
    local ipr_d = data.userid

    local ipr_x = false
    if (Ipr_JoinLeave_Sys.Config.Server.BlockName) then
        for d in pairs(ipr_grp["1"]) do
            local ipr_w = d:lower()
            if string.find(ipr_n, ipr_w)  then
                timer.Simple(1, function()
                    if not player.GetByID(ipr_d) then
                        return
                    end
                    game.KickID(ipr_d, "Votre nom '" ..ipr_n.. "' ne respect pas les règles du serveur" )
                    print("Le joueur '" ..ipr_n.. "' à était kick, car il ne respect pas les noms autorisés sur le serveur.")
                end)
                ipr_x = true
                break
            end
        end
    end
    if not ipr_x then
        Ipr_GameInit(data.name)
    end
end
 
Ipr_SortValue(Ipr_JoinLeave_Sys.Config.Server.BlockName.blacklist, "1")
Ipr_SortValue(Ipr_JoinLeave_Sys.Config.Server.HideNotification_GameLoaded.group, "2")
Ipr_SortValue(Ipr_JoinLeave_Sys.Config.Server.HideNotification_GameLeave.group, "3")
Ipr_SortValue(Ipr_JoinLeave_Sys.Config.Server.HideNotification_GameInit.group, "4")
util.AddNetworkString("ipr_jls")
gameevent.Listen("player_connect")
hook.Add("player_connect", "Ipr_JLS_Init", Ipr_GameConnect)
hook.Add("PlayerInitialSpawn", "Ipr_JLS_Loaded", Ipr_GameLoaded)
hook.Add("PlayerDisconnected", "Ipr_JLS_Logout", Ipr_GameLeave)
