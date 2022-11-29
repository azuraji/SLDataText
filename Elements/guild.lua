 --[[ 		     SLDataText Module: Guild 				]]
--[[ Author: Taffu, azuraji	RevDate: 11/29/22	Version: 10.0.2.5	]]

-- Updated by Suicidal Katt
-- Class coloring returns in this version.
-- Player names are now using the Ambiguate function to remove realm info.
-- Guild Level now replaced with Guild Achievement Points as level was removed in patch 6.0.2
-- Guild Tab reference has been removed - 8.0.2

local addon, ns = ...
local SLDT, MODNAME, SLT, L = SLDataText, "Guild", LibStub("LibSLTip-1.0"), ns.L
if ( SLDT ) then SLDT.Guild = CreateFrame("Frame") end
local db, frame, text, tool, tip
local guildName, guildMotto, guildRank, guildPoints, guildList

local function SetupToolTip()
	if ( not IsInGuild() ) then return end
	tool:SetScript("OnEnter", function(this)
		C_GuildInfo.GuildRoster()
		SLDT.Guild:Refresh()
		tip = SLT:GetTooltip("SLDT_Guild", true)		
		SLT:AddHeader("SLDT_Guild", string.format("%s (%s)", guildName or L["No Guild"], guildPoints or ""), guildMotto)
		if select(2, GetNumGuildMembers()) >= 2 then
			for key, val in pairs(guildList) do
				local name, rank, level, class, zone, status, isMobile, note, oNote = val[1], val[2], val[3], val[4], val[5], val[6], val[7], val[8], val[9]
			
				if ( name ~= UnitName("player") ) then
					local cCol = string.format("%02X%02X%02X", RAID_CLASS_COLORS[class].r*255, RAID_CLASS_COLORS[class].g*255, RAID_CLASS_COLORS[class].b*255)
					local lineL = string.format("%s |cff%s%s|r %s", level, cCol, name, status or "")
					local lineR = string.format("%s%s", isMobile and "|cffffff00[M]|r " or "", zone or "")
				
					local buttonFunc = function(self, button)
						if ( IsAltKeyDown() ) then
							InviteUnit(name)
						else
							SetItemRef("player:"..name, "|Hplayer:"..name.."|h["..name.."|h", "LeftButton")
						end
					end
				
					SLT:AddDoubleLine("SLDT_Guild", lineL, lineR, nil, nil, true, buttonFunc)
					if ( note and note ~= "" and db.showNote ) then
						local noteLine = string.format(" - Note: %s", note)
						SLT:AddLine("SLDT_Guild", noteLine, nil)
					end
					if ( oNote and oNote ~= "" and db.showONote ) then
						local noteLine = string.format(" - Officer: %s", oNote)
						SLT:AddLine("SLDT_Guild", noteLine, nil)
					end
				else
					
				end
			end
		end
		
		SLT:AddFooter("SLDT_Guild", L["ClickDesc"], nil)
		SLT:AddFooter("SLDT_Guild", L["AltClickDesc"], nil)
		
		if ( not db.showTTCombat and select(2, GetNumGuildMembers()) > 1 ) then
			if ( not InCombatLockdown() ) then SLT:ShowTooltip("SLDT_Guild", frame) end
		else
			SLT:ShowTooltip("SLDT_Guild", frame)
		end
	end)
	tool:SetScript("OnLeave", function(this) SLT:ClearTooltip("SLDT_Guild") end)
	tool:SetScript("OnMouseDown", function(this, button)
		ToggleGuildFrame()
		--[[if ( IsInGuild() ) then
			GuildFrameTab2:Click()
		end]]--
	end)
end

local int = 10
function SLDT.Guild:RefreshTimer()
	self:SetScript("OnUpdate", function(self, elapsed)
		int = int - elapsed
		if ( int <= 0 ) then
			int = 10; self:Refresh()
			self:SetScript("OnUpdate", nil)
		end
	end)
end

function SLDT.Guild:Enable()
	if ( db.enabled ) then
		self:RegisterEvent("GUILD_ROSTER_UPDATE")
		self:RegisterEvent("GUILD_TRADESKILL_UPDATE")
		self:RegisterEvent("GUILD_MOTD")
		self:RegisterEvent("GUILD_NEWS_UPDATE")
		self:RegisterEvent("PLAYER_GUILD_UPDATE")
	end
	self:Refresh()
end

function SLDT.Guild:Disable()
	if ( not db.enabled ) then
		self:UnregisterEvent("GUILD_ROSTER_UPDATE")
		self:UnregisterEvent("GUILD_TRADESKILL_UPDATE")
		self:UnregisterEvent("GUILD_MOTD")
		self:UnregisterEvent("GUILD_NEWS_UPDATE")
		self:UnregisterEvent("PLAYER_GUILD_UPDATE")
	end
	self:Refresh()
end

function SLDT.Guild:Refresh()
	if ( db.enabled or SLDataText.db.profile.configMode ) then
		if ( not self.firstRun ) then self.firstRun = true; SLDT:UpdateBaseText(self, db) end
		
		if ( IsInGuild() ) then
			guildList = {}
			guildName, guildRank, _ = GetGuildInfo("player")
			guildMotto, guildPoints = GetGuildRosterMOTD(), GetTotalAchievementPoints(true)
			
			for i = 0, select(1, GetNumGuildMembers()) do
				local name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName, achievementPoints, achievementRank, isMobile, canSoR = GetGuildRosterInfo(i)
				if ( online ) then
					if ( status ~= nil and status == 0 ) then status = nil else status = L["(AFK)"] end
					table.insert(guildList, { Ambiguate(name, "guild"), rank, level, classFileName, zone, status, isMobile, note, officernote })
				end
			end
			
			local txstr
			if ( UnitFactionGroup("player") == "Alliance" ) then
				txstr = string.format("|T%s:0|t ", "Interface\\Icons\\Inv_bannerpvp_02")
			else
				txstr = string.format("|T%s:0|t ", "Interface\\Icons\\Inv_bannerpvp_01")
			end
			text:SetFormattedText("%s|cff%s%s:|r %s", db.showIcon and txstr or "", SLDT.db.profile.cCol and SLDT.classColor or "ffffff", L["Guild"], select(2, GetNumGuildMembers()))
		else
			text:SetText(L["No Guild"])
		end
		
		SLDT:UpdateBaseFrame(SLDT.Guild, db)
	else
		if ( frame:IsShown() and not SLDataText.db.profile.configMode ) then frame:Hide() end
	end
end

SLDT.Guild.optsTbl = {
	[1] = { [1] = "toggle", [2] = L["Enabled"], [3] = "enabled" },
	[2] = { [1] = "toggle", [2] = L["Global Font"], [3] = "gfont" },
	[3] = { [1] = "toggle", [2] = L["Outline"], [3] = "outline" },
	[4] = { [1] = "toggle", [2] = L["Force Shown"], [3] = "forceShow" },
	[5] = { [1] = "toggle", [2] = L["Tooltip On"], [3] = "tooltipOn" },
	[6] = { [1] = "toggle", [2] = L["Show Tooltip (Combat)"], [3] = "showTTCombat" },
	[7] = { [1] = "toggle", [2] = L["Show Icon"], [3] = "showIcon" },
	[8] = { [1] = "toggle", [2] = L["Show Note"], [3] = "showNote" },
	[9] = { [1] = "toggle", [2] = L["Show Officer Note"], [3] = "showONote" },
	[10] = { [1] = "range", [2] = L["Font Size"], [3] = "fontSize", [4] = 6, [5] = 40, [6] = 1 },
	[11] = { [1] = "select", [2] = L["Font"], [3] = "font", [4] = SLDT.fontTbl },
	[12] = { [1] = "select", [2] = L["Justify"], [3] = "aP", [4] = SLDT.justTbl },
	[13] = { [1] = "text", [2] = L["Parent"], [3] = "anch" },
	[14] = { [1] = "select", [2] = L["Anchor"], [3] = "aF", [4] = SLDT.anchTbl },
	[15] = { [1] = "text", [2] = L["X Offset"], [3] = "xOff" },
	[16] = { [1] = "text", [2] = L["Y Offset"], [3] = "yOff" },
	[17] = { [1] = "select", [2] = L["Frame Strata"], [3] = "strata", [4] = SLDT.stratTbl },
}

local function OnInit()
	SLDT.Guild.db = SLDT.db:RegisterNamespace(MODNAME)
    SLDT.Guild.db:RegisterDefaults({
        profile = {
			name = "Guild",
			enabled = true,
			showNote = false,
			showONote = false,
			showTTCombat = false,
			aP = "CENTER",
			anch = "UIParent",
			aF = "BOTTOMLEFT",
			xOff = 88,
			yOff = 7,
			strata = "LOW",
			gfont = false,
			fontSize = 14,
			font = "Arial Narrow",
			outline = false,
			tooltipOn = true,
			forceShow = false,
			showIcon = true,
        },
    })
	db = SLDT.Guild.db.profile
	
	SLDT:AddModule(MODNAME, db)
	frame, text, tool = SLDT:SetupBaseFrame(SLDT.Guild)
	SetupToolTip()
	
	SLDT.Guild:UnregisterEvent("PLAYER_ENTERING_WORLD")
	SLDT.Guild:SetScript("OnEvent", function() SLDT.Guild:Refresh() end)
	SLDT.Guild:Enable()	
end

if ( IsAddOnLoaded("SLDataText") ) then
	SLDT.Guild:RegisterEvent("PLAYER_ENTERING_WORLD")
	SLDT.Guild:SetScript("OnEvent", OnInit)
end
