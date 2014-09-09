local PreviousNickname, PN = ...;

PN.Event = CreateFrame("Frame")
PN.Event:RegisterEvent("PLAYER_TARGET_CHANGED")
PN.Event:SetScript("OnEvent", function()
	if UnitGUID("target") then
		PN.CheckPlayer()
	end
end)

PN.Alarm = function(prevname, name, prevrace, race, prevguild, guild)
	local msg = string.format("Игрок %s(%s)(%s) был бывшим %s(%s)(%s)", name, race, guild, prevname, prevrace, prevguild)
	PlaySoundFile("Sound\\Interface\\PlayerInviteA.wav")
	RaidNotice_AddMessage(RaidWarningFrame, msg, ChatTypeInfo["SAY"])
	print("|cffff5555[PN]|r "..msg)
end

PN.CheckPlayer = function()
	
	local GUID = UnitGUID("target")
	local name,_ = UnitName("target")
	local race,_ = UnitRace("target")
	
	if not(name) or not(race) or UnitIsGhost("target") then
		return
	end


		if UnitInRaid("player") then
			for i = 1, GetNumRaidMembers() do
				local i_name, _ = GetRaidRosterInfo(i);
				if i_name == name then
					if not(UnitInRange("target")) then
						return
					end
				end
			end
		elseif GetNumPartyMembers() > 0  then
			for i = 1, GetNumPartyMembers() do
				local i_name = UnitName("party" .. i)
				if i_name == name then
					if not(UnitInRange("target")) then
						return
					end
				end
			end
		end

	local realmName = GetRealmName()
	local realm_table = PreviousNicknameDB.realms[realmName]
	local n
	
	local weekday, month, day, year = CalendarGetDate();
	local my_date = string.format("|cff88ff88[%s/%s/%s]|r", month, day, year)
	local guildName, _, _ = GetGuildInfo("target");
	if not(guildName) or not(type(guildName)=='string') then guildName = "<без гильдии>" end
	
	if #realm_table > 0 then
		for i=1, #realm_table do
			if realm_table[i].GUID == GUID then
				n=i
				break
			end
		end
	end
	
	if not(n) then
		tinsert(realm_table, {GUID=GUID, history={{name=name, race=race, point=my_date, guildName=guildName}}})
	else
		local history_table = realm_table[n].history
		if #history_table > 0 then
			local i = #history_table
			if not(history_table[i].name == name) 
			or not(history_table[i].race == race) 
			or not(history_table[i].guildName == guildName) 
			then
				PN.Alarm(history_table[i].name, name, history_table[i].race, race, history_table[i].guildName, guildName)
				tinsert(history_table, {name=name, race=race, point=my_date, guildName=guildName})
			end
		end
	end
	
end

PN.ShowHistory = function(realmName, name)

		local realm_table = PreviousNicknameDB.realms[realmName]
		local n
		
	if not(name) or name=="" then
	
		local GUID = UnitGUID("target")
		if not(GUID) then
			print("|cffff5555[PN]|r ".."Ваша цель не определена")
			return
		end
		

		
		if #realm_table then
			if #realm_table > 0 then
				for i=1, #realm_table do
					if realm_table[i].GUID == GUID then
						n=i
						break
					end
				end
			end
		end
		

	else

		if #realm_table then
			if #realm_table > 0 then
				for i=1, #realm_table do
					if realm_table[i].history[#realm_table[i].history].name == name then
						n=i
						break
					end
				end
			end
		end

	end
	
		if not(n) then
			print("|cffff5555[PN]|r ".."Ваша цель не имеет истории")
		else
			print("|cffff5555[PN]|r ".."История игрока:")
			local history_table = realm_table[n].history
			for i=1, #history_table do
				local msg = string.format("%d. %s(%s)(%s) %s", i, history_table[i].name, history_table[i].race, history_table[i].guildName, history_table[i].point)
				print("|cffff5555[PN]|r "..msg)
			end
		end
end

PN.Reset = function(realmName)
	PreviousNicknameDB.realms[realmName] = {}
	print("|cffff5555[PN]|r ".."Reset PreviousNickname has occurred")
end

PN.OnLoad = function()

	if not(PreviousNicknameDB) or not(type(PreviousNicknameDB) == 'table') then
		PreviousNicknameDB = {}
	else
		if not(PreviousNicknameDB.verscheck == 1) then
			PreviousNicknameDB = {}
		end
	end
	
	if not(PreviousNicknameDB.realms) or not(type(PreviousNicknameDB.realms) == 'table') then
		PreviousNicknameDB.realms = {}
	end
	
	local realmName = GetRealmName()
	if not(PreviousNicknameDB.realms[realmName]) or not(type(PreviousNicknameDB.realms[realmName]) == 'table') then
		PreviousNicknameDB.realms[realmName] = {}
	end
	
	PreviousNicknameDB.verscheck = 1
	
	-- slash command
	SLASH_AddonPreviousNickname1 = "/PreviousNickname";
	SLASH_AddonPreviousNickname2 = "/PN";
	SlashCmdList["AddonPreviousNickname"] = function (msg)
		local x, y = msg:find(" ")
		local arg1, arg2
		if x and y then
			arg1 = strsub(msg, 1, x-1)
			arg2 = strsub(msg, y+1, strlen(msg))
		else
			arg1 = msg
		end
		PN.ShowHistory(realmName, arg1)
	end
	
	print("|cffff5555[PN]|r ".."PreviousNickname loaded")
end

PN.OnLoadFrame = CreateFrame("Frame")
PN.OnLoadFrame:RegisterEvent("ADDON_LOADED")
PN.OnLoadFrame:SetScript("OnEvent", function(this, event, arg1)
	if  (event == "ADDON_LOADED" and arg1 == "PreviousNickname") then
		this:UnregisterEvent("ADDON_LOADED")
		PN.OnLoad()
	end
end)

