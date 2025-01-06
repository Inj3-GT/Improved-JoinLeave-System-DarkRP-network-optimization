-- // SCRIPT BY INJ3
-- // https://steamcommunity.com/id/Inj3/

local ipr_JLSTable = {}
ipr_JLSTable.Grp, ipr_JLSTable.Bool = {}, {}
ipr_JLSTable.Bits = 2
do
    local function Ipr_SortValue(ptable, name)
        if not ipr_JLSTable.Grp[name] then
            ipr_JLSTable.Grp[name] = {}
        end

        local b = (name == 1)
        for i = 1, #ptable do
            ptable[i] = (b and ptable[i]:lower()) or ptable[i]

            if not ipr_JLSTable.Grp[name][ptable[i]] then
                ipr_JLSTable.Grp[name][ptable[i]] = {}
            end
            ipr_JLSTable.Grp[name][ptable[i]] = true
        end
    end

    Ipr_SortValue(Ipr_JoinLeave_Sys.Config.Server.BlockName.blacklist, 1)
    Ipr_SortValue(Ipr_JoinLeave_Sys.Config.Server.HideNotification_GameLoaded.group, 2)
    Ipr_SortValue(Ipr_JoinLeave_Sys.Config.Server.HideNotification_GameLeave.group, 3)
    Ipr_SortValue(Ipr_JoinLeave_Sys.Config.Server.HideNotification_GameInit.group, 4)
end

local function ipr_SendMsg(msgtype, msg, hide)
    net.Start("ipr_jls")
    net.WriteUInt(msgtype, ipr_JLSTable.Bits)
    net.WriteString(msg)

    local ipr_RecipFilter = RecipientFilter()
    local ipr_GPlayer = player.GetHumans()
    
    for i = 1, #ipr_GPlayer do
        local ipr_Player = ipr_GPlayer[i]
        if not IsValid(ipr_Player) then
           continue
        end
        local ipr_UserGrp = ipr_Player:GetUserGroup()
        if (hide) and not ipr_JLSTable.Grp[g][ipr_UserGrp] then
           continue
        end

        ipr_RecipFilter:AddPlayer(ipr_Player)
    end

    net.Send(ipr_RecipFilter)
end

local function ipr_ClearPlayer(ply)
    if (ipr_JLSTable.Bool[ply]) then
        ipr_JLSTable.Bool[ply] = nil
    end
end

local function ipr_RemoveTimer(steamid)
    if (timer.Exists("ipr_JLSClear" ..steamid)) then
        timer.Remove("ipr_JLSClear" ..steamid)
    end
end

local function ipr_GameLoaded(ply)
    timer.Simple(5, function()
        if not IsValid(ply) then
            return
        end
        local ipr_Nick = ply:Nick() 
        local ipr_SteamID = ply:SteamID()

        ipr_ClearPlayer(ipr_SteamID)
        ipr_SendMsg(1, ipr_Nick, Ipr_JoinLeave_Sys.Config.Server.HideNotification_GameLoaded[1] and 2)
    end)
end

local function ipr_GameInit(steamid, name)
    if (ipr_JLSTable.Bool[steamid]) then
        return
    end
    ipr_JLSTable.Bool[steamid] = true
    
    ipr_RemoveTimer(steamid)
    ipr_SendMsg(0, name, Ipr_JoinLeave_Sys.Config.Server.HideNotification_GameInit[1] and 4)
end

local function ipr_GameLeave(ply)
    local ipr_SteamID = ply:SteamID()

    if not ipr_JLSTable.Bool[ipr_SteamID] then
        local ipr_TimeOut = ply:IsTimingOut() and 3 or 2
        local ipr_Nick = ply:Nick()

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

gameevent.Listen("player_connect")
hook.Add("player_connect", "Ipr_JLS_Init", ipr_GameConnect)
hook.Add("PlayerInitialSpawn", "Ipr_JLS_Loaded", ipr_GameLoaded)
hook.Add("PlayerDisconnected", "Ipr_JLS_Logout", ipr_GameLeave)