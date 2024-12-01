--- Script By Inj3 
--- Script By Inj3 
--- Script By Inj3 
--- // https://steamcommunity.com/id/Inj3/
--- // Improved Join/Leave System
--- Activer = true / Désactiver = false

Ipr_JoinLeave_Sys.Config.OptimizeDarkrp = true --- Optimisation de certaines fonctions du gamemode DarkRP (notification, log console, système de log journalier)

if (SERVER) then
    Ipr_JoinLeave_Sys.Config.Server = {
        HideNotification_GameLoaded = {false, --- Masquer la notification lorsque le joueur a entièrement chargé et a rejoint le serveur, seuls les groupes ci-dessous peuvent la voir.
            group = {
                "superadmin",
                "vip1",
            }
        },
        HideNotification_GameLeave = {true, --- Masquer la notification lorsque le joueur quitte le serveur, seuls les groupes ci-dessous peuvent la voir.
            group = {
               "superadmin",
               "vip1",
            }
        },

        HideNotification_GameInit = false, --- Masquer la notification lorsque le joueur n'est pas encore complètement initialisé dans le serveur.
        AntiSpam = 5, --- Délai si le joueur tente de se connecter plusieurs fois dans les 5 secondes.
        BlockName = { --- Bloquer le joueur qui porte un nom qui ne respecte pas les règles de votre serveur (kick).
            "discord.gg",
        --"bot", Exemple
        }
    }
else
    Ipr_JoinLeave_Sys.Config.Client = {
        NameServer = "VotreNomDeServeur", --- Nom de votre Serveur.
        ColorNameServer = Color(231, 76, 60), --- Couleur du texte (Nom serveur).
        ColorPlayerJoin = Color(236, 240, 241), --- Couleur Nom du joueur.
        {
            Texte = "a rejoint le serveur.",
            Color = Color(231, 76, 60)
        },
        {
            Texte = "a fini le chargement.",
            Color = Color(231, 76, 60)
        },
        {
            Texte = "quitte le serveur.",
            Color = Color(231, 76, 60)
        },
        {
            Texte = "quitte le serveur. (Timed out)",
            Color = Color(231, 76, 60)
        }
    }
end