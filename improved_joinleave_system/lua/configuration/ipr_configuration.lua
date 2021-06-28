--- Script By Inj3 
--- Script By Inj3 
--- Script By Inj3 
--- // https://steamcommunity.com/id/Inj3/
--- // Improved Join/Leave System
ImprovedJoinLeaveSys = ImprovedJoinLeaveSys or {}

if SERVER then
     ImprovedJoinLeaveSys.AntiSpam = 10 --- Délai si le joueur tente de se connecter plusieurs fois dans les 10 secondes.

     ImprovedJoinLeaveSys.BlockName = { --- Bloquer le joueur qui porte un nom qui ne respect pas les règles de votre serveur (Kick).
          "discord.gg",
          --"bot",
     }

else
     ImprovedJoinLeaveSys.HideLeavePlayer = { --- Cacher la notification quand les joueurs quitte le serveur, seuls les groupes ci-dessous peuvent la voir.
          ["Enable/Disable"] = true, --- Activer = true / Désactiver = false.
          ["Group"] = { --- Indiquer vos groupes :
               ["superadmin"] = true,
          }
     }

     ImprovedJoinLeaveSys.JoinLeaveTbl = { --- Phrase lorsque le joueur se connect/termine le chargement/quitte le serveur.
          ["NameServer"] = "CentralCity", --- Nom de votre Serveur.
          ["ColorNameServer"] = Color(231, 76, 60), --- Couleur du texte (Nom serveur).

          ["ColorPlayerJoin"] = Color(236, 240, 241), --- Couleur Nom du joueur.

          [1] = {
               Texte = "a rejoint le serveur.",
               Color = Color(231, 76, 60)
          },
          [2] = {
               Texte = "a fini le chargement.",
               Color = Color(231, 76, 60)
          },
          [3] = {
               Texte = "quitte le serveur.",
               Color = Color(231, 76, 60)
          }
     }

end