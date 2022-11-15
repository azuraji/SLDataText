--[[ 		    SLDataText Module: Friends 				]]
--[[ Author: Taffu  RevDate: 08/02/2018  Version: 8.0.2 ]]

-- Updated by Suicidal Katt
-- Fixed an issue with on click functions not closing the tooltip.
-- "InviteUnit" function calls need to be redone.


local addon, ns = ...
local SLDT, MODNAME, SLT, L = SLDataText, "Friends", LibStub("LibSLTip-1.0"), ns.L
if ( SLDT ) then SLDT.Friends = CreateFrame("Frame") end
local db, frame, text, tool, tip
local friendList, BNetList, friendsOn = {}, {}, 0

local function SetupToolTip()
	tool:SetScript("OnEnter", function(this)
		tip = SLT:GetTooltip("SLDT_Friends", true)		
		SLT:AddHeader("SLDT_Friends", L["Friend List"], string.format("%s: %i", L["Friends Online"], friendsOn))
		for k, v in pairs(friendList) do
			local name, lvl, class, area, status, note = v[1], v[2], v[3], v[4], v[5], v[6]
			--NOTE: Editing this out until Blizz lets classFileName become available @ Friend API level
			--if ( class and class == "Death Knight" ) then class = "DEATHKNIGHT" else class = string.upper(class) end
			--local cCol = string.format("%02X%02X%02X", RAID_CLASS_COLORS[class].r*255, RAID_CLASS_COLORS[class].g*255, RAID_CLASS_COLORS[class].b*255)
			local lineL = string.format("%s %s %s", lvl, name, status or "")
			local lineR = string.format("%s", area or "")
			
			local buttonFunc = function(self, button)
				if ( IsAltKeyDown() ) then
					InviteUnit(name)
				else
					SetItemRef("player:"..name, "|Hplayer:"..name.."|h["..name.."|h", "LeftButton")
				end
				SLT:ClearTooltip("SLDT_Friends")
			end
			
			SLT:AddDoubleLine("SLDT_Friends", lineL, lineR, nil, nil, true, buttonFunc)
			if ( note and db.showNote ) then
				local noteLine = string.format(" - %s: %s", L["Note"], note)
				SLT:AddLine("SLDT_Friends", noteLine, nil)
			end
		end
		
		if ( select("#", BNetList) >= 1 and select("#", friendList) >= 1 ) then
			SLT:AddLine("SLDT_Friends", L["BNet Friends"])
			SLT:AddSpacer("SLDT_Friends")
		end
		
		if ( BNetList and select("#", BNetList) >= 1 ) then
			for k, v in pairs(BNetList) do
				local BNid, BNname, battleTag, toonname, client, status, broadcast, note = v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8]

				local lineL = string.format("|cffecd672%s|r", BNname, battleTag, toonname)
				local lineR = string.format("%s%s", status or "", client or "")
				
				local buttonFunc = function(self, button)
					if ( IsAltKeyDown() ) then
						if ( client == "WoW" ) then InviteUnit(toonname) end
					else
						local nameLine = string.format("%s : %s", BNname, BNid)
						SetItemRef("BNplayer:"..nameLine, "|Hplayer:"..nameLine.."|h["..nameLine.."|h", "LeftButton")
					end
					SLT:ClearTooltip("SLDT_Friends")
				end
				
				SLT:AddDoubleLine("SLDT_Friends", lineL, lineR, nil, nil, true, buttonFunc)
				if ( note and db.showNote ) then
					local noteLine = string.format(" - Note: %s", note)
					SLT:AddLine("SLDT_Friends", noteLine, nil)
				end
			end
		end
		
		SLT:AddFooter("SLDT_Friends", L["ClickDesc"], nil)
		SLT:AddFooter("SLDT_Friends", L["AltClickDesc"], nil)
		if ( friendsOn > 0 and not InCombatLockdown() ) then SLT:ShowTooltip("SLDT_Friends", frame) end
	end)
	tool:SetScript("OnLeave", function(this) SLT:ClearTooltip("SLDT_Friends") end)
	tool:SetScript("OnMouseDown", function(this, button)
		ToggleFriendsFrame(1)
	end)
end

function SLDT.Friends:Enable()
	if ( db.enabled ) then
		self:RegisterEvent("FRIENDLIST_UPDATE")
		self:RegisterEvent("BN_FRIEND_ACCOUNT_ONLINE")
		self:RegisterEvent("BN_FRIEND_ACCOUNT_OFFLINE")
		self:SetScript("OnEvent", function() self:Refresh() end)
	end
	self:Refresh()
end

function SLDT.Friends:Disable()
	if ( not db.enabled ) then
		self:UnregisterEvent("FRIENDLIST_UPDATE")
		self:UnregisterEvent("BN_FRIEND_ACCOUNT_ONLINE")
		self:UnregisterEvent("BN_FRIEND_ACCOUNT_OFFLINE")
	end
	self:Refresh()
