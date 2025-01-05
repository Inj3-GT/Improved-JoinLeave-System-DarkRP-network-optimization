-- // SCRIPT BY INJ3
-- // https://steamcommunity.com/id/Inj3/

local ipr_JLSTable = {}
ipr_JLSTable.Grp, ipr_JLSTable.Bool = {}, {}
ipr_JLSTable.Bits = 2
do
    local function Ipr_SortValue(t, n)
        if not ipr_JLSTable.Grp[n] then
            ipr_JLSTable.Grp[n] = {}
        end

        local b = (n == 1)
        for i = 1, #t do
            t[i] = (b and t[i]:lower()) or t[i]

            if not ipr_JLSTable.Grp[n][t[i]] then
                ipr_JLSTable.Grp[n][t[i]] = {}
            end
            ipr_JLSTable.Grp[n][t[i]] = true
        end
    end

    Ipr_SortValue(Ipr_JoinLeave_Sys.Config.Server.BlockName.blacklist, 1)
    Ipr_SortValue(Ipr_JoinLeave_Sys.Config.Server.HideNotification_GameLoaded.group, 2)
    Ipr_SortValue(Ipr_JoinLeave_Sys.Config.Server.HideNotification_GameLeave.group, 3)
    Ipr_SortValue(Ipr_JoinLeave_Sys.Config.Server.HideNotification_GameInit.group, 4)
end

local function ipr_SendMsg(u, s, g)
    local ipr_Player = player.GetHumans()
    
    for i = 1, #ipr_Player do
        if not IsValid(ipr_Player[i]) then
           continue
        end
        local ipr_UserGrp = ipr_Player[i]:GetUserGroup()
        if (g) and not ipr_JLSTable.Grp[g][ipr_UserGrp] then
           continue
        end

        net.Start("ipr_jls")
        net.WriteUInt(u, ipr_JLSTable.Bits)
        net.WriteString(s)
        net.Send(ipr_Player[i])
    end
end

local function ipr_ClearPlayer(p)
    if (ipr_JLSTable.Bool[p]) then
        ipr_JLSTable.Bool[p] = nil
    end
end

local function ipr_RemoveTimer(s)
    if (timer.Exists("ipr_JLSClear" ..s)) then
        timer.Remove("ipr_JLSClear" ..s)
    end
end

local function ipr_GameLoaded(p)
    timer.Simple(5, function()
        if not IsValid(p) then
            return
        end
        local ipr_Nick = p:Nick() 
        local ipr_SteamID = p:SteamID()

        ipr_ClearPlayer(ipr_SteamID)
        ipr_SendMsg(1, ipr_Nick, Ipr_JoinLeave_Sys.Config.Server.HideNotification_GameLoaded[1] and 2)
    end)
end

local function ipr_GameInit(s, n)
    if (ipr_JLSTable.Bool[s]) then
        return
    end
    ipr_JLSTable.Bool[s] = true
    
    ipr_RemoveTimer(s)
    ipr_SendMsg(0, n, Ipr_JoinLeave_Sys.Config.Server.HideNotification_GameInit[1] and 4)
end

local function ipr_GameLeave(p)
    local ipr_SteamID = p:SteamID()

    if not ipr_JLSTable.Bool[ipr_SteamID] then
        local ipr_TimeOut = p:IsTimingOut() and 3 or 2
        local ipr_Nick = p:Nick()

        ipr_SendMsg(ipr_TimeOut, ipr_Nick, Ipr_JoinLeave_Sys.Config.Server.HideNotification_GameLeave[1] and 3)
    end
    ipr_RemoveTimer(ipr_SteamID)

    timer.Create("ipr_JLSClear" ..ipr_SteamID, Ipr_JoinLeave_Sys.Config.Server.AntiSpam, 1, function()
        ipr_ClearPlayer(ipr_SteamID)
    end)
end

local function ipr_GameConnect(data)
    local ipr_BlockName = Ipr_JoinLeave_Sys.Config.Server.BlockName[1]
    local ipr_DataName = data.name
    
    if (ipr_BlockName) then
        ipr_DataName = ipr_DataName:lower()
        local ipr_DataUserId = data.userid

        for d in pairs(ipr_JLSTable.Grp[1]) do
            if string.find(ipr_DataName, d)  then
                
                timer.Simple(1, function()
                    if not player.GetByID(ipr_DataUserId) then
                        return
                    end
                    
                    game.KickID(ipr_DataUserId, "Votre nom '" ..ipr_DataName.. "' ne respecte pas les règles du serveur." )
                    print("Le joueur '" ..ipr_DataName.. "' a été kické, car il ne respecte pas les noms autorisés sur le serveur.")
                end)
                break
            end
        end
    end
    
    local ipr_NetworkId = data.networkid
    ipr_GameInit(ipr_NetworkId, ipr_DataName)
end

util.AddNetworkString("ipr_jls")
gameevent.Listen("player_connect")

hook.Add("player_connect", "Ipr_JLS_Init", ipr_GameConnect)
hook.Add("PlayerInitialSpawn", "Ipr_JLS_Loaded", ipr_GameLoaded)
hook.Add("PlayerDisconnected", "Ipr_JLS_Logout", ipr_GameLeave)
