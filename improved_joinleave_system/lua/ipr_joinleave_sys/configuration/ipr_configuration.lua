--- Script By Inj3 
--- Script By Inj3 
--- Script By Inj3 
--- // https://steamcommunity.com/id/Inj3/
--- // Improved Join/Leave System

Ipr_JoinLeave_Sys.Config.OptimizeDarkrp = true --- Optimize some darkrp gamemode functions (notification, log console, système de log journalier, logging)

if (SERVER) then
    Ipr_JoinLeave_Sys.Config.Server = {
            --- Configuration serveur.
            AntiSpam = 5, --- Délai si le joueur tente de se connecter plusieurs fois dans les 5 secondes.
            BlockName = { --- Bloquer le joueur qui porte un nom qui ne respect pas les règles de votre serveur (Kick).
                 "discord.gg",
                 --"bot", Exemple
            }
    }
else
    Ipr_JoinLeave_Sys.Config.Client = {
            --- Cacher la notification quand les joueurs quitte le serveur, seuls les groupes ci-dessous peuvent la voir.
            ScriptEnabled = true, --- Activer = true / Désactiver = false.
            Group = { --- Indiquer vos groupes :
                ["superadmin"] = true,
            },

            --- Phrase lorsque le joueur se connect/termine le chargement/quitte le serveur.
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
