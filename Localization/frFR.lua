if ( GetLocale() ~= "frFR" ) then return end

local addon, ns = ...
ns.L = {
	-- Core Globals
	["Combat Fade"] = "Cachez-vous dans bataille",
	["Class Colored"] = "Classe de couleur",
	["Global Font Size"] = "Mondial Taille de la police",
	["ProfDesc"] = "Cr�er un nouveau ou copier les profils existants. Profils par d�faut mis � caract�re.",
	["ProfResDesc"] = "Reset Profile",
	["ProfNew"] = "Nouveau",
	["ProfReset"] = "Reset",
	["ProfCurrent"] = "Courant",
	["ProfCopy"] = "Copie",
	["ProfDel"] = "Delete",
	["/sldt"] = "/sldt",
	["Command List"] = "Liste des commandes",
	["config"] = "config",
	["Toggle Configuration Mode"] = "Basculer le mode de configuration",
	["Configuration Mode"] = "Mode de configuration",
	["active"] = "Actif",
	["inactive"] = "Inactives",
	["global"] = "mondial",
	["Open SLDataText global menu"] = "Ouvrez le menu SLDataText mondiale",
	["<module>"] = "<module>",
	["Open Module Option Menu"] = "Ouvrir le menu Option module",
	["Loaded Modules"] = "Modules charg�s",
	["TTScale"] = "SLToolTip Scale",
	
	-- Common
	["Enabled"] = "Activ�",
	["Global Font"] = "Font mondiale",
	["Outline"] = "Aper�u",
	["Force Shown"] = "Voir dans bataille",
	["Tooltip On"] = "Sur Tooltip",
	["Show Tooltip (Combat)"] = "Show Tooltip (Combat)",
	["Font Size"] = "Taille de la police",
	["Font"] = "Type de police",
	["Justify"] = "Alignement du texte",
	["Parent"] = "Cadre parent",
	["Anchor"] = "D'ancrage",
	["X Offset"] = "X Alignement",
	["Y Offset"] = "Y Alignement",
	["Frame Strata"] = "Cadre strates",
	["Update Interval"] = "Mise � jour Fr�quence",
	["On"] = "Sur",
	["Off"] = "Off",
	["Prefix"] = "Pr�fixe",
	["Prefix Text"] = "Pr�fixe Texte",
	["Suffix"] = "Suffixe",
	["Suffix Text"] = "Suffixe Texte",
	["Left-Click"] = "Clic gauche",
	["Right-Click"] = "Faites un clic droit",
	["Show Icon"] = "Afficher l'ic�ne",
	["Show Text"] = "Afficher le texte",
	["Text Display"] = "Texte Affichage",
	
	-- Armor Module
	["Armor"] = "Armures",
	["All Items"] = "Tous les Articles",
	["Auto Repair"] = "Automatique R�paration",
	["Use Guild Bank"] = "Use Guild Bank",
	["AutoRepairLine"] = "Articles r�par� pour",
	["GFAutoRepairLine"] = "Articles r�par� pour (Guild Funds)",
	["ArmorTextDesc"] = "Tags for Text Display: [Dur] = Current Durability",
	
	-- Bag Module
	["Bag Info"] = "Sac Information",
	["Space Used"] = "Espace Utilis�",
	["Space Avail"] = "Espace Disponibles",
	["Space Left"] = "Espace Restantes",
	["AutoSell Junk"] = "Jonque automatique Vendre",
	["JunkSoldLine"] = "Jonque vendu a g�n�r�",
	["Toggle Bags"] = "Sacs Ouverts",
	["BagTextDesc"] = "Tags for Texte Affichage: [T] = Total, [R] = Remaining, [U] = Used",
	
	-- Clock Module
	["Toggle Calendar"] = "Ouvrez Calendrier",
	["Toggle Time Manager"] = "D�lai ouvert",
	["Queued for:"] = "En file d'attente pour:",
	["Realm Time"] = "Heure du Serveur",
	["24 Hour"] = "24 heures",
	["PvP Info"] = "PvP informaci�n",
	["Time String"] = "Time String",
	["ClockDesc"] = "Visit http://www.lua.org/pil/22.1.html for a full list of clock tags. Turn 'Correct Hour' option off if hour tag is not first in the time string.",
	["CorrHour"] = "Correct Hour",
	
	-- Coords Module
	["Precision"] = "Precisi�n",
	
	-- Currency Module
	["Currency"] = "Devises",
	["No currency"] = "Pas de devise",
	["Click to set display currency."] = "Cliquez d�finir la monnaie d'affichage.",
	["Display currency"] = "Affichage Devises",
	
	-- Exp Module
	["Max Level Hide"] = "Niveau max Cacher",
	["Exp"] = "Exp",
	["ExpTextDesc"] = "Tags for Text Display: [Cur] = Current XP, [Max] = Max XP, [Rem] = Remaining XP, [Per] = XP Percent, [PerR] = XP Remaining Percent, [R] = Rest XP, [RP] = Rest XP Percent",
	
	-- FPS Module
	["fps"] = "fps",
	["FPSTextDesc"] = "Tags for Text Display: [F] = Current FPS",
	
	-- Friends Module
	["Show Note"] = "Voir la note",
	["ClickDesc"] = "Cliquez ici pour envoyer dire.",
	["AltClickDesc"] = "Alt+Clic d'inviter.",
	["Show Icon"] = "Afficher l'ic�ne",
	["Friend List"] = "Amis List",
	["Friends"] = "Amis",
	["Friends Online"] = "Amis Online",
	["BNet Friends"] = "BNet Amis",
	["Note"] = "Note",
	["(AFK)"] = "(AFK)",
	["(DND)"] = "(DND)",
	
	-- Gold Module
	["Wallet"] = "Portefeuille",
	["Current"] = "Courant",
	["Session Start"] = "D�but de session",
	["Session Earned"] = "Earned cette session",
	["Server Gold"] = "L'argent du serveur",
	["Horde"] = "Horde",
	["Alliance"] = "Alliance",
	["Total Gold"] = "L'argent total",
	["Display Style"] = "Style D'affichage",
	["Alt Money"] = "Alt Argent",
	["ResetData"] = "Reset Data",
	
	-- Guild Module
	["Show Officer Note"] = "Voir la note officier",
	["No Guild"] = "Pas de Guild",
	["Guild"] = "Guilde",
	
	-- Latency Module
	["Latency"] = "Latency",
	["Bandwidth In"] = "Bandwidth In",
	["Bandwidth Out"] = "Bandwidth Out",
	["Latency (Home)"] = "Latency (Home)",
	["Latency (World)"] = "Latency (World)",
	["ms"] = "ms",
	["LagTextDesc"] = "Tags for Text Display: [L] = Current Latency",
	
	-- Mail Module
	["No Mail"] = "Pas de courrier",
	["Mail!"] = "Courrier!",
	["AH Alert!"] = "AH Alerte!",
	["Play Sounds"] = "Lire des sons",
	
	-- Memory Module
	["AddOn Memory"] = "m�moire AddOn",
	["Showing Top 15 AddOns"] = "Affichage Top 15 AddOns",
	["Total AddOn Memory"] = "M�moire totale AddOn",
	["Total UI Memory Usage"] = "Utilisation de la m�moire totale UI",
	["Hover"] = "Hover",
	["Show only top AddOns"] = "Show only top AddOns",
	["Alt+Hover"] = "Alt+Hover",
	["Show all AddOns"] = "Voir tous les AddOns",
	["Collect Garbage"] = "Ramasser les Ordures",
	["mb"] = "mb",
	["MemTextDesc"] = "Tags for Text Display: [MA] = Addon Memory, [MT] = Total Memory",
	
	-- Reputation Module
	["Reputation"] = "Reputation",
	["No Reputation"] = "No Reputation",
	["Click to set display reputation."] = "Click to set display reputation.",
	["Display Reputation"] = "Display Reputation",
	["Hated"] = "Hated",
	["Hostile"] = "Hostile",
	["Unfriendly"] = "Unfriendly",
	["Neutral"] = "Neutral",
	["Friendly"] = "Friendly",
	["Honored"] = "Honored",
	["Revered"] = "Revered",
	["Exalted"] = "Exalted",
}
