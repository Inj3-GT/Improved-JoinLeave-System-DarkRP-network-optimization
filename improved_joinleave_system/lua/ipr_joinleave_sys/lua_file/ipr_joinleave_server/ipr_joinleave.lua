--- Script By Inj3 
--- Script By Inj3 
--- Script By Inj3 
local ipr_JLSTable = {}
ipr_JLSTable.Grp, ipr_JLSTable.Cur = {}, {}
ipr_JLSTable.Bits = 2

local function Ipr_SortValue(t, n)
    if not ipr_JLSTable.Grp[n] then
        ipr_JLSTable.Grp[n] = {}
    end

    for _, v in ipairs(t) do
        v = (n == 1) and v:lower() or v
        
        if not ipr_JLSTable.Grp[n][v] then
            ipr_JLSTable.Grp[n][v] = {}
        end
        ipr_JLSTable.Grp[n][v] = true
    end
end

local function Ipr_MssgNet(u, s, g)
    local ipr_p = player.GetHumans()

    for _, v in ipairs(ipr_p) do
        if not IsValid(v) then
           continue
        end
        local ipr_g = v:GetUserGroup()
        if (g) and not ipr_JLSTable.Grp[g][ipr_g] then
           continue
        end

        net.Start("ipr_jls")
        net.WriteUInt(u, ipr_JLSTable.Bits)
        net.WriteString(s)
        net.Send(v)
    end
end

local function Ipr_ClearPlayer(p)
    if (ipr_JLSTable.Cur[p]) then
        ipr_JLSTable.Cur[p] = nil
    end
end

local function Ipr_GameLoaded(p)
    timer.Simple(7, function()
        if not IsValid(p) then
            return
        end
            
        local ipr_SteamID = p:SteamID()
        Ipr_ClearPlayer(ipr_SteamID)
        local ipr_Nick = p:Nick()    
        Ipr_MssgNet(1, ipr_Nick, Ipr_JoinLeave_Sys.Config.Server.HideNotification_GameLoaded[1] and 2 or nil)
    end)
end

local function Ipr_GameInit(s, n)
    local ipr_JLSClear = "ipr_JLSClear" ..s
    if (timer.Exists(ipr_JLSClear)) then
        timer.Remove(ipr_JLSClear)
    end
    local ipr_CurTime = CurTime()
    local ipr_JLS = ipr_JLSTable.Cur[s]
    if (ipr_JLS and (ipr_CurTime < ipr_JLS)) then
        return
    end

    local ipr_AntiSpam = Ipr_JoinLeave_Sys.Config.Server.AntiSpam
    ipr_JLSTable.Cur[s] = ipr_CurTime + ipr_AntiSpam
    Ipr_MssgNet(0, n, Ipr_JoinLeave_Sys.Config.Server.HideNotification_GameInit[1] and 4 or nil)
end

local function Ipr_GameLeave(p)
    local ipr_SteamID = p:SteamID()
    local ipr_JLS = ipr_JLSTable.Cur[ipr_SteamID]
    local ipr_CurTime = CurTime()
    
    if (ipr_CurTime > (ipr_JLS or 0)) then
        local ipr_Int = p:IsTimingOut() and 3 or 2
        local ipr_Nick = p:Nick()
        Ipr_MssgNet(ipr_Int, ipr_Nick, Ipr_JoinLeave_Sys.Config.Server.HideNotification_GameLeave[1] and 3 or nil)

        local ipr_JLSClear = "ipr_JLSClear" ..ipr_SteamID
        if (timer.Exists(ipr_JLSClear)) then
            return
        end
        timer.Create(ipr_JLSClear, Ipr_JoinLeave_Sys.Config.Server.AntiSpam, 1, function()
            Ipr_ClearPlayer(ipr_SteamID)
        end)
    end
end

local function Ipr_GameConnect(data)
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
    Ipr_GameInit(ipr_NetworkId, ipr_DataName)
end
 
Ipr_SortValue(Ipr_JoinLeave_Sys.Config.Server.BlockName.blacklist, 1)
Ipr_SortValue(Ipr_JoinLeave_Sys.Config.Server.HideNotification_GameLoaded.group, 2)
Ipr_SortValue(Ipr_JoinLeave_Sys.Config.Server.HideNotification_GameLeave.group, 3)
Ipr_SortValue(Ipr_JoinLeave_Sys.Config.Server.HideNotification_GameInit.group, 4)
util.AddNetworkString("ipr_jls")
gameevent.Listen("player_connect")
hook.Add("player_connect", "Ipr_JLS_Init", Ipr_GameConnect)
hook.Add("PlayerInitialSpawn", "Ipr_JLS_Loaded", Ipr_GameLoaded)
hook.Add("PlayerDisconnected", "Ipr_JLS_Logout", Ipr_GameLeave)
