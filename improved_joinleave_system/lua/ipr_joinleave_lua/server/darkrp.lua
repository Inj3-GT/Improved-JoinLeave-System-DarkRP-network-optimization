-- // SCRIPT BY INJ3
-- // https://steamcommunity.com/id/Inj3/

local function ipr_Notify(ply, msgtype, time, msg, broadcast)
    local ipr_PTable = (broadcast) and player.GetHumans() or ply
    ipr_PTable = (type(ipr_PTable) == "Player") and {ipr_PTable} or ipr_PTable
    if not ipr_PTable then
        return
    end
    if (hook.Run("onNotify", ipr_PTable, msgtype, time, msg)) then
        return
    end

    net.Start("ipr_darkrp_notify")
    net.WriteUInt(1, 1)
    
    net.WriteUInt(time or 1, 10)
    net.WriteUInt(msgtype or 0, 3)
    net.WriteString(msg)

    local ipr_RecipFilter = RecipientFilter()
    ipr_RecipFilter:AddPlayers(ipr_PTable)
    
    net.Send(ipr_RecipFilter)
end

local function ipr_Console(msg, color, ptable)
    net.Start("ipr_darkrp_notify")
    net.WriteUInt(0, 1)

    for _, c in pairs(color) do
        net.WriteUInt(c, 8)
    end
    net.WriteString(msg)

    local ipr_RecipFilter = RecipientFilter()
    for i = 1, #ptable do
        local ipr_Player = ptable[i]
        if not IsValid(ipr_Player) then
            continue
        end
        if not hook.Call("canSeeLogMessage", GAMEMODE, ipr_Player, msg, color) then
           continue
        end

        ipr_RecipFilter:AddPlayer(ipr_Player)
    end

    net.Send(ipr_RecipFilter)
end

local function ipr_OverrideFunc()
    if not ipr_JLS.Config.OptimizeDarkRP or not DarkRP then
        return
    end

    DarkRP.notify = function(ply, msgtype, time, msg)
        ipr_Notify(ply, msgtype, time, msg)
    end

    DarkRP.notifyAll = function(msgtype, time, msg)
        ipr_Notify(nil, msgtype, time, msg, true)
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

    DarkRP.log = function(msg, color, log)
        msg = msg or "[ERROR function DarkRP.log] You have not specified a valid argument (string message), fix the addon : " ..debug.getinfo(2, "S").short_src

        if (color) then
            color.a = nil
            CAMI.GetPlayersWithAccess("DarkRP_SeeEvents", fp{ipr_Console, msg, color})
        end
        if not GAMEMODE.Config.logging or (log) then
            return
        end

        local ipr_OsDate_ = os.date("%X")
        if not ipr_Session then
            ipr_Session = true
            file.Write(ipr_Path, ipr_OsDate_ .."\t [JLS] "..msg)
            return
        end

        file.Append(ipr_Path, "\n" ..ipr_OsDate_.. "\t [JLS] " ..msg)
    end
end

hook.Add("PostGamemodeLoaded", "Ipr_JLS_DarkRPOver", ipr_OverrideFunc)
-- // Debug - DarkRP.notify(player.GetAll()[1], 1, 1, "test") 
-- // Debug - DarkRP.notifyAll(1, 1, "test")  
-- // Debug - DarkRP.log("test", color_white, false) 