end

function SLDT.Friends:Refresh()
	if ( db.enabled or SLDataText.db.profile.configMode ) then
		if ( not self.firstRun ) then self.firstRun = true; SLDT:UpdateBaseText(self, db) end
		
		friendList, BNetList, friendsOn = {}, {}, 0
		for i = 1, C_FriendList.GetNumFriends() do
			local name, lvl, class, area, online, status, note = C_FriendList.GetFriendInfoByIndex(i)
			if ( online ) then
				friendsOn = friendsOn + 1
				friendList = friendList or {}
				table.insert(friendList, { name, lvl, class, area, status, note })
			end
		end
		
		for j = 1, BNGetNumFriends() do
			local friendAccountInfo = C_BattleNet.GetFriendAccountInfo(j)
			local battleTag = friendAccountInfo.battleTag

			if (friendAccountInfo.gameAccountInfo.isOnline) then
				-- local _,name, _, realmName, _, faction, race, class, guild, area, lvl = BNGetToonInfo(toonid)
				friendsOn = friendsOn + 1
				if (not battleTag) then battleTag = "[noTag]" end
				friendList = friendList or {}
				local status = ""
				if (friendAccountInfo.isAFK) then status = L["(AFK)"] end; if ( friendAccountInfo.isDND ) then status = L["(DND)"] end
				-- table.insert(BNetList, { BNid, BNname, battleTag, toonname, client, status, broadcast, note })
				table.insert(BNetList, { friendAccountInfo.bnetAccountID, friendAccountInfo.accountName, battleTag, friendAccountInfo.gameAccountInfo.characterName, friendAccountInfo.gameAccountInfo.clientProgram, status, friendAccountInfo.customMessage, friendAccountInfo.note })
			end
		end
		
		local txstr = string.format("|T%s:0|t ", "Interface\\Icons\\Inv_cask_04")
		text:SetFormattedText("%s|cff%s%s:|r %s", db.showIcon and txstr or "", SLDT.db.profile.cCol and SLDT.classColor or "ffffff", L["Friends"], friendsOn)
		SLDT:UpdateBaseFrame(self, db)
	else
		if ( frame:IsShown() and not SLDataText.db.profile.configMode ) then frame:Hide() end
	end
end

SLDT.Friends.optsTbl = {
	[1] = { [1] = "toggle", [2] = L["Enabled"], [3] = "enabled" },
	[2] = { [1] = "toggle", [2] = L["Global Font"], [3] = "gfont" },
	[3] = { [1] = "toggle", [2] = L["Outline"], [3] = "outline" },
	[4] = { [1] = "toggle", [2] = L["Force Shown"], [3] = "forceShow" },
	[5] = { [1] = "toggle", [2] = L["Tooltip On"], [3] = "tooltipOn" },
	[6] = { [1] = "toggle", [2] = L["Show Icon"], [3] = "showIcon" },
	[7] = { [1] = "toggle", [2] = L["Show Note"], [3] = "showNote" },
	[8] = { [1] = "range", [2] = L["Font Size"], [3] = "fontSize", [4] = 6, [5] = 40, [6] = 1 },
	[9] = { [1] = "select", [2] = L["Font"], [3] = "font", [4] = SLDT.fontTbl },
	[10] = { [1] = "select", [2] = L["Justify"], [3] = "aP", [4] = SLDT.justTbl },
	[11] = { [1] = "text", [2] = L["Parent"], [3] = "anch" },
	[12] = { [1] = "select", [2] = L["Anchor"], [3] = "aF", [4] = SLDT.anchTbl },
	[13] = { [1] = "text", [2] = L["X Offset"], [3] = "xOff" },
	[14] = { [1] = "text", [2] = L["Y Offset"], [3] = "yOff" },
	[15] = { [1] = "select", [2] = L["Frame Strata"], [3] = "strata", [4] = SLDT.stratTbl },
}

local function OnInit()
	SLDT.Friends.db = SLDT.db:RegisterNamespace(MODNAME)
    SLDT.Friends.db:RegisterDefaults({
        profile = {
			name = "Friends",
			enabled = true,
			showNote = false,
			aP = "CENTER",
			anch = "UIParent",
			aF = "BOTTOMLEFT",
			xOff = 189,
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
	db = SLDT.Friends.db.profile
	
	SLDT:AddModule(MODNAME, db)
	frame, text, tool = SLDT:SetupBaseFrame(SLDT.Friends)
	SetupToolTip()
	
	SLDT.Friends:UnregisterEvent("PLAYER_ENTERING_WORLD")
	SLDT.Friends:Enable()	
end

if ( IsAddOnLoaded("SLDataText") ) then
	SLDT.Friends:RegisterEvent("PLAYER_ENTERING_WORLD")
	SLDT.Friends:SetScript("OnEvent", OnInit)
end