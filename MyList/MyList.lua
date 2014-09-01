local MyList, ML = ...;

ML.Event = CreateFrame("Frame")
ML.Event:RegisterEvent("PARTY_MEMBERS_CHANGED")
ML.Event:SetScript("OnEvent", function()
	if GetNumRaidMembers() > 0 then
		for i = 1, GetNumRaidMembers() do
			local playername, _, _, _, _, _, _, _, _, _, _ = GetRaidRosterInfo(i)
			ML.CheckPlayer(playername)
		end
	elseif GetNumPartyMembers() > 0 then
		for i = 1, GetNumPartyMembers() do
			ML.CheckPlayer(UnitName("party" .. i))
		end
	else
		ML.NowPlayers = {}
	end
end)

ML.Alarm = function(name)
	local msg = name.." in MyList"
	PlaySoundFile("Sound\\Interface\\PlayerInviteA.wav")
	RaidNotice_AddMessage(RaidWarningFrame, msg, ChatTypeInfo["SAY"])
end

ML.CheckPlayer = function(name)
	local f = true
	if #ML.NowPlayers > 0 then
		for i=1, #ML.NowPlayers do
			if ML.NowPlayers[i] == name then
				f=false
				break
			end
		end
	end
	if f then
		tinsert(ML.NowPlayers, name)
		for i=1, #MyListDB do
			if MyListDB[i] == name or MyListDB[i] == name:lower() then
				ML.Alarm(name)
				break
			end
		end
	end
end

ML.Insert = function(name)
	tinsert(MyListDB, name)
	print(name.." has been added to MyList")
end

ML.Remove = function(name)
	for i=1, #MyListDB do
		if MyListDB[i] == name then
			tremove(MyListDB, i)
			print(name.." has been removed from MyList")
			break
		end
	end
end

ML.Print = function()
	print("MyList:")
	for i=1, #MyListDB do
		print(MyListDB[i])
	end
end

ML.Reset = function()
	MyListDB = {}
	ML.NowPlayers = {}
	print("Reset MyList has occurred")
end

ML.OnLoad = function()

	print("MyList loaded")
	
	if not(MyListDB) or not(type(MyListDB) == 'table') then
		MyListDB = {}
	end

	ML.NowPlayers = {}
	
	-- slash command
	SLASH_AddonMyList1 = "/MyList";
	SLASH_AddonMyList2 = "/ml";
	SlashCmdList["AddonMyList"] = function (msg)
		local x, y = msg:find(" ")
		local arg1, arg2
		if x and y then
			arg1 = strsub(msg, 1, x-1)
			arg2 = strsub(msg, y+1, strlen(msg))
		else
			arg1 = msg
		end
		if arg1 == "insert" or arg1 == "add" then
			if arg2 then ML.Insert(arg2) end
		elseif arg1 == "remove" or arg1 == "delete" then
			if arg2 then ML.Remove(arg2) end
		elseif arg1 == "print" or arg1 == "list" then
			ML.Print()
		elseif arg1 == "clear" or arg1 == "reset" then
			ML.Reset()
		end
	end

end

ML.OnLoad()
