--- Script By Inj3 
--- Script By Inj3 
--- Script By Inj3 
local ipr_JLSTable = {}
ipr_JLSTable.Grp = {}

local function Ipr_SortValue(t, n)
    if not ipr_JLSTable.Grp[n] then
        ipr_JLSTable.Grp[n] = {}
    end

    for _, v in ipairs(t) do
        v = (n == "1") and v:lower() or v
        if not ipr_JLSTable.Grp[n][v] then
            ipr_JLSTable.Grp[n][v] = {}
        end
        ipr_JLSTable.Grp[n][v] = true
    end
end

ipr_JLSTable.Bits = 2
local function Ipr_SortNet(u, s, g)
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

local function Ipr_GameLoaded(p)
    timer.Simple(7, function()
        if not IsValid(p) then
            return
        end

        local ipr_n = p:Nick()
        Ipr_SortNet(1, ipr_n, Ipr_JoinLeave_Sys.Config.Server.HideNotification_GameLoaded[1] and "2" or nil)
    end)
end

ipr_JLSTable.Cur = {}
local function Ipr_GameInit(p)
    local ipr_c = CurTime()
    if (ipr_c < (ipr_JLSTable.Cur[p] or 0)) then
        return
    end

    Ipr_SortNet(0, p, Ipr_JoinLeave_Sys.Config.Server.HideNotification_GameInit[1] and "4" or nil)
    ipr_JLSTable.Cur[p] = ipr_c + Ipr_JoinLeave_Sys.Config.Server.AntiSpam
end

local function Ipr_GameLeave(p)
    local ipr_c = CurTime()
    if (ipr_JLSTable.Cur[p]) and (ipr_c < ipr_JLSTable.Cur[p]) then
        return
    end

    local ipr_t, ipr_n = p:IsTimingOut() and 3 or 2, p:Nick()
    Ipr_SortNet(ipr_t, ipr_n, Ipr_JoinLeave_Sys.Config.Server.HideNotification_GameLeave[1] and "3" or nil)
    ipr_JLSTable.Cur[ipr_n] = nil
end

local function Ipr_GameConnect(data)
    local ipr_x = false
    
    if (Ipr_JoinLeave_Sys.Config.Server.BlockName[1]) then
        local ipr_n = data.name
        ipr_n = ipr_n:lower()
        local ipr_d = data.userid

        for d in pairs(ipr_JLSTable.Grp["1"]) do
            if string.find(ipr_n, d)  then
                timer.Simple(1, function()
                    if not player.GetByID(ipr_d) then
                        return
                    end
                    game.KickID(ipr_d, "Votre nom '" ..ipr_n.. "' ne respecte pas les règles du serveur." )
                    print("Le joueur '" ..ipr_n.. "' a été kické, car il ne respecte pas les noms autorisés sur le serveur.")
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
