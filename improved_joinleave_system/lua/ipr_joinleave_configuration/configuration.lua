-- // SCRIPT BY INJ3
-- // https://steamcommunity.com/id/Inj3/

ipr_JLS.Config.OptimizeDarkRP = true --- Optimisation de certaines fonctions du gamemode DarkRP (notification, log console, système de log journalier)

if (SERVER) then
    ipr_JLS.Config.Server = {
        HideNotification_GameInit = {
            false, --- Masquer la notification lorsque le joueur n'est pas encore complètement initialisé dans le serveur, seuls les groupes ci-dessous peuvent voir la notification.
            group = {
                "superadmin",
                "vip1",
            }
        },
        HideNotification_GameLoaded = {
            false, --- Masquer la notification lorsque le joueur a entièrement chargé et a rejoint le serveur.
            group = {
                "superadmin",
                "admin",
            }
        },
        HideNotification_GameLeave = {
            true, --- Masquer la notification lorsque le joueur quitte le serveur.
            group = {
                "superadmin",
            }
        },
        BlockName = {
            true, --- Bloquer le joueur qui porte un nom qui ne respecte pas les règles de votre serveur (kick).
            blacklist = {
                "discord.gg",
            }
        },

        AntiSpam = 7, --- Délai si le joueur tente de se connecter plusieurs fois dans les 5 secondes.
    }
else
    ipr_JLS.Config.Client = {
        NameServer = "VotreNomDeServeur", --- Nom de votre Serveur.
        ColorNameServer = Color(231, 76, 60), --- Couleur du texte (Nom serveur).
        ColorPlayerJoin = Color(236, 240, 241), --- Couleur Nom du joueur.
        
        {
            t = "a rejoint le serveur.",
            c = Color(231, 76, 60)
        },
        {
            t = "a fini le chargement.",
            c = Color(231, 76, 60)
        },
        {
            t = "quitte le serveur.",
            c = Color(231, 76, 60)
        },
        {
            t = "quitte le serveur. (Timed out)",
            c = Color(231, 76, 60)
        },
        {
            c = Color(255, 0, 0)
        },
    }
end
