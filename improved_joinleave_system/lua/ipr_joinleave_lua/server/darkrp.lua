--- Script By Inj3 
--- Script By Inj3 
--- Script By Inj3 
if not Ipr_JoinLeave_Sys.Config.OptimizeDarkrp or (string.lower(engine.ActiveGamemode()) ~= "darkrp") then
    return 
end
util.AddNetworkString("ipr_dkntf")

local function Ipr_LogNotif(p, t, l, m, b)
    if (hook.Run("onNotify", (b) and player.GetAll() or p, t, l, m)) then
        return
    end

    net.Start("ipr_dkntf")
    net.WriteUInt(1, 1)
    net.WriteUInt(l or 1, 3)
    net.WriteUInt(t or 3, 16)
    net.WriteString(m)

    if (b) then
        net.Broadcast()
        return
    end

    local ipr_RecipFilter = RecipientFilter()
    for i = 1, #p do
        local ipr_Player = p[i]
        if not IsValid(ipr_Player) then
            continue
        end

        ipr_RecipFilter:AddPlayer(ipr_Player)
    end
    net.Send(ipr_RecipFilter)
end

local function Ipr_LogConsole(m, c, p)
    net.Start("ipr_dkntf")
    net.WriteUInt(0, 1)

    for _, n in pairs(c) do
        net.WriteUInt(n, 8)
    end

    net.WriteString(m)

    local ipr_RecipFilter = RecipientFilter()
    for i = 1, #p do
        local ipr_Player = p[i]
        if not IsValid(ipr_Player) then
            continue
        end
        if not hook.Call("canSeeLogMessage", GAMEMODE, ipr_Player, m, c) then
           continue
        end

        ipr_RecipFilter:AddPlayer(ipr_Player)
    end
    net.Send(ipr_RecipFilter)
end

local function Ipr_OverrideFunc()
    if (DarkRP) then
        DarkRP.notify = function(p, t, l, m)
            p = (type(p) ~= "table") and {p} or IsValid(p) and p
            if not p then
                return
            end

            Ipr_LogNotif(p, t, l, m)
        end
        DarkRP.notifyAll = function(t, l, m)
            Ipr_LogNotif(nil, t, l, m, true)
        end

        local ipr_OsDateYear = os.date("%Y")
        local ipr_OsDateMonth = os.date("%B")
        local ipr_LogsPath = "darkrp_logs/" ..ipr_OsDateYear.. "/" ..ipr_OsDateMonth

        if not file.IsDir(ipr_LogsPath, "DATA") then
            file.CreateDir(ipr_LogsPath)
        end

        local ipr_Localization = (GetConVar("gmod_language"):GetString() == "fr")
        local ipr_OsDate = os.date(ipr_Localization and "%d_%m__%H_%M_%p" or "%m_%d__%I_%M_%p")
        local ipr_Path = ipr_LogsPath.. "/" ..ipr_OsDate.. ".json"
        local ipr_Session = false

        DarkRP.log = function(t, c, n)
            t = t or "[ERROR function DarkRP.log] You have not specified a valid argument (string message), fix the addon : " ..debug.getinfo(2, "S").short_src

            if (c) then
                c.a = nil
                CAMI.GetPlayersWithAccess("DarkRP_SeeEvents", fp{Ipr_LogConsole, t, c})
            end
            if not GAMEMODE.Config.logging or (n) then
                return
            end

            local ipr_OsDate_ = os.date("%X")
            if not ipr_Session then
                file.Write(ipr_Path, ipr_OsDate_ .."\t [JLS] "..t)
                ipr_Session = true
                return
            end
            
            file.Append(ipr_Path, "\n" ..ipr_OsDate_.. "\t [JLS] " ..t)
        end
    end 
end

hook.Add("PostGamemodeLoaded", "Ipr_JLS_DarkRPOver", Ipr_OverrideFunc)

-- // Debug - DarkRP.notify(player.GetAll()[1], 1, 1, "test") 
-- // Debug - DarkRP.notifyAll(1, 1, "test") 
-- // Debug - DarkRP.log("test", color_white, false) 
