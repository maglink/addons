local FirstStrike, FS = ...;

FS.now_table = {}

FS.COMBAT_LOG = CreateFrame("Frame")
FS.COMBAT_LOG:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
FS.COMBAT_LOG:SetScript("OnEvent", function(...)
	local instname, typeinst, difficultyIndex, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, mapID = GetInstanceInfo()
	if instancetype == "raid" or instancetype == "party" then
		local tbl = {}
		tbl.self, tbl.fevent,  tbl.timestamp, tbl.event, tbl.sourceGUID, tbl.sourceName, tbl.sourceFlags, 
		tbl.destGUID, tbl.destName, tbl.destFlags, tbl.spellID, tbl.spellName = ...;
		if UnitPlayerOrPetInParty(tbl.sourceName) or UnitPlayerOrPetInRaid(tbl.sourceName) then
			if FS.now_table[tbl.destGUID] then return end
			if tbl.event:find("_DAMAGE") 
			or tbl.event:find("_MISSED") 
			or tbl.event:find("_DISPEL")	
			or tbl.event:find("_STOLEN")
			or tbl.event:find("_INTERRUPT")
			then
				FS.now_table[tbl.destGUID] = 1
				tinsert(FirstStrikeDB.db, 	{
					checktime = tbl.timestamp,
					instname = instname .. " " .. difficultyName,
					destName = tbl.destName, 
					timestring = date("%H:%M:%S", tbl.timestamp),
					nickname = tbl.sourceName,
					class = select(2, UnitClass(tbl.sourceName))
				})
				if FirstStrikeListFrame:IsVisible() then
					FS.ShowList()
				end
			end
		end
	end
end)

FS.MaxFrames = 0

FS.Event = CreateFrame("Frame")
FS.Event:RegisterEvent("ADDON_LOADED")
FS.Event:SetScript("OnEvent", function(self, event)
	if event == "ADDON_LOADED" then
		self:UnregisterEvent("ADDON_LOADED")
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		FS.OnLoad()
	end	
	if event == "PLAYER_REGEN_ENABLED" then
		FS.now_table = {}
	end	
end)


FS.AddItem = function(i, parent)
	local height = 16
	FS.MaxFrames = FS.MaxFrames + 1
	local f = CreateFrame("Button", parent:GetName().."Line"..i, parent, parent:GetName().."TextButtonTemplate")
	if i>1 then
		f:SetPoint("TOPLEFT", getglobal(parent:GetName().."Line"..(i-1)), "BOTTOMLEFT", 0, 0)
		f:SetPoint("BOTTOMRIGHT", getglobal(parent:GetName().."Line"..(i-1)), "BOTTOMRIGHT", 0, -height)
	else
		f:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -height*(i-1))
		f:SetPoint("BOTTOMRIGHT", parent, "TOPRIGHT", 0, -height*(i-1)-height)
	end	
end

function FirstStrike_funcgetcolor(class)
	local r, g, b = 0.63, 0.63, 0.63
	------------------
    	if _G.CUSTOM_CLASS_COLORS and _G.CUSTOM_CLASS_COLORS[class] then
       		r, g, b = _G.CUSTOM_CLASS_COLORS[class].r, _G.CUSTOM_CLASS_COLORS[class].g, _G.CUSTOM_CLASS_COLORS[class].b
    	end
	if _G.RAID_CLASS_COLORS and _G.RAID_CLASS_COLORS[class] then
		r, g, b = _G.RAID_CLASS_COLORS[class].r, _G.RAID_CLASS_COLORS[class].g, _G.RAID_CLASS_COLORS[class].b
	end
	return string.format("%02x%02x%02x",r*255,g*255,b*255)
end

FS.ShowList = function()
	FirstStrikeListFrame:Show()
	local tmplt = "FirstStrikeListFrameScrollFrameScrollChildTextButtonTemplate"
	local parent = FirstStrikeListFrameScrollFrameScrollChild
	local listframe = FirstStrikeListFrame
	
	for i=1, FS.MaxFrames do
		getglobal(parent:GetName().."Line"..i):Hide()
	end
	
	table.sort(FirstStrikeDB.db, function(a,b)
		return a.checktime > b.checktime
	end)
	
	local max= 50
	local s_table = FirstStrikeDB.db
	FirstStrikeDB.db = {}
	if max > #s_table then 
		max = #s_table
	end
	for i=1, max do
		if i > FS.MaxFrames then
			FS.AddItem(i, parent)
		end
		tinsert(FirstStrikeDB.db, s_table[i])
		
		local destName, instname, timestring, nickname, class = 
		s_table[i].destName,
		s_table[i].instname,
		s_table[i].timestring,
		s_table[i].nickname,
		s_table[i].class
		
		local color = "|cff"..FirstStrike_funcgetcolor(class)
		
		getglobal(parent:GetName().."Line"..i.."L"):SetText(destName)
		getglobal(parent:GetName().."Line"..i.."C"):SetText(color..nickname)
		getglobal(parent:GetName().."Line"..i.."C2"):SetText(instname)
		getglobal(parent:GetName().."Line"..i.."R"):SetText(timestring)
		
		getglobal(parent:GetName().."Line"..i.."Send"):SetScript("OnClick", function()
			local msg = "В %s юнита \"%s\" сагрил игрок/петомец \"%s\""
			msg = string.format(msg, timestring, destName, nickname)
			if UnitInRaid("player") then
				SendChatMessage(msg, string.upper("Raid"))
			elseif GetNumPartyMembers() > 0 then
				SendChatMessage(msg, string.upper("Party"))
			else
				print(msg)
			end
		end)

		getglobal(parent:GetName().."Line"..i):Show()
	end
	s_table={}
	
end

FirstStrike_HideList = function()
	FirstStrikeListFrame:Hide()
end

FS.OnLoad = function()

	if type(FirstStrikeDB) ~= 'table' then
		FirstStrikeDB = {}
	end
	if type(FirstStrikeDB.db) ~= 'table' then
		FirstStrikeDB.db = {}
	end
	
		-- slash command
	SLASH_FirstStrike1 = "/FirstStrike";
	SLASH_FirstStrike2 = "/fs";
	SlashCmdList["FirstStrike"] = function ()
			FS.ShowList()
	end
	FirstStrikeListFrameScrollFrameScrollChild:SetWidth(FirstStrikeListFrame:GetWidth()-55)
end
