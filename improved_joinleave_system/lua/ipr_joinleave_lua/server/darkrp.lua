--- Script By Inj3 
--- Script By Inj3 
--- Script By Inj3 
if not Ipr_JoinLeave_Sys.Config.OptimizeDarkrp or (string.lower(engine.ActiveGamemode()) ~= "darkrp") then
    return 
end

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
    for i = 1, #p do
        ipr_f:AddPlayer(p[i])
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
    for i = 1, #p do
        if not hook.Call("canSeeLogMessage", GAMEMODE, p[i], m, c) then
           continue
        end

        ipr_f:AddPlayer(p[i])
    end

    net.Send(ipr_f)
end

local function Ipr_OverrideFunc()
    if (DarkRP) then
        if not file.IsDir("darkrp_logs", "DATA") then
            file.CreateDir("darkrp_logs")
        end

        DarkRP.notify = function(p, t, l, m)
            Ipr_LogNotif(type(p) == "table" and {p} or p, t, l, m)
        end
        DarkRP.notifyAll = function(t, l, m)
            Ipr_LogNotif(nil, t, l, m, true)
        end
        DarkRP.log = function(t, c, n)
            if (c) then
                c.a = nil
                CAMI.GetPlayersWithAccess("DarkRP_SeeEvents", fp{Ipr_LogConsole, t, c})
            end
            if not GAMEMODE.Config.logging or (n) then
                return
            end
            local ipr_osdate = os.date("%m_%d_%Y")
            local ipr_path = "darkrp_logs/" ..ipr_osdate.. ".json"
            local ipr_osdate_ = os.date("%H:%M:%S")

            if not file.Exists(ipr_path, "DATA") then
                file.Write(ipr_path, ipr_osdate_ .."\t"..t)
            else
                file.Append(ipr_path, "\n" ..ipr_osdate_.. "\t" ..(t or "No Data"))
            end
        end
    end
end
hook.Add("PostGamemodeLoaded", "Ipr_JLS_DarkRPOver", Ipr_OverrideFunc)