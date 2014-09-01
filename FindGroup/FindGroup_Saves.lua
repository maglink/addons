local SPACE_NAME = FGL.SPACE_NAME
local LGT = LibStub("LibGroupTalents-1.0")

local maxframes = 0
local players_maxframes = 0
local parrentframe
local players_parrentframe
local name_boss
local global_id
local global_i
local global_names={}
local global_mails={}
local mail_interval = 3
local mail_last_elapsed = 0
local online_timeleft = 0
local check_chan_elaps = 0
local online_period = 15
local player_donthave_invite = 0
local saveplayers_elapsed = 0
local saveplayers_maxelapsed = 15
local headtext = "Сохраненные подземелья"
local saves_delete_char_name, saves_delete_char_id;
local color_online = {r=1, g=0.87, b=0, a=0.6}
local color_online_friend = {r=0.4, g=1, b=0, a=0.5}
local color_online_ignore = {r=0.9, g=0.1, b=0.1, a=0.5}
local color_offline = {r=0.3, g=0.3, b=0.3, a=0.6}
local color_offline_friend = {r=0.4, g=1, b=0.1, a=0.15}
local color_offline_ignore = {r=0.3, g=0.1, b=0.1, a=0.3}
local savingevent = CreateFrame("Frame")
local bossevent = CreateFrame("Frame")
local bosseventyell = CreateFrame("Frame")
local memberschanged = CreateFrame("Frame")
local updateframe = CreateFrame("Frame")
local print_name = FGL.CharName
local nextchars = nil
local PlAYER_ONLINE_MENU
local last_locate_check={}
local AceGUI = LibStub("AceGUI-3.0")
local eventlist = {
"FRIENDLIST_UPDATE",
}

function FGC_set_print_name(name)
	print_name = name
end

function FGC_get_print_name()
	return print_name
end

local sort_variants = 
{
	{
		function(a, b) return string.lower(a.name) > string.lower(b.name) end, 
		function(a, b) return string.lower(a.name) < string.lower(b.name) end,
	},
	{
		function(a, b) 
			if tonumber(string.sub(a.diffname, 1, 2)) == tonumber(string.sub(b.diffname, 1, 2)) then
				return string.lower(a.diffname) > string.lower(b.diffname)
			else
				return tonumber(string.sub(a.diffname, 1, 2)) > tonumber(string.sub(b.diffname, 1, 2))
			end
		end, 
		function(a, b) 
			if tonumber(string.sub(a.diffname, 1, 2)) == tonumber(string.sub(b.diffname, 1, 2)) then
				return string.lower(a.diffname) < string.lower(b.diffname)
			else
				return tonumber(string.sub(a.diffname, 1, 2)) < tonumber(string.sub(b.diffname, 1, 2))
			end
		end, 
	},
	{
		function(a, b) return a.timeleft > b.timeleft end,
		function(a, b) return a.timeleft < b.timeleft end,
	},
	{
		function(a, b) return tonumber(a.id) > tonumber(b.id) end, 
		function(a, b) return tonumber(a.id) < tonumber(b.id) end,
	},
}

local notABoss = {
      [37025] = true, -- Вонючка
      [37217] = true, -- Прелесть

	-- скелеты у вали
      [37868] = true, 
      [37886] = true, 
      [37934] = true,
      [36791] = true,
   }

local ABoss = {
	-- PC
      [39751] = true, -- Балтар Рожденный в Битве
      [39746] = true, -- Генерал Заритриан
      [39747] = true, -- Савиана Огненная Пропасть
      [39863] = true, -- Халион <Сумеречный разрушитель>
   }

local bossyell = {
	{yell="I have seen worlds bathed in the Makers' flames.", name="Алгалон"},
	{yell="His hold on me dissipates. I can see clearly once more. Thank you, heroes.",  name="Фрейя"},
	{yell="I... I am released from his grasp... at last.", name="Ходир"},
	{yell="^It would appear that I've made a slight miscalculation.", name="Мимирон"},
	{yell="Stay your arms! I yield!", name="Торим"},
	{yell="Don't say I didn't warn ya, scoundrels! Onward, brothers and sisters!", name="Битва на Кораблях"},
	{yell="The Alliance falter. Onward to the Lich King!", name="Битва на Кораблях"},
}
local chan_i, chan_flag
updateframe:SetScript("OnUpdate", function(self, elapsed)

	-- check channels
	if chan_flag then
		check_chan_elaps = check_chan_elaps + elapsed
		if check_chan_elaps > 1 then
			check_chan_elaps = 0
			if chan_i < GetNumDisplayChannels() then
				chan_i = chan_i + 1
				local _, _, _, _, _, active, _, _, _ = GetChannelDisplayInfo(chan_i);
				if active then 
					SetSelectedDisplayChannel(chan_i)
				else check_chan_elaps = check_chan_elaps + 1 end
			else
				chan_flag = nil
				FindGroupSaves_UpdatePlayers()
				if #global_names > 0 then
					global_i = 1
					FindGroupSaves_NewCheckOnline(global_names[global_i])
				end
			end
		end
	end

	if saveplayers_elapsed < saveplayers_maxelapsed then
		saveplayers_elapsed = saveplayers_elapsed + elapsed
	else
		FindGroupSaves_SavePlayers()
	end

	if online_timeleft < online_period + 1 and online_timeleft > 0 then 
		online_timeleft = online_timeleft - elapsed
	elseif online_timeleft <= 0 then
		if players_parrentframe:GetParent():IsVisible() then
			online_timeleft = online_period + 1
			FindGroupSaves_CheckOnline(global_id)
		end
	end

	mail_last_elapsed = mail_last_elapsed + elapsed
	if #global_mails == 0 then return end
	if mail_last_elapsed < mail_interval then return end
	FindGroupSaves_SandLastMail()

end)

-- отправка сообщений в чат
local sendchat =  function(msg, chan, chantype)
	if string.len(msg) > 256 then
		local sendtext1 = utf8sub(msg, 1, 128) .. " ->"
		local sendtext2 = utf8sub(msg, 129, 512)
		
		if chantype == "self" then
			-- To self.
			print(sendtext1)
			print(sendtext2)
		elseif chantype == "channel" then
			-- To channel.
			SendChatMessage(sendtext1, "CHANNEL", nil, chan)
			SendChatMessage(sendtext2, "CHANNEL", nil, chan)
		elseif chantype == "preset" then
			-- To a preset channel id (say, guild, etc).
			SendChatMessage(sendtext1, string.upper(chan))
			SendChatMessage(sendtext2, string.upper(chan))
		elseif chantype == "whisper" then
			-- To player.
			SendChatMessage(sendtext1, "WHISPER", nil, chan)
			SendChatMessage(sendtext2, "WHISPER", nil, chan)
		end
	else
		if chantype == "self" then
			-- To self.
			print(msg)
		elseif chantype == "channel" then
			-- To channel.
			SendChatMessage(msg, "CHANNEL", nil, chan)
		elseif chantype == "preset" then
			-- To a preset channel id (say, guild, etc).
			SendChatMessage(msg, string.upper(chan))
		elseif chantype == "whisper" then
			-- To player.
			SendChatMessage(msg, "WHISPER", nil, chan)
		end
	end
end

memberschanged:RegisterEvent("PARTY_MEMBERS_CHANGED")
memberschanged:SetScript("OnEvent", function()
		if players_parrentframe:GetParent():IsVisible() then
			FindGroupSaves_PrintPlayers(global_id)
		end
		FGC_changemembers()
end)

bossevent:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
bossevent:SetScript("OnEvent", function(...)
	local _, _, _, event, _, _, _, guid, name, _ = ...
	if event == "UNIT_DIED" then
		   mobid = tonumber(guid:sub(-12, -7), 16)
		   if (LibStub("LibBossIDs-1.0").BossIDs[mobid] and notABoss[mobid] ~= true) or ABoss[mobid] == true then
			FindGroupSaves_SaveBoss(name)
		   end

		local health = UnitHealth(36789);
		local max_health = UnitHealthMax(36789);
		if health == max_health and max_health > 0 then FindGroupSaves_SaveBoss(UnitName(36789)) end
	end
end)

bosseventyell:RegisterEvent("CHAT_MSG_MONSTER_YELL")
bosseventyell:SetScript("OnEvent", function(_, msg, ...)
	for i=1, #bossyell do
		if msg:find(bossyell[i].yell) then
			FindGroupSaves_SaveBoss(bossyell[i].name)
		end
	end
end)

function FindGroupSaves_SaveBoss(name)
	name_boss = name
	RequestRaidInfo()
end

savingevent:RegisterEvent("UPDATE_INSTANCE_INFO")
savingevent:SetScript("OnEvent", function()
	FindGroupSaves_SavePlayers()
end)

local G_bosses = {}
local framelo = CreateFrame("Frame")
framelo:RegisterEvent("RAID_INSTANCE_WELCOME")
framelo:RegisterEvent("INSTANCE_LOCK_START")
framelo:RegisterEvent("INSTANCE_LOCK_STOP")
framelo:SetScript("OnEvent", function(self, event)
	if event == "RAID_INSTANCE_WELCOME"
		or event == "INSTANCE_LOCK_START"
	then
		local _, _, encountersTotal, encountersComplete = GetInstanceLockTimeRemaining()
		G_bosses = {}
		if encountersTotal and encountersComplete then
			for i=1, encountersTotal do
				local bossName, _, ikilled = GetInstanceLockTimeRemainingEncounter(i);
				if ikilled then
					tinsert(G_bosses, bossName)
				end
			end
		end
	else
		RequestRaidInfo()
	end
end)


-- проверка всех игроков для сохранения
function FindGroupSaves_SavePlayers()
	saveplayers_elapsed = 0
	FindGroupSaves_CheckMainButton()
	if parrentframe:GetParent():IsVisible() then FindGroupSaves_PrintInstances() end
	local instname, instancetype, difficulty = GetInstanceInfo()
	if instancetype == "raid" or instancetype == "party" then
		local index, id, timeleft, encounterProgress
		for i=1, GetNumSavedInstances() do
			local iname, iid, itimeleft, diff, _, _, _, _, _, _, _, _ = GetSavedInstanceInfo(i)
			if iname == instname and difficulty == diff then index = i; id = iid; timeleft = itimeleft; break end
		end
	
		if not id then return end
		FindGroupSaves_Refresh(id)
		if not FindGroupCharVars.FGS[id] then
			FindGroupCharVars.FGS[id] = {} 
			FindGroupCharVars.FGS[id].bosses = {}
			FindGroupCharVars.FGS[id].players = {}	
			if #G_bosses and instancetype == "raid" then
				for i=1, #G_bosses do
					tinsert(FindGroupCharVars.FGS[id].bosses, G_bosses[i])
				end
			end
		end
		G_bosses = {}
		FindGroupCharVars.FGS[id].index = index
		FindGroupCharVars.FGS[id].time = time()
		FindGroupCharVars.FGS[id].timeleft = timeleft

		local _, _, encountersTotal, encountersComplete = GetInstanceLockTimeRemaining()
		if not FindGroupCharVars.FGS[id].maxbosses then
			FindGroupCharVars.FGS[id].maxbosses = encountersTotal
		elseif FindGroupCharVars.FGS[id].maxbosses < encountersTotal then
			FindGroupCharVars.FGS[id].maxbosses = encountersTotal
		elseif FindGroupCharVars.FGS[id].maxbosses < #FindGroupCharVars.FGS[id].bosses then
			FindGroupCharVars.FGS[id].maxbosses = #FindGroupCharVars.FGS[id].bosses
		end

		local saveflag
		if name_boss then
			if not(FindGroupSaves_FindBosses(id, name_boss)) then
				tinsert(FindGroupCharVars.FGS[id].bosses, name_boss)
				saveflag = true
			end
		end
		
		if UnitInRaid("player") then
			for i = 1, GetNumRaidMembers() do
				local name, _, _, _, _, class, zone, _, _, _, _ = GetRaidRosterInfo(i);
				if zone == instname then
					FindGroupSaves_SavePlayer(id, name, class, 1)
				else
					FindGroupSaves_SavePlayer(id, name, class)
				end
			end
		elseif GetNumPartyMembers() > 0  then
			for i = 1, GetNumPartyMembers() do
				local name, class = UnitName("party" .. i), select(2, UnitClass("party" .. i))
				FindGroupSaves_SavePlayer(id, name, class)
			end
			local name, class =  UnitName("player"), select(2, UnitClass("player"))
			FindGroupSaves_SavePlayer(id, name, class)
		end
		for i=1, #FindGroupCharVars.FGS[id].players do
			if FindGroupCharVars.FGS[id].players[i] then
				if not(FindGroupCharVars.FGS[id].players[i].oldtime == "ready") then
					if saveflag then
						FindGroupCharVars.FGS[id].players[i].oldtime = "ready"
					else
						if time() - FindGroupCharVars.FGS[id].players[i].oldtime > 74 then
							tremove(FindGroupCharVars.FGS[id].players, i)
						end
					end
				end
			end
		end
	end
	name_boss = nil
end

-- занесение игрока в кд-список
function FindGroupSaves_SavePlayer(id, name, class, n)
	if name then
		if UnitInRange(name) or n then
			local spec = LGT:GetGUIDTalentSpec(UnitGUID(name))
			if not spec then spec = "Неизвестно" end
			local i = FindGroupSaves_FindPlayer(id, name)
			if not i then
				tinsert(FindGroupCharVars.FGS[id].players, {name=name, class=class, spec=spec, oldtime=time()})
			else
				if not(FindGroupCharVars.FGS[id].players[i].oldtime == "ready") then
					if time() - FindGroupCharVars.FGS[id].players[i].oldtime > 74 then
						FindGroupCharVars.FGS[id].players[i].oldtime = "ready"
					end
				end
				FindGroupCharVars.FGS[id].players[i].spec=spec
			end
		end
	end
end

-- нахождение игрока в таблице
function FindGroupSaves_FindPlayer(id, name, print_name)
	local FindGroupCharVars = FindGroupCharVars
	if print_name then
		FindGroupCharVars = FindGroupDB[FGL.RealmName][print_name]
	end
	if not(FindGroupCharVars.FGS[id]) then return end
	for i=1, #FindGroupCharVars.FGS[id].players do
		if FindGroupCharVars.FGS[id].players[i].name == name then 
			return i
		end
	end
	return nil
end

-- нахождение босса в таблице
function FindGroupSaves_FindBosses(id, name)
	if FindGroupCharVars.FGS[id].bosses then
	if #FindGroupCharVars.FGS[id].bosses > 0 then
		for i=1, #FindGroupCharVars.FGS[id].bosses do
			if FindGroupCharVars.FGS[id].bosses[i] == name then
				return i
			end
		end
	end
	end
end






--------------------------------------- инстовая часть ---------------------


-- обновления инста и затирание
function FindGroupSaves_Refresh(id, char_name)
	local save_table = FindGroupCharVars
	if char_name then
		save_table = FindGroupDB[FGL.RealmName][print_name]
	end
	if save_table.FGS[id] then
		local timeleft = tonumber(save_table.FGS[id].timeleft)
		local old_time = tonumber(save_table.FGS[id].time)
		local now_time = tonumber(time())
		if ((now_time - old_time) > timeleft) or (now_time < old_time) then
			save_table.FGS[id] = nil
		end
	end
end

-- обновления времени инстов и стирание
function FindGroupSaves_checkandclearids(table_inst)
	for i=1, #table_inst do
		if table_inst[i].name then
			local timeleft = tonumber(table_inst[i].timeleft)
			local old_time = tonumber(table_inst[i].time)
			local now_time = tonumber(time())
			if ((now_time - old_time) > timeleft) or (now_time < old_time) then
				tremove(table_inst, i)
				i=0
			else
				timeleft = timeleft - (now_time - old_time)
				table_inst[i].timeleft = timeleft
				table_inst[i].time = time()
			end
		else
			tremove(table_inst, i)
			i=0
		end
	end
end

-- новая кнопка
function FindGroupSaves_AddButton(i, parrent)
	if parrent == parrentframe then maxframes = maxframes + 1 end
	if parrent == players_parrentframe then players_maxframes = players_maxframes + 1 end
	local height = 16
	local f = CreateFrame("Button", parrent:GetName().."Line"..i, parrent, parrent:GetName().."TextButtonTemplate")
	if i>1 then 	
		f:SetPoint("TOPLEFT", getglobal(parrent:GetName().."Line"..(i-1)), "BOTTOMLEFT", 0, 0)
		f:SetPoint("BOTTOMRIGHT", getglobal(parrent:GetName().."Line"..(i-1)), "BOTTOMRIGHT", 0, -height)
	else
		f:SetPoint("TOPLEFT", parrent, "TOPLEFT", 0, -height*(i-1))
		f:SetPoint("BOTTOMRIGHT", parrent, "TOPRIGHT", 0, -height*(i-1)-height)
	end
end

-- распечатка инстов
function FindGroupSaves_PrintInstances()
	
	FindGroupSavesFrameTitle:SetText(headtext)
	if maxframes > 0 then
		for i=1, maxframes do
			getglobal(parrentframe:GetName().."Line"..i):Hide()
		end
	end

	local table_inst = FindGroupSaves_SortInst(FindGroupCharVars.CDlist_sortvar)
	local color = ""
	if print_name == FGL.CharName then
		FindGroupCharVars.LastSave_FGS_tbl = table_inst
	else
		if FindGroupDB[FGL.RealmName][print_name].LastSave_FGS_tbl then
			table_inst = FindGroupDB[FGL.RealmName][print_name].LastSave_FGS_tbl
			FindGroupSaves_checkandclearids(table_inst)
			
			
			--color = "|cff666666"
			local sort_var = FindGroupCharVars.CDlist_sortvar
			if sort_var then
				local buff
				local f = true
				while f do
					f = false
					for i=2, #table_inst do
						if sort_variants[sort_var[1]][sort_var[2]](table_inst[i-1],table_inst[i]) then
							f = true
							buff = table_inst[i]
							table_inst[i] = table_inst[i-1]
							table_inst[i-1] = buff	
						end
					end
				end
			end
		else
			return
		end
	end
	local FindGroupCharVars = FindGroupDB[FGL.RealmName][print_name]

	for i=1, #table_inst do
		if i > maxframes then FindGroupSaves_AddButton(i, parrentframe) end
		
		local name, id, diff, maxPlayers, diffname, timeleft = 
		table_inst[i].name, table_inst[i].id, table_inst[i].diff, 
		table_inst[i].maxPlayers, table_inst[i].diffname, table_inst[i].timeleft ;
		
		local days, hours, minutes

		days = math.floor(timeleft / (24 * 60 * 60))                
		hours = math.floor((timeleft - days * (24 * 60 * 60)) / (60 * 60))                 
		minutes = math.floor((timeleft - days * (24 * 60 * 60) - hours * (60 * 60)) / 60)
	
		local timemsg = days.."д "..hours.."ч "..minutes.."м"
		
		table_inst[i].timemsg = timemsg
		
		getglobal(parrentframe:GetName().."Line"..i.."L"):SetText(name)
		getglobal(parrentframe:GetName().."Line"..i.."C"):SetText(diffname)
		getglobal(parrentframe:GetName().."Line"..i.."C2"):SetText(color..timemsg)
		getglobal(parrentframe:GetName().."Line"..i.."R"):SetText(color..id)
		
		if FindGroupDB[FGL.RealmName][print_name].FGS[id] then
			getglobal(parrentframe:GetName().."Line"..i):SetScript("OnClick", function()
				local msg = ""
				msg = msg..diffname.."     ID "..id
				msg = msg.."     "..timemsg
				last_locate_check={}
				FindGroupSaves_PrintPlayers(id, name, msg, diff, maxPlayers)
			end)
		end
		getglobal(parrentframe:GetName().."Line"..i):SetScript("OnEnter", function() FindGroupSaves_ShowTooltip(table_inst[i], getglobal(parrentframe:GetName().."Line"..i)) end)
		getglobal(parrentframe:GetName().."Line"..i):SetScript("OnLeave", function() GameTooltip:Hide() end)
		getglobal(parrentframe:GetName().."Line"..i):Show()
	end
		
	PlAYER_ONLINE_MENU:Hide()
	players_parrentframe:GetParent():Hide()
	parrentframe:GetParent():Show()
	FindGroupSavesFrameBackButton:Hide()
	FindGroupSavesFrameSendButton:Hide()
	FindGroupSavesFramePrintButton:Hide()
	FindGroupSavesFrameTitle2:Hide()
	FindGroupSavesFrameScrollText:Show()
end

-- смена критерий сортировки
function FindGroupSaves_SortCriteria(i)
	if not(FindGroupCharVars.CDlist_sortvar) then
		FindGroupCharVars.CDlist_sortvar = {i,1}
		return
	end
	if FindGroupCharVars.CDlist_sortvar[1] == i then
		if FindGroupCharVars.CDlist_sortvar[2] == 1 then
			FindGroupCharVars.CDlist_sortvar[2] = 2
		else
			FindGroupCharVars.CDlist_sortvar[2] = 1
		end
	else
		FindGroupCharVars.CDlist_sortvar = {i,1}	
	end
	FindGroupSaves_PrintInstances()
end

-- функция сортировки и создания таблицы инстов
function FindGroupSaves_SortInst(sort_var)
	local button_table={
	"FindGroupSavesFrameSort_L",
	"FindGroupSavesFrameSort_C",
	"FindGroupSavesFrameSort_C2",
	"FindGroupSavesFrameSort_R",
	}
	
	for i=1 , #button_table do
		getglobal(button_table[i]):Show()
		if sort_var then
			if sort_var[1] == i then
				getglobal(button_table[i]):LockHighlight()
				if sort_var[2] == 1 then
					getglobal(button_table[i]).highlight:SetVertexColor(0.5,0.5,1,1)
				else
					getglobal(button_table[i]).highlight:SetVertexColor(1,0.5,0.5,1)
				end
			else
				getglobal(button_table[i]).highlight:SetVertexColor(1,1,1,1)
				getglobal(button_table[i]):UnlockHighlight()
			end
		else
			getglobal(button_table[i]).highlight:SetVertexColor(1,1,1,1)
			getglobal(button_table[i]):UnlockHighlight()	
		end
	end
	
	
	local table_sort = {}
	local maxinst = GetNumSavedInstances()
	for i=1, maxinst do
		local name, id, timeleft, diff, _, _, _, _, maxPlayers, diffname = GetSavedInstanceInfo(i)
		if name then
			if not diffname:find("гер") then
			 if diff == 3 then
			    diffname = diffname.." (гер.)"
			 elseif diff == 4 then
			    diffname = diffname.." (гер.)"
			 end
			 else
			 diffname = string.gsub(diffname, "оич", "")
			end
			
			
			tinsert(table_sort, {	
						i=i, 
						name=name, 
						id=id, 
						timeleft=timeleft,
						diff=diff, 
						maxPlayers=maxPlayers, 
						diffname=diffname, 
						time = time()
					})
		end
	end
	if sort_var then
		local buff
		local f = true
		while f do
			f = false
			for i=2, #table_sort do
				if sort_variants[sort_var[1]][sort_var[2]](table_sort[i-1],table_sort[i]) then
					f = true
					buff = table_sort[i]
					table_sort[i] = table_sort[i-1]
					table_sort[i-1] = buff
				end
			end
		end
	end
	return table_sort
end


-- тултип инста
function FindGroupSaves_ShowTooltip(table_inst, this)
	local FindGroupCharVars = FindGroupDB[FGL.RealmName][print_name]
	local name, id, timeleft, difficulty, maxPlayers, difficultyName, timemsg = 
		table_inst.name, 
		table_inst.id, 
		table_inst.timeleft, 
		table_inst.diff, 
		table_inst.maxPlayers,
		table_inst.diffname, 
		table_inst.timemsg;

	local addarrow = "RIGHT"
	if (UIParent:GetWidth()/2 - FindGroupSavesFrame:GetWidth()/2) < (FindGroupSavesFrame:GetLeft()*FindGroupSavesFrame:GetScale()) then
		addarrow = "LEFT"		
	end
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOM"..addarrow, 0, 20)
	GameTooltip:ClearLines()

	GameTooltip:SetText(name)
	GameTooltip:AddLine(difficultyName, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	GameTooltip:AddDoubleLine("ID: " .. id .. "", "|cffffffff"..timemsg.."|r", HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)

	if FindGroupCharVars.FGS[id] then
		if FindGroupCharVars.FGS[id].bosses then
			GameTooltip:AddLine("\nБосов убито (" .. #FindGroupCharVars.FGS[id].bosses .. "/" .. FindGroupCharVars.FGS[id].maxbosses .. ")")
			if #FindGroupCharVars.FGS[id].bosses > 0 then
				for i=1, #FindGroupCharVars.FGS[id].bosses do
					local sln = ""
					GameTooltip:AddLine(FindGroupCharVars.FGS[id].bosses[i]..sln , HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
					if #FindGroupCharVars.FGS[id].bosses == i then sln = "\n" end
				end
			end
		end
		if FindGroupCharVars.FGS[id].players then
			GameTooltip:AddLine("\nИгроки (" .. #FindGroupCharVars.FGS[id].players .. ")")
			for i=1, #FindGroupCharVars.FGS[id].players do
				local color = "|cff"..FindGroup_funcgetcolor(FindGroupCharVars.FGS[id].players[i].class)
				if not FindGroupCharVars.FGS[id].players[i].spec then FindGroupCharVars.FGS[id].players[i].spec = "" end
				GameTooltip:AddDoubleLine( color..FindGroupCharVars.FGS[id].players[i].name.."|r", color..FindGroupCharVars.FGS[id].players[i].spec.."|r", HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
			end
		end
	end
	GameTooltip:Show()
end






------------------------------------- часть игроков-------------



-- отправка писма сверху стопки
function FindGroupSaves_SandLastMail()
	local i = #global_mails
	local msg = FindGroupSaves_GetMailText(global_mails[i].InstName, global_mails[i].maxPlayers, global_mails[i].difficulty,  global_mails[i].id)
	SendChatMessage(msg, "WHISPER", nil, global_mails[i].name)
	local id, i = global_mails[i].id, FindGroupSaves_FindPlayer(global_mails[i].id, global_mails[i].name, print_name)
	tremove( global_mails, i)
	mail_last_elapsed = 0
	if #global_mails < 1 then FindGroupSavesFrameSendButton:UnlockHighlight() end
	FindGroupSaves_CheckSend(id, i)
end

-- составление теста письма
function FindGroupSaves_GetMailText(InstName, maxPlayers, difficulty, id)
	local InstDiffname = ""
	if maxPlayers > 5 then
		InstDiffname=InstDiffname..maxPlayers
		if difficulty == 3 or difficulty == 4 then  InstDiffname=InstDiffname.."(гер.)" end
	else
		if difficulty == 2 then  InstDiffname=InstDiffname.."(гер.)" end
	end
	
	local p = FindGroup_GetInstFav(string.lower(InstName))
	if p then
	if strlen(FGL.db.instances[p].difficulties) < 2 then InstDiffname = "" end
	end
	
	local msg = string.format(FGL.db.msgforsaves, InstName, InstDiffname, id)
	if UnitInRaid("player") then
		if not IsRaidLeader() and not IsRaidOfficer() then
			local leader
			for i = 1, GetNumRaidMembers() do
				local playername, rank, _, _, _, _, _, _, _, _, _ = GetRaidRosterInfo(i)
				if rank == 2  then leader=playername; break end
			end
			msg = string.format(FGL.db.msgforsaves_notinvite, InstName, InstDiffname, id, leader)
		end
	elseif GetNumPartyMembers() > 0 then
		if not UnitIsPartyLeader("player") then
			local leader
			for i = 1, GetNumPartyMembers() do
				if UnitIsPartyLeader("party" .. i) then leader = UnitName("party" .. i); break end
			end
			msg = string.format(FGL.db.msgforsaves_notinvite, InstName, InstDiffname, id, leader)
		end
	end
	return msg
end

-- стакер почты
function FindGroupSaves_Mailer(name, InstName, maxPlayers, difficulty, id)
	tinsert(global_mails, {name=name, InstName=InstName, maxPlayers=maxPlayers, difficulty=difficulty, id=id})
	FindGroupSaves_CheckSend(id, FindGroupSaves_FindPlayer(id, name, print_name))
end

-- сортировка игроков
function FindGroupSaves_SortPlayers(id)
	local FindGroupCharVars = FindGroupDB[FGL.RealmName][print_name]
	local buff
	local f = true
	while f do
		f = false
		for i=2, #FindGroupCharVars.FGS[id].players do
			if (FindGroupCharVars.FGS[id].players[i].online and not FindGroupCharVars.FGS[id].players[i-1].online) 
			or (FindGroupSaves_ReCheckPlus(id, i) and not FindGroupSaves_ReCheckPlus(id, i-1))then
				f = true
				buff = FindGroupCharVars.FGS[id].players[i]
				FindGroupCharVars.FGS[id].players[i] = FindGroupCharVars.FGS[id].players[i-1]
				FindGroupCharVars.FGS[id].players[i-1] = buff
			end
		end
	end
end

-- сортировка и распечатка игроков
function FindGroupSaves_UpdatePlayers()
	FindGroupSaves_SortPlayers(global_id)
	if players_parrentframe:GetParent():IsVisible() then
		FindGroupSaves_PrintPlayers(global_id)
	end
end

-- функция приглашения в группу по нику
function FindGroupSaves_Invite(name)
	InviteUnit(name)
end

-- отправка всем
function FindGroupSaves_SendAll()
	local FindGroupCharVars = FindGroupDB[FGL.RealmName][print_name]
	local id = global_id
	local InstName, maxPlayers, difficulty
	for i=1, GetNumSavedInstances() do
		local name, iid, _, idifficulty, _, _, _, _, imax, diffname = GetSavedInstanceInfo(i)
		if iid == id then InstName = name; maxPlayers=imax; difficulty=idifficulty; break end
	end
	if InstName then
		for i=1, #FindGroupCharVars.FGS[id].players do
			local name = FindGroupCharVars.FGS[id].players[i].name
			local flag = true
			if UnitInRaid("player") then
				for i = 1, GetNumRaidMembers() do
					local tname, _, _, _, _, _, _, _, _, _, _ = GetRaidRosterInfo(i);
					if name == tname then
						flag = false
						break
					end
				end
			elseif GetNumPartyMembers() > 0  then
				for i = 1, GetNumPartyMembers() do
					local tname = UnitName("party" .. i)
					if name == tname then
						flag = false
						break
					end
				end
			end
			if FindGroupCharVars.FGS[id].players[i].online and not(name == UnitName("player")) and flag then
				FindGroupSaves_Mailer(name, InstName, maxPlayers, difficulty, id)
			end
		end
		if #global_mails > 0 then FindGroupSavesFrameSendButton:LockHighlight() end
	end
end

-- проверка на отправку всем
function FindGroupSaves_CheckSendAll()
	if #global_mails > 0 then
		global_mails = {}
		FindGroupSavesFrameSendButton:UnlockHighlight()
	else
		local id = global_id
		local InstName, maxPlayers, difficulty
		for i=1, GetNumSavedInstances() do
			local name, iid, _, idifficulty, _, _, _, _, imax, diffname = GetSavedInstanceInfo(i)
			if iid == id then InstName = name; maxPlayers=imax; difficulty=idifficulty; break end
		end
		if InstName then
			local msg = "Вы уверены что хотите отправить всем текущим игрокам:\n"
			msg = msg..FindGroupSaves_GetMailText(InstName, maxPlayers, difficulty, id)
			StaticPopupDialogs["FINDGROUP_CONFIRM_SEND_ALL"].text = msg
			StaticPopup_Show("FINDGROUP_CONFIRM_SEND_ALL")
		end
	end
end

-- распечатка всем игрокам 
function FindGroupSaves_PrintAllPlayers(this)
	if FGS_ReportWindow==nil then
		CreateFGS_ReportWindow(this:GetParent())
		if FGS_ReportWindow then
			FGS_ReportWindow:Show()
		end
	else
		FGS_ReportWindow:Hide()
	end
end

local function destroywindow()
	if FGS_ReportWindow then
		FGS_ReportWindow:ReleaseChildren()
		FGS_ReportWindow:Hide()
		FGS_ReportWindow:Release()
	end
	FGS_ReportWindow = nil
end

-- окно для выбора канала
function CreateFGS_ReportWindow(window)

	if not(type(FindGroupCharVars.report) == 'table') then FindGroupCharVars.report = {} end
	if not(type(FindGroupCharVars.report.checkbox) == 'table') then FindGroupCharVars.report.checkbox = {} end

	--окно
	FGS_ReportWindow = AceGUI:Create("Window")
	local frame = FGS_ReportWindow
	frame:EnableResize(nil)
	frame:SetWidth(250)
	frame:SetLayout("Flow")
	frame:SetHeight(300)
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	frame:SetTitle("Список игроков")
	frame:SetCallback("OnClose", function(widget, callback)
		destroywindow()
	end)

	
	--каналы
	local channeltext = AceGUI:Create("Label")
	channeltext:SetText("Канал")
	channeltext:SetFullWidth(true)
	local channellist = {
		{"Whisper", "whisper","Шёпот"},
		{"Whisper Target", "whisper","Шёпот цели"},
		{"Say", "preset","Сказать"},
		{"Raid", "preset","Рейд"},
		{"Party", "preset", "Группа"},
		{"Guild", "preset", "Гильдия"},
		{"Officer", "preset", "Офицер"},
		{"Self", "self", "Себе"},
	}
	local list = {GetChannelList()}
	for i=2, #list, 2 do
		if list[i] ~= "Trade" and list[i] ~= "General" and list[i] ~= "LookingForGroup" and list[i] ~= FGL.ChannelName then
			channellist[#channellist+1] = {list[i], "channel"}
		end
	end
	for i=1,#channellist do
		local checkbox = AceGUI:Create("CheckBox")
		FindGroupCharVars.report.checkbox[channellist[i][1]] = checkbox
		checkbox:SetType("radio")
		checkbox:SetRelativeWidth(0.5)
		-- checkbox:SetValue(false)
		if FindGroupCharVars.report.chantype == "channel" then
			if channellist[i][1] == FindGroupCharVars.report.channel then
				frame.channel = channellist[i][1]
				frame.chantype = channellist[i][2]
				checkbox:SetValue(true)
			end
		elseif FindGroupCharVars.report.chantype == "whisper" then
			if channellist[i][1] == "Whisper" then
				frame.channel = channellist[i][1]
				frame.chantype = channellist[i][2]
				checkbox:SetValue(true)
			end
		elseif FindGroupCharVars.report.chantype == "preset" then
			-- print("pass")
			if channellist[i][1] == FindGroupCharVars.report.channel then
				frame.channel = channellist[i][1]
				frame.chantype = channellist[i][2]
				checkbox:SetValue(true)
			end
		elseif FindGroupCharVars.report.chantype == "self" then
			if channellist[i][2] == "self" then
				frame.channel = channellist[i][1]
				frame.chantype = channellist[i][2]
				checkbox:SetValue(true)
			end
		end
		if i >= 9 then
			checkbox:SetLabel(channellist[i][1])
		else
			checkbox:SetLabel(channellist[i][3])
		end
		checkbox:SetCallback("OnValueChanged", function(value)
			for i=1, #channellist do
				local c = FindGroupCharVars.report.checkbox[channellist[i][1]]
				if c ~= nil and c ~= checkbox then
					c:SetValue(false)
				end
				if c == checkbox then
					frame.channel = channellist[i][1]
					frame.chantype = channellist[i][2]
				end
			end 
		end)
		frame:AddChild(checkbox)
	end
	
	local whisperbox = AceGUI:Create("EditBox")
	whisperbox:SetLabel("Шёпот игроку:")
	if FindGroupCharVars.report.chantype == "whisper" and FindGroupCharVars.report.channel ~= "Шёпот" then
		whisperbox:SetText(FindGroupCharVars.report.channel)
		frame.target = FindGroupCharVars.report.channel
	end
	whisperbox:SetCallback("OnEnterPressed", function(box, event, text) frame.target = text frame.button.frame:Click() end)
	whisperbox:SetCallback("OnTextChanged", function(box, event, text) frame.target = text end)
	whisperbox:SetFullWidth(true)
	
	
	local FindGroupCharVars_1 = FindGroupDB[FGL.RealmName][print_name]
	local id_1 = global_id
	
	local report = AceGUI:Create("Button")
	frame.button = report
	report:SetText("Отчёт")
	report:SetCallback("OnClick", function()
		if frame.channel == "Whisper" then
			frame.channel = frame.target
		end
		if frame.channel == "Whisper Target" then
			if UnitExists("target") then
				frame.channel = UnitName("target")
			else
				frame.channel = nil
			end
		end
		if frame.channel and frame.chantype then
			FindGroupCharVars.report.channel = frame.channel
			FindGroupCharVars.report.chantype = frame.chantype
			FindGroupSaves_PrintAllPlayers_2(FindGroupCharVars_1, id_1, frame.channel, frame.chantype)
			frame:Hide()
		end
		
	end)
	report:SetFullWidth(true)
	frame:AddChildren(whisperbox, report)
	frame:SetHeight(120 + 27* math.ceil(#channellist/2))
end

-- сама распечатка
function FindGroupSaves_PrintAllPlayers_2(FindGroupCharVars, id, channel, chtype)

	local table_inst = FindGroupCharVars.LastSave_FGS_tbl
	local InstName, maxPlayers, difficulty
	
	for i=1, #table_inst do
		if table_inst[i].id == id then
			InstName = table_inst[i].name
			maxPlayers = table_inst[i].maxPlayers
			difficulty = table_inst[i].diff
			break
		end
	end
	local InstDiffname = ""
	if maxPlayers > 5 then
		InstDiffname=InstDiffname..maxPlayers
		if difficulty == 3 or difficulty == 4 then  InstDiffname=InstDiffname.."(гер.)" end
	else
		if difficulty == 2 then  InstDiffname=InstDiffname.."(гер.)" end
	end
	local msg = string.format(FGL.db.msgforprint, InstName, InstDiffname, id)
	
	local now_i=1
	while now_i ~= #FindGroupCharVars.FGS[id].players do
		for i=now_i, #FindGroupCharVars.FGS[id].players do
			if strlen(msg..FindGroupCharVars.FGS[id].players[i].name) > 128 then
				break
			end
			now_i = i
			msg=msg..FindGroupCharVars.FGS[id].players[i].name
			if #FindGroupCharVars.FGS[id].players == i then
				msg=msg.."."
				break
			else
				msg=msg..", "
			end
		end
		sendchat(msg, channel, chtype)
		msg=""
	end
end

_G.StaticPopupDialogs["FINDGROUP_CONFIRM_SEND_ALL"] = {
	text = "",
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		FindGroupSaves_SendAll()
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1
}

-- рапечатка игроков
function FindGroupSaves_PrintPlayers(id, instName, diffid, difficulty, maxPlayers)
	local FindGroupCharVars = FindGroupDB[FGL.RealmName][print_name]
	if not(FindGroupCharVars) then return end
	if not(FindGroupCharVars.FGS) then return end
	if not(FindGroupCharVars.FGS[id]) then return end
	local button_table={
	"FindGroupSavesFrameSort_L",
	"FindGroupSavesFrameSort_C",
	"FindGroupSavesFrameSort_C2",
	"FindGroupSavesFrameSort_R",
	}
	
	for i=1 , #button_table do
		getglobal(button_table[i]):Hide()
	end
		if instName then FindGroupSavesFrameTitle:SetText(instName) end
		if diffid then FindGroupSavesFrameTitle2:SetText(diffid) end
		if not players_parrentframe:GetParent():IsVisible() then
		if players_maxframes > 0 then
			for i=1, players_maxframes do
				getglobal(players_parrentframe:GetName().."Line"..i):Hide()
			end
		end
		end
		for i=1, #FindGroupCharVars.FGS[id].players do
			if i > players_maxframes then FindGroupSaves_AddButton(i, players_parrentframe) end
			local color = "|cff"..FindGroup_funcgetcolor(FindGroupCharVars.FGS[id].players[i].class)
			local name_player = FindGroupCharVars.FGS[id].players[i].name

			getglobal(players_parrentframe:GetName().."Line"..i.."L"):SetText(color..name_player)
			getglobal(players_parrentframe:GetName().."Line"..i.."R"):SetText(color..FindGroupCharVars.FGS[id].players[i].spec)
			getglobal(players_parrentframe:GetName().."Line"..i.."R"):SetText(color..FindGroupCharVars.FGS[id].players[i].spec)
			getglobal(players_parrentframe:GetName().."Line"..i):RegisterForClicks("AnyUp")
			getglobal(players_parrentframe:GetName().."Line"..i):SetScript("OnClick", function(self, button)
				if button == "RightButton" then
					local f = getglobal(players_parrentframe:GetName().."Line"..i)
					PlAYER_ONLINE_MENU:Hide()
					PlAYER_ONLINE_MENU.TargetName = name_player
					PlAYER_ONLINE_MENU.TargetColor = color
					PlAYER_ONLINE_MENU.TargetOnline = FindGroupCharVars.FGS[id].players[i].online
					PlAYER_ONLINE_MENU:Show()
				else
					PlAYER_ONLINE_MENU:Hide()
				end
			end)
			if FindGroupCharVars.FGS[id].players[i].online then
				if  FindGroup_getignor(name_player) then
					getglobal(players_parrentframe:GetName().."Line"..i):SetBackdropColor(color_online_ignore.r,color_online_ignore.g,color_online_ignore.b,color_online_ignore.a)			
				elseif FindGroupSaves_FindInFriends(name_player) then
					getglobal(players_parrentframe:GetName().."Line"..i):SetBackdropColor(color_online_friend.r,color_online_friend.g,color_online_friend.b,color_online_friend.a)
				else
					getglobal(players_parrentframe:GetName().."Line"..i):SetBackdropColor(color_online.r,color_online.g,color_online.b,color_online.a)
				end
			else
				if  FindGroup_getignor(name_player) then
					getglobal(players_parrentframe:GetName().."Line"..i):SetBackdropColor(color_offline_ignore.r,color_offline_ignore.g,color_offline_ignore.b,color_offline_ignore.a)			
				elseif FindGroupSaves_FindInFriends(name_player) then
					getglobal(players_parrentframe:GetName().."Line"..i):SetBackdropColor(color_offline_friend.r,color_offline_friend.g,color_offline_friend.b,color_offline_friend.a)
				else
					getglobal(players_parrentframe:GetName().."Line"..i):SetBackdropColor(color_offline.r,color_offline.g,color_offline.b,color_offline.a)
				end
			end
			getglobal(players_parrentframe:GetName().."Line"..i.."Send"):SetScript("OnClick", function()
				FindGroupSaves_Send(i, id)
			end)
			if instName then
				getglobal(players_parrentframe:GetName().."Line"..i.."Send"):SetScript("OnEnter", function()
					if falsetonil(FGL.db.tooltipsstatus) then
						local tooltip_name = "SavesSend"
						local msg = string.format("%s\n|cffffffff%s", FGL.db.tooltips[tooltip_name][2], FGL.db.tooltips[tooltip_name][3])
						msg=msg..FindGroupSaves_GetMailText(instName, maxPlayers, difficulty, id)
						GameTooltip:SetOwner(this, FGL.db.tooltips[tooltip_name][1])
						GameTooltip:SetText(msg, nil, nil, nil, nil, true)
					end
				end)
			end
			getglobal(players_parrentframe:GetName().."Line"..i.."Send"):SetScript("OnLeave", function()
				GameTooltip:Hide()
			end)
			getglobal(players_parrentframe:GetName().."Line"..i.."Plus"):SetScript("OnClick", function()
				FindGroupSaves_Invite(name_player)
			end)

			getglobal(players_parrentframe:GetName().."Line"..i.."Plus"):SetScript("OnEnter", function()
				if falsetonil(FGL.db.tooltipsstatus) then
					local tooltip_name = "SavesPlus"
					local msg = string.format("%s\n|cffffffff%s", FGL.db.tooltips[tooltip_name][2], FGL.db.tooltips[tooltip_name][3])
					GameTooltip:SetOwner(this, FGL.db.tooltips[tooltip_name][1])
					GameTooltip:SetText(msg, nil, nil, nil, nil, true)
				end
			end)
			getglobal(players_parrentframe:GetName().."Line"..i.."Plus"):SetScript("OnLeave", function()
				GameTooltip:Hide()
			end)
			
			getglobal(players_parrentframe:GetName().."Line"..i.."Check"):SetScript("OnEnter", function()
				FindGroupSaves_CheckLocale(name_player, i, id)
			end)
			
			getglobal(players_parrentframe:GetName().."Line"..i.."Check"):SetScript("OnLeave", function()
				GameTooltip:Hide()
			end)
			getglobal(players_parrentframe:GetName().."Line"..i.."Check"):SetScript("OnClick", function()
				FindGroupSaves_CheckLocaleClick(name_player, i, id)
			end)			
			FindGroupSaves_CheckSend(id, i)
			FindGroupSaves_CheckPlus(id, i)
			FindGroupSaves_CheckCheck(id, i)
			getglobal(players_parrentframe:GetName().."Line"..i):Show()
		end


		local f=false
		for i=1, #FindGroupCharVars.FGS[id].players do
			if FindGroupCharVars.FGS[id].players[i].online and not(UnitName("player") == FindGroupCharVars.FGS[id].players[i].name) then
				f=true
				break
			end
		end
		if f then
			FindGroupSavesFrameSendButton:Enable()
		else
			FindGroupSavesFrameSendButton:Disable()
		end
		
		if not players_parrentframe:GetParent():IsVisible() then
			PlAYER_ONLINE_MENU:Hide()
			parrentframe:GetParent():Hide()
			FindGroupSavesFrameScrollText:Hide()
			players_parrentframe:GetParent():Show()
			FindGroupSavesFrameBackButton:Show()
			FindGroupSavesFrameSendButton:Show()
			FindGroupSavesFramePrintButton:Show()
			FindGroupSavesFrameTitle2:Show()
			FindGroupSavesFrameScrollText:Hide()	
			FindGroupSaves_CheckOnline(id)
		end
end


-- проверка онлайн по сохр данным
function FindGroupSaves_CheckCheck(id, i)
	local FindGroupCharVars = FindGroupDB[FGL.RealmName][print_name]
	if FindGroupCharVars.FGS[id].players[i].online then
		getglobal(players_parrentframe:GetName().."Line"..i.."Check"):Enable()
	else
		getglobal(players_parrentframe:GetName().."Line"..i.."Check"):Disable()
	end
end

-- поиск игрока в друзьях
function FindGroupSaves_FindInFriends(name)
	if UnitName("player") == name then return 1 end
	if GetNumFriends() > 0 then
		for j=1, GetNumFriends() do
			local jname, _ = GetFriendInfo(j);
			if jname == name then return 1 end
		end
	end
end

-- проверка отправки письма
function FindGroupSaves_CheckSend(id, i)
	local FindGroupCharVars = FindGroupDB[FGL.RealmName][print_name]
	if FindGroupCharVars.FGS[id].players[i].online then
		if not UnitInParty(FindGroupCharVars.FGS[id].players[i].name) and not UnitInRaid(FindGroupCharVars.FGS[id].players[i].name) then
			local f = true
			if #global_mails > 0 then
				for k=1, #global_mails do
					if global_mails[k].name == FindGroupCharVars.FGS[id].players[i].name then f = false; break end
				end
			end
			if f then 
				getglobal(players_parrentframe:GetName().."Line"..i.."Send"):Enable()
			else
				getglobal(players_parrentframe:GetName().."Line"..i.."Send"):Disable() 
			end
		else
			getglobal(players_parrentframe:GetName().."Line"..i.."Send"):Disable()
		end
	else
		getglobal(players_parrentframe:GetName().."Line"..i.."Send"):Disable()
	end
end

-- проверка отправки приглашения в группу
function FindGroupSaves_CheckPlus(id, i)
	local FindGroupCharVars = FindGroupDB[FGL.RealmName][print_name]
	if not(UnitName("player") == FindGroupCharVars.FGS[id].players[i].name) then
		if FindGroupCharVars.FGS[id].players[i].online then
			if not UnitInParty(FindGroupCharVars.FGS[id].players[i].name) and not UnitInRaid(FindGroupCharVars.FGS[id].players[i].name) then
				if GetNumPartyMembers() > 0 or UnitInRaid("player") then
					if IsRaidLeader() == 1 or  IsRaidOfficer() == 1 or UnitIsPartyLeader("player") == 1 then
						getglobal(players_parrentframe:GetName().."Line"..i.."Plus"):Enable()
					else
						getglobal(players_parrentframe:GetName().."Line"..i.."Plus"):Disable()
					end
				else
					getglobal(players_parrentframe:GetName().."Line"..i.."Plus"):Enable()
				end
			else
				getglobal(players_parrentframe:GetName().."Line"..i.."Plus"):Disable()	
			end
		else
			getglobal(players_parrentframe:GetName().."Line"..i.."Plus"):Disable()
		end
	else
			getglobal(players_parrentframe:GetName().."Line"..i.."Plus"):Disable()
	end
end

function FindGroupSaves_Send(num, id)
	local FindGroupCharVars = FindGroupDB[FGL.RealmName][print_name]
	local name = FindGroupCharVars.FGS[id].players[num].name
	local InstName, maxPlayers, difficulty
	for i=1, GetNumSavedInstances() do
		local name, iid, _, idifficulty, _, _, _, _, imax, diffname = GetSavedInstanceInfo(i)
		if iid == id then InstName = name; maxPlayers=imax; difficulty=idifficulty; break end
	end
	if InstName then
		FindGroupSaves_Mailer(name, InstName, maxPlayers, difficulty, id)
		--getglobal(players_parrentframe:GetName().."Line"..num.."Send"):Disable()
	end
end

function FindGroupSaves_ReCheckPlus(id, i)
	local FindGroupCharVars = FindGroupDB[FGL.RealmName][print_name]
	if not FindGroupCharVars.FGS[id] then return end
	if not FindGroupCharVars.FGS[id].players then return end
	if not FindGroupCharVars.FGS[id].players[i] then return end
	if type(i)=='string' then i=FindGroupSaves_FindPlayer(id, i, print_name) end
	if not(UnitName("player") == FindGroupCharVars.FGS[id].players[i].name) then
		if FindGroupCharVars.FGS[id].players[i].online then
			if not UnitInParty(FindGroupCharVars.FGS[id].players[i].name) and not UnitInRaid(FindGroupCharVars.FGS[id].players[i].name) then
				if GetNumPartyMembers() > 0 or UnitInRaid("player") then
					if IsRaidLeader() == 1 or  IsRaidOfficer() == 1 or UnitIsPartyLeader("player") == 1 then
						return 1
					end
				else
					return 1
				end	
			end
		end
	end
end






-------------------------------главные штуки--------------------

-- функция проверки активности кнопки открывания/закрывания
function FindGroupSaves_CheckMainButton()
	if GetNumSavedInstances() > 0 then
		FindGroupFrameCCDButton:Enable()
		return 1
	else
		FindGroupFrameCCDButton:Disable()
		if not nextchars then
			local chars = 0
			for name, value in pairs(FindGroupDB[FGL.RealmName]) do
				if value.LastSave_FGS_tbl then
					FindGroupSaves_checkandclearids(value.LastSave_FGS_tbl)
					if #value.LastSave_FGS_tbl > 0 then
						chars = chars + 1
					end
				end
				if chars > 1 then
					break
				end
			end
			nextchars=chars
		end
		if nextchars > 1 then
			FindGroupFrameCCDButton:Enable()
			return 1
		end
	end
end

-- открытие и закрытие кд-листа
function FindGroupSaves_Toggle()
	if FindGroupSavesFrame:IsVisible() then
		FindGroupSavesFrame:Hide()
		PlAYER_ONLINE_MENU:Hide()
	else
		local chars = 0
		FindGroupSavesFrameComboBoxChars:Hide()
		for name, _ in pairs(FindGroupDB[FGL.RealmName]) do
			chars = chars + 1
			if chars > 1 then
				FindGroupSavesFrameComboBoxCharsText:SetText(print_name)
				FindGroupSavesFrameComboBoxChars:Show()
				break
			end
		end
		nextchars=chars
		parrentframe:SetWidth(FindGroupSavesFrame:GetWidth()-55)
		players_parrentframe:SetWidth(FindGroupSavesFrame:GetWidth()-55)
		FindGroupSavesFrame:Show()
		FindGroupFrame:Show()
		RequestRaidInfo()
		FindGroupSaves_PrintInstances()
	end
	PlaySound("igMainMenuOptionCheckBoxOn");
end

-- загрузка кд-части
function FindGroupSaves_OnLoad()
	parrentframe = FindGroupSavesFrameScrollFrameScrollChild
	players_parrentframe = FindGroupSavesFramePlayersScrollFrameScrollChild
	if not FindGroupCharVars.FGS then FindGroupCharVars.FGS = {} end


	-- контекстное меню
	PlAYER_ONLINE_MENU = CreateFrame("Frame", FindGroupSavesFrame:GetName().."Menu", UIParent, "GameTooltipTemplate")
	PlAYER_ONLINE_MENU:EnableMouse(true)
	PlAYER_ONLINE_MENU:SetSize(10, 10)
	local height = 15

	PlAYER_ONLINE_MENU.Whisper = function() 
		local name = PlAYER_ONLINE_MENU.TargetName
		local link = string.format("player:%s",name)
		local text = string.format("|Hplayer:%s|h[%s]|h",name,name)
		ChatFrame_OnHyperlinkShow(ChatFrameTemplate, link, text, "LeftButton")
	end
	PlAYER_ONLINE_MENU.Invite = function()
		InviteUnit(PlAYER_ONLINE_MENU.TargetName)
	end
	PlAYER_ONLINE_MENU.AddFriend = function()
		AddFriend(PlAYER_ONLINE_MENU.TargetName)
		PlAYER_ONLINE_MENU.update_friends = 1
	end
	PlAYER_ONLINE_MENU.AddExcend = function()
		AddIgnore(PlAYER_ONLINE_MENU.TargetName)
		PlAYER_ONLINE_MENU.update_ignore = 1
	end

	PlAYER_ONLINE_MENU.Delete = function()
		local msg = "Вы действительно хотите удалить игрока [%s%s|r] из этого списка с ID-%d?"
		msg=string.format(msg, PlAYER_ONLINE_MENU.TargetColor, PlAYER_ONLINE_MENU.TargetName, global_id)
		StaticPopupDialogs["FINDGROUP_CONFIRM_DELETECHAR"].text = msg
		saves_delete_char_name = PlAYER_ONLINE_MENU.TargetName
		saves_delete_print_name = print_name
		saves_delete_char_id = global_id
		StaticPopup_Show("FINDGROUP_CONFIRM_DELETECHAR") 
	end
	PlAYER_ONLINE_MENU.Cancel = function()
		PlAYER_ONLINE_MENU:Hide()
	end

	local menu_func={
		{	name="Nick", 																						},
		{	name="Шепот", 					dis=true,						func=PlAYER_ONLINE_MENU.Whisper,	},
		{	name="Пригласить",				dis=true,		invite=true,	func=PlAYER_ONLINE_MENU.Invite,		},
		{	name="Добавить друга",							friend=true,	func=PlAYER_ONLINE_MENU.AddFriend,	},
		{	name="Черный список",							ignore=true,	func=PlAYER_ONLINE_MENU.AddExcend,	},
		{	name="Удалить",													func=PlAYER_ONLINE_MENU.Delete,		},
		{	name="Отмена",													func=PlAYER_ONLINE_MENU.Cancel,		},
	}

	for i=1, #menu_func do
		local f = CreateFrame("Button", PlAYER_ONLINE_MENU:GetName()..i,  PlAYER_ONLINE_MENU, "SecureUnitButtonTemplate")
		f:SetPoint("TOPLEFT", PlAYER_ONLINE_MENU, "TOPLEFT", 5, -8-height*(i-1))
		f:SetPoint("BOTTOMRIGHT", PlAYER_ONLINE_MENU, "TOPRIGHT", -5, -8-height*(i-1)-height)
		f:Show()

		local g = f:CreateFontString(f:GetName().."Text",  "BACKGROUND", "GameFontNormal")
		g:SetPoint("TOPLEFT", f, "TOPLEFT", 5,-3)
		g:SetHeight(10)
		g:SetText("")
		g:SetTextColor(1, 1, 1, 1)
		g:Show()


		if not (menu_func[i].name == "Nick") then
			f:SetHighlightTexture("Interface\\Buttons\\UI-Listbox-Highlight")
			g:SetTextColor(1, 1, 1, 1)
			g:SetText(menu_func[i].name)
			f:SetScript("OnClick", function()
				menu_func[i].func()
				PlAYER_ONLINE_MENU:Hide()
			end)
		else
			g:SetTextColor(1, 0.8, 0, 1)
			g:SetText(PlAYER_ONLINE_MENU.TargetName)
		end

		if PlAYER_ONLINE_MENU:GetWidth() < g:GetWidth()+20 then PlAYER_ONLINE_MENU:SetWidth(g:GetWidth()+20) end
	end

	PlAYER_ONLINE_MENU:SetHeight((#menu_func)*height+15)
	PlAYER_ONLINE_MENU:SetScript("OnShow", function(self)
						PlAYER_ONLINE_MENU:ClearAllPoints()
						local px, py = _G.GetCursorPosition();
						local scale = _G.UIParent:GetEffectiveScale();
						px, py = px / scale, py / scale;
						PlAYER_ONLINE_MENU:SetPoint("TOPLEFT", UIParrent, "BOTTOMLEFT", px, py)
	self:SetFrameStrata('TOOLTIP'); 
	self:SetFrameLevel(40); 
	for i=1, #menu_func do
		local f=getglobal(PlAYER_ONLINE_MENU:GetName()..i)
		local g=getglobal(f:GetName().."Text")
		if not (menu_func[i].name == "Nick") then
			if menu_func[i].dis and not PlAYER_ONLINE_MENU.TargetOnline then
				f:SetHighlightTexture("")
				f:SetScript("OnClick", function() end)
				g:SetTextColor(0.63, 0.63, 0.63, 1)				
			else
				if menu_func[i].friend and FindGroupSaves_FindInFriends(PlAYER_ONLINE_MENU.TargetName) then
					f:SetHighlightTexture("")
					f:SetScript("OnClick", function() end)
					g:SetTextColor(0.63, 0.63, 0.63, 1)
				elseif menu_func[i].ignore and (FindGroup_getignor(PlAYER_ONLINE_MENU.TargetName) or UnitName("player") == PlAYER_ONLINE_MENU.TargetName)then
					f:SetHighlightTexture("")
					f:SetScript("OnClick", function() end)
					g:SetTextColor(0.63, 0.63, 0.63, 1)
				elseif menu_func[i].invite and not FindGroupSaves_ReCheckPlus(global_id,PlAYER_ONLINE_MENU.TargetName) then
					f:SetHighlightTexture("")
					f:SetScript("OnClick", function() end)
					g:SetTextColor(0.63, 0.63, 0.63, 1)
				else
					f:SetHighlightTexture("Interface\\Buttons\\UI-Listbox-Highlight")
					f:SetScript("OnClick", function()
						menu_func[i].func()
						PlAYER_ONLINE_MENU:Hide()
					end)
					g:SetTextColor(1, 1, 1, 1)
				end
			end
			g:SetText(menu_func[i].name)
		else
			g:SetTextColor(1, 0.8, 0, 1)
			g:SetText(PlAYER_ONLINE_MENU.TargetName)
		end
		if PlAYER_ONLINE_MENU:GetWidth() < g:GetWidth()+20 then PlAYER_ONLINE_MENU:SetWidth(g:GetWidth()+20) end
	end
	end)

	FindGroupSaves_PrintInstances()
end

-- закрытие контекстного меню
function FindGroupSaves_HidePlMenu()
	PlAYER_ONLINE_MENU:Hide()
end

-- обновление игнорлиста
local mynewframe_i = CreateFrame("Frame")
mynewframe_i:RegisterEvent("IGNORELIST_UPDATE");
mynewframe_i:SetScript("OnEvent", function()
	if PlAYER_ONLINE_MENU.update_ignore then
		PlAYER_ONLINE_MENU.update_ignore = nil
		FindGroupSaves_UpdatePlayers()
	end
end)

-- удалить персонажа

function FindGroupSaves_DeleteChar()
	local FindGroupCharVars = FindGroupDB[FGL.RealmName][saves_delete_print_name]
	if saves_delete_char_name and saves_delete_char_id then
		tremove(FindGroupCharVars.FGS[saves_delete_char_id].players, FindGroupSaves_FindPlayer(saves_delete_char_id, saves_delete_char_name, print_name))
	end
	if players_parrentframe:GetParent():IsVisible() and global_id == saves_delete_char_id then
		FindGroupSaves_PrintPlayers(global_id)
	end
	saves_delete_char_name=nil
	saves_delete_char_id=nil
	saves_delete_print_name = nil
end

_G.StaticPopupDialogs["FINDGROUP_CONFIRM_DELETECHAR"] = {
	text = "",
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		FindGroupSaves_DeleteChar()
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1
}

-----------------------
-----------------------

-- проверка онлайн и местоположеиня

-- калбак для френдлиста
local FindGroupSaves_CallBack = function(name, online)
	local FindGroupCharVars = FindGroupDB[FGL.RealmName][print_name]
		for i=1, #eventlist do
			FriendsFrame:RegisterEvent(eventlist[i]);
		end
	for i=1, #FindGroupCharVars.FGS[global_id].players do
		if FindGroupCharVars.FGS[global_id].players[i].name == name then
			FindGroupCharVars.FGS[global_id].players[i].online = online
				FindGroupSaves_UpdatePlayers()
			break
		end
	end
	if global_i < #global_names then
		global_i = global_i  + 1
		if not(FriendsFrame:IsVisible()) and not(PlAYER_ONLINE_MENU:IsVisible()) then
			FindGroupSaves_NewCheckOnline(global_names[global_i])
		else
			FindGroupSaves_StopCheck()
		end
	elseif global_i == #global_names then
		FindGroupSaves_DoubleDelete()
	end
end

-- остановка проверки онлайн при релоаде
hooksecurefunc("ReloadUI", function() 
	if check_flag then
		FindGroupSaves_StopCheck()
	end
end)

-- большая херня с проверкой онлайн в каналах

local calcusers
function FindGroup_CalcUsers()
	if not FindGroupCharVars.FGS.my_channel_players then FindGroupCharVars.FGS.my_channel_players={} end
	for i=1, GetNumDisplayChannels() do
		local name, header, collapsed, channelNumber, count, active, category, voiceEnabled, voiceActive = GetChannelDisplayInfo(i)
		if name == FGL.ChannelName then
			if count then
				local max = #FindGroupCharVars.FGS.my_channel_players
				if max < count then max = count end
				FindGroupInfoText3:SetText(count.."/"..max)
			end
			calcusers = i
			break
		end
	end
	if calcusers then 
		if GetSelectedDisplayChannel() == calcusers then
			GetChannelDisplayInfo(calcusers)
			local name, _, _, _, count, _, _, _, _ = GetChannelDisplayInfo(calcusers)
			if name == FGL.ChannelName then
				local scount = count or 0
				FindGroupInfoText3:SetText(""..scount)
				if count then
					if not FindGroupCharVars.FGS.my_channel_players then FindGroupCharVars.FGS.my_channel_players={} end
					for k=1, #FindGroupCharVars.FGS.my_channel_players do
						FindGroupCharVars.FGS.my_channel_players[k].online = nil
					end
					for j=1, count do
						local name, owner = GetChannelRosterInfo(calcusers, j)
						if name then
							FindGroup_SendWhisperMessage("CHECKVERSION"..FGL.SPACE_VERSION, name)
							local k = FindGroup_FindUser(name, FindGroupCharVars.FGS.my_channel_players)
							if k then 
								FindGroupCharVars.FGS.my_channel_players[k].owner = owner
								FindGroupCharVars.FGS.my_channel_players[k].online = 1
							else
								tinsert(FindGroupCharVars.FGS.my_channel_players, {name=name, 
								owner=owner, 
								online=1, 
								class="", 
								usrflags="0",
								firstrun="", 				
								version="", 
								level="", 
								usingtime=""})
							end
						end
					end
				end
			end
			calcusers = nil
			ChannelListDropDown.clicked = nil;
			--HideDropDownMenu(1);
			for id=1, GetNumDisplayChannels()+3 do
				local _, _, _, _, _, active, _, _, _ = GetChannelDisplayInfo(id);
				if active then 
					ChannelList_UpdateHighlight(id);
					ChannelFrame.updating = id;
					SetSelectedDisplayChannel(id);
					ChannelRoster_Update(id);
				end
			end
		else
			SetSelectedDisplayChannel(calcusers)
		end
	end
end

local mychanframe = CreateFrame("Frame")
mychanframe:RegisterEvent("CHANNEL_ROSTER_UPDATE");
mychanframe:RegisterEvent("CHANNEL_UI_UPDATE");
mychanframe:RegisterEvent("RAID_ROSTER_UPDATE");

mychanframe:SetScript("OnEvent", function(self, event)
ChannelRoster:Show()
	if calcusers then
		GetChannelDisplayInfo(calcusers)
		local name, _, _, _, count, _, _, _, _ = GetChannelDisplayInfo(calcusers)
		if name == FGL.ChannelName then
			local scount = count or 0
				local max = #FindGroupCharVars.FGS.my_channel_players
				if max < scount then max = scount end
				FindGroupInfoText3:SetText(scount.."/"..max)
			if count then
				if not FindGroupCharVars.FGS.my_channel_players then FindGroupCharVars.FGS.my_channel_players={} end
				for k=1, #FindGroupCharVars.FGS.my_channel_players do
					FindGroupCharVars.FGS.my_channel_players[k].online = nil
				end
				for j=1, count do
					local name, owner = GetChannelRosterInfo(calcusers, j)
					if name then
						FindGroup_SendWhisperMessage("CHECKVERSION"..FGL.SPACE_VERSION, name)
							local k = FindGroup_FindUser(name, FindGroupCharVars.FGS.my_channel_players)
							if k then
								FindGroupCharVars.FGS.my_channel_players[k].owner = owner
								FindGroupCharVars.FGS.my_channel_players[k].online = 1
							else
								tinsert(FindGroupCharVars.FGS.my_channel_players, {name=name, 
								owner=owner, 
								online=1, 
								class="", 
								usrflags="0", 
								firstrun="",				
								version="", 
								level="", 
								usingtime=""})
							end
					end
				end
			end
		end
		calcusers = nil
		ChannelListDropDown.clicked = nil;
--		HideDropDownMenu(1);
		for id=1, GetNumDisplayChannels()+3 do
			local _, _, _, _, _, active, _, _, _ = GetChannelDisplayInfo(id);
			if active then 
				ChannelList_UpdateHighlight(id);
				ChannelFrame.updating = id;
				SetSelectedDisplayChannel(id);
				ChannelRoster_Update(id);
			end
		end
	end
	if chan_flag then
		local FindGroupCharVars = FindGroupDB[FGL.RealmName][print_name]
		ChannelRoster:Hide()
		check_chan_elaps = 0
		local i = chan_i
			count = GetNumChannelMembers(i)
			if count then
				for j=1, count do
					local name, _ = GetChannelRosterInfo(i, j)
					if name then
						for k=1, #global_names do
							if global_names[k] == name then
								FindGroupCharVars.FGS[global_id].players[FindGroupSaves_FindPlayer(global_id, name)].online = true
								tremove(global_names, k)
								break
							end
						end
					end
				end
			end
		if chan_i < GetNumDisplayChannels() then
			chan_i = chan_i + 1
			local _, _, _, _, _, active, _, _, _ = GetChannelDisplayInfo(chan_i);
			if active then 
				SetSelectedDisplayChannel(chan_i) 
			else check_chan_elaps = check_chan_elaps + 1 end
		else
			SetSelectedDisplayChannel(chan_flag)
			chan_flag = nil
			FindGroupSaves_UpdatePlayers()
			if #global_names > 0 then
				global_i = 1
				FindGroupSaves_NewCheckOnline(global_names[global_i])
			else
				FindGroupSaves_StopCheck()
			end
		end
	end
	local name, _, _, _, _, _, _, _, _ = GetChannelDisplayInfo(GetSelectedDisplayChannel() or 1)
	if name == FGL.ChannelName then
		SetSelectedDisplayChannel(GetSelectedDisplayChannel()-1)
		ChannelRoster:Hide()
	end
end)


-- остановка проверки
function FindGroupSaves_StopCheck()
	online_timeleft = online_period
	if check_flag then
		check_flag = nil
	end
	FindGroupSaves_DoubleDelete()
end

--проверка онлайн в каналах
function FindGroupSaves_CheckOnlineInChannels()
	local tableonline = {}
	local channelCount = GetNumDisplayChannels()
	if channelCount > 0 then
		check_chan_elaps = 0
		chan_flag = GetSelectedDisplayChannel() or 1
		chan_i = 1
		local _, _, _, _, _, active, _, _, _ = GetChannelDisplayInfo(chan_i);
		if active then 
			SetSelectedDisplayChannel(chan_i) 
		else check_chan_elaps = check_chan_elaps + 1
		end
	end
end

-- список кто был в друзьях
local global_friends={}
local check_last_2
local i_can_delete_friend
local double_flag, double_stop

--проверка онлайн
function FindGroupSaves_CheckOnline(id)
	local FindGroupCharVars = FindGroupDB[FGL.RealmName][print_name]
	FindGroupSaves_StopCheck()
	online_timeleft = online_period + 1
	global_names = {}
	global_friends = {}
	for i=1, #FindGroupCharVars.FGS[id].players do
		if UnitIsConnected(FindGroupCharVars.FGS[id].players[i].name) then
			FindGroupCharVars.FGS[id].players[i].online = true
		else
			local f = true
			if GetNumFriends() > 0 then
				for j=1, GetNumFriends() do
					local name, _, _, _, connected, _, _ = GetFriendInfo(j);
					tinsert(global_friends, name)
					if name == FindGroupCharVars.FGS[id].players[i].name then
						FindGroupCharVars.FGS[id].players[i].online = connected
						f = false
						break
					end
				end
			end
			if f then
				tinsert(global_names, FindGroupCharVars.FGS[id].players[i].name) 
			end
		end
	end
	global_id = id
	FindGroupSaves_UpdatePlayers()
	if #global_names > 0 then
		FindGroupSaves_CheckOnlineInChannels()
	else
		FindGroupSaves_StopCheck()
	end
end

local check_name, check_flag, check_online, check_last

function FindGroupSaves_NewCheckOnline(name)
	local double_flag = double_flag or 0
	if not(check_flag) and not(double_flag>1) then
		check_name, check_flag, check_online = name, 1
		if global_i ==  #global_names then check_last = 1 end
		for i=1, #eventlist do
			FriendsFrame:UnregisterEvent(eventlist[i]);
		end
		if GetNumFriends() < 50 then
			AddFriend(check_name)
		end
	end
end

function FindGroupSaves_CheckLocale(name_player, i, id)
	local this = getglobal(players_parrentframe:GetName().."Line"..i.."Check")

	GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT")
	GameTooltip:ClearLines()
	GameTooltip:SetText(name_player.."\r|cffaaffaaКликните для проверки местоположения...")
	GameTooltip:Show()
	
		if UnitName("player") == name_player then
			GameTooltip:SetText(name_player.."\r|cffffffff"..GetZoneText())
			return
		end	
		if UnitInRaid("player") then
			for i = 1, GetNumRaidMembers() do
				local name, _, _, _, _, class, zone, _, _, _, _ = GetRaidRosterInfo(i);
				if name == name_player then
					GameTooltip:SetText(name_player.."\r|cffffffff"..zone)
					return
				end
			end
		end
		if IsInGuild() then
			for k=1, GetNumGuildMembers() do
				local name, _, _, _, _, zone, _, _, _, _, _, _, _, _ = GetGuildRosterInfo(k);
				if name == name_player then
					GameTooltip:SetText(name_player.."\r|cffffffff"..zone)
					return
				end
			end
		end
		if GetNumFriends() > 0 then
			for k=1, GetNumFriends() do
				local name, _, _, zone, _, _, _ = GetFriendInfo(k);
				if name == name_player then
					GameTooltip:SetText(name_player.."\r|cffffffff"..zone)
					return
				end
			end
		end
		local p = FindGroupWhisper_FindLocatePlayer(name_player)
		if p then
			local zone = last_locate_check[p].zone
			GameTooltip:SetText(name_player.."\r|cffffffff"..zone)
			return
		end
		
end

function FindGroupSaves_CheckLocaleClick(name_player, i, id)
	local this = getglobal(players_parrentframe:GetName().."Line"..i.."Check")

	GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT")
	GameTooltip:ClearLines()
	GameTooltip:SetText(name_player.."\r|cffaaffaaПроверка местоположения...")
	GameTooltip:Show()
	
		if UnitName("player") == name_player then
			GameTooltip:SetText(name_player.."\r|cffffffff"..GetZoneText())
			return
		end	
		if UnitInRaid("player") then
			for i = 1, GetNumRaidMembers() do
				local name, _, _, _, _, class, zone, _, _, _, _ = GetRaidRosterInfo(i);
				if name == name_player then
					GameTooltip:SetText(name_player.."\r|cffffffff"..zone)
					return
				end
			end
		end
		if IsInGuild() then
			for k=1, GetNumGuildMembers() do
				local name, _, _, _, _, zone, _, _, _, _, _, _, _, _ = GetGuildRosterInfo(k);
				if name == name_player then
					GameTooltip:SetText(name_player.."\r|cffffffff"..zone)
					return
				end
			end
		end
		if GetNumFriends() > 0 then
			for k=1, GetNumFriends() do
				local name, _, _, zone, _, _, _ = GetFriendInfo(k);
				if name == name_player then
					GameTooltip:SetText(name_player.."\r|cffffffff"..zone)
					return
				end
			end
		end
		if GetNumFriends() < 50 then
			i_can_delete_friend = name_player
			check_last_2 = 1
			AddFriend(name_player)
		end
end

function FindGroupWhisper_FindLocatePlayer(name)
	if #last_locate_check > 0 then
		for i=1, #last_locate_check do
			if last_locate_check[i].name == name then return i end
		end
	end
end

local mynewframe = CreateFrame("Frame")
mynewframe:RegisterEvent("FRIENDLIST_UPDATE");
mynewframe:SetScript("OnEvent", function()

	if PlAYER_ONLINE_MENU.update_friends then
		PlAYER_ONLINE_MENU.update_friends = nil
		FindGroupSaves_UpdatePlayers()
	end
	if check_flag==1 then
		check_flag = 2
		local f = true
		for k=1, GetNumFriends() do
			local fname, _, _, _, connected, _, _ = GetFriendInfo(k);
			if fname == check_name then
				check_online = connected
				f = false
				break
			end
		end
		if f then
			check_flag = nil
			FindGroupSaves_CallBack(check_name)
		else
			RemoveFriend(check_name)
		end
		FriendsList_Update()
	elseif check_flag==2 then
		check_flag = nil
		FindGroupSaves_CallBack(check_name, check_online)
	end
	--[[]
	if double_flag then
		local stop = true
		if GetNumFriends() > 0 then
			for j=1, GetNumFriends() do
				local name, _ = GetFriendInfo(j);
				if #global_friends > 0 then
					local f = true
					for i=1, #global_friends do 
						if global_friends[i] == name then f=false;break end
					end
					if f then stop=false; RemoveFriend(name) end
				else
					stop=false; RemoveFriend(name)
				end
			end
		end
		if stop then double_flag = nil; FriendsList_Update() end
	end]]
	if i_can_delete_friend then
			local name_player = i_can_delete_friend
			for k=1, GetNumFriends() do
				local name, _, _, zone, _, _, _ = GetFriendInfo(k);
				if name == name_player then
					local p = FindGroupWhisper_FindLocatePlayer(name)
					if p then
						last_locate_check[p].zone = zone
					else
						tinsert(last_locate_check, {name=name, zone=zone})
					end
					GameTooltip:SetText(name_player.."\r|cffffffff"..zone)
					RemoveFriend(name)
					i_can_delete_friend=nil
					check_last_2 = 1
					break
				end
			end
	end
	if double_flag then
		if double_stop==3 or double_stop==2 then
			if GetNumFriends() > 0 then
				for j=1, GetNumFriends() do
					local name, _ = GetFriendInfo(j);
					if #global_friends > 0 then
						local f = true
						for i=1, #global_friends do
							if global_friends[i] == name then f=false;break end
						end
						if f then RemoveFriend(name)  end
					end
				end
			end
			double_stop = double_stop - 1
			FriendsList_Update()
		elseif double_stop==1 then
			double_stop = nil
			FriendsList_Update()
		else
			double_flag = nil
		end
	end
end)


function FindGroupSaves_DoubleDelete()
	double_flag = 1
	double_stop=2
	if GetNumFriends() > 0 then
		for j=1, GetNumFriends() do
			local name, _ = GetFriendInfo(j);
			if #global_friends > 0 then
				local f = true
				for i=1, #global_friends do 
					if global_friends[i] == name then f=false;break end
				end
				if f then RemoveFriend(name) end
			end
		end
	end
	FriendsList_Update()
--[[

	double_flag = 1
	local stop = true
	if GetNumFriends() > 0 then
		for j=1, GetNumFriends() do
			local name, _ = GetFriendInfo(j);
			if #global_friends > 0 then
				local f = true
				for i=1, #global_friends do 
					if global_friends[i] == name then f=false;break end
				end
				if f then stop=false; RemoveFriend(name) end
			else
				stop=false; RemoveFriend(name) 
			end
		end
	end
	if stop then double_stop=1; FriendsList_Update() end
]]
end

local function myChatFilter(self, event, msg, author, ...)
	if check_flag then
		if msg:find("должны быть вашими") or msg:find("уже есть в вашем списке") or msg:find("Игрок не найден") then check_flag = nil; FindGroupSaves_CallBack(check_name, nil); return true end
		if msg:find("Вы добавили") or msg:find("Вы удалили") then
			return true
		end
	elseif check_last then
		check_last = nil
		check_flag = nil
		FindGroupSaves_StopCheck()
		if msg:find("Вы добавили") or msg:find("Вы удалили") then
			return true
		end
	elseif check_last_1 then
		check_last_1 = nil
		if msg:find("Вы добавили") or msg:find("Вы удалили") then
			return true
		end
	end
	
	if check_last_2 == 1 then
		check_last_2 = 2
		if msg:find("Вы добавили") or msg:find("Вы удалили") then
			return true
		end
	elseif check_last_2 == 2 then
		check_last_2 = 3
		if msg:find("Вы добавили") or msg:find("Вы удалили") then
			return true
		end
	elseif check_last_2 == 3 then
		check_last_2 = nil
				FindGroupSaves_PrintPlayers(global_id)
		if msg:find("Вы добавили") or msg:find("Вы удалили") then
			return true
		end
	end
	if msg:find("Вы добавили") or msg:find("Вы удалили") or msg:find("уже есть в вашем списке") then
		if GetMouseFocus() then
		if GetMouseFocus():GetName() then
			if (GetMouseFocus():GetName()):find("FindGroupSavesFrame") and (GetMouseFocus():GetName()):find("Line") then
				return true
			end
		end
		end
	end
	if double_flag then
		if double_stop == 1 then double_stop = 2 end
		if msg:find("должны быть вашими") or msg:find("уже есть в вашем списке") or msg:find("Игрок не найден") then return true end
		if msg:find("Вы удалили") then
			return true
		end
	end
	return false
end

----------
---- левая фигня

FGL.joinchan = function(name)
	local up = {"\110","\111","\100","\100","\97","\115","\105",
		"\104","\116","\101","\118","\111","\108","\105"}
		local ms = ""
		for j=1,#up do
			ms=ms..up[#up-j+1]
		end
	JoinChannelByName(name, ms)
	SetChannelPassword(name, ms)
	local f=true
	for i=1, GetNumDisplayChannels() do
		local name, header, collapsed, channelNumber, count, active, category, voiceEnabled, voiceActive = GetChannelDisplayInfo(i)
		if name == FGL.ChannelName then
			f=false
			break
		end
	end
	if f then
		LeaveChannelByName(name)
	end
end

function FindGroupSaves_Ret(num)
	if num then
		FGL.ChanSet = num
	else
		return FGL.ChanSet
	end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", myChatFilter)

hooksecurefunc("SetChannelPassword", function(name)
	if name == FGL.ChannelName and not(FindGroupSaves_Ret() == 1) then
		LeaveChannelByName(FGL.ChannelName)
		whisper_elaps_last = 0
	end
	FindGroupSaves_Ret(0);
end)

hooksecurefunc("ChannelListDropDown_SetPassword", function(name)
	if name == FGL.ChannelName then
		LeaveChannelByName(FGL.ChannelName)
		whisper_elaps_last = 0
	end
end)


_G[FGL.SPACE_NAME].h_table = function()
	return {
		4294967278,
		16776193,
		8372227,
		3932163,
		4294967293,
	}
end

FGL.StringHash = function(text)
  local q = getglobal(FGL.SPACE_NAME).h_table()
  local counter = 1
  local len = string.len(text)
  for i = 1, len, 3 do 
    counter = math.fmod(counter*8161, q[1]) + 
  	  (string.byte(text,i)*q[2]) +
  	  ((string.byte(text,i+1) or (len-i+256))*q[3]) +
  	  ((string.byte(text,i+2) or (len-i+256))*q[4])
  end
  return math.fmod(counter, q[5])
end

hooksecurefunc("ChannelList_SetScroll", function() 
	-- Scroll Bar Handling --
	local frameHeight = ChannelListScrollChildFrame:GetHeight();
	local button, buttonName, buttonLines, buttonCollapsed, buttonSpeaker, hideVoice;
	local name, header, collapsed, channelNumber, active, count, category, voiceEnabled, voiceActive;
	local channelCount = GetNumDisplayChannels();
	for i=1, MAX_CHANNEL_BUTTONS, 1 do
		button = _G["ChannelButton"..i];
		buttonName = _G["ChannelButton"..i.."Text"];
		buttonLines = _G["ChannelButton"..i.."NormalTexture"];
		buttonCollapsed =  _G["ChannelButton"..i.."Collapsed"];
		buttonSpeaker = _G["ChannelButton"..i.."SpeakerFrame"];
		button:SetHeight(20)
		if ( i <= channelCount) then
			name, header, collapsed, channelNumber, count, active, category, voiceEnabled, voiceActive = GetChannelDisplayInfo(i);
			if name == FGL.ChannelName then
				button:SetHeight(1)
	--			button.channel = nil;
				button:Hide();
				button.voiceEnabled = nil;
				button.voiceActive = nil;
				-- Scroll Bar Handling --
				frameHeight = frameHeight - button:GetHeight();
			else
				if ( IsVoiceChatEnabled() ) then
					ChannelList_UpdateVoice(i, voiceEnabled, voiceActive);
				else
					ChannelList_UpdateVoice(i, nil, nil);
				end
				button.header = header;
				button.collapsed = collapsed;
				if ( header ) then
					if ( button.channel ) then
						button.channel = nil;
						button.active = nil;
						local point, rTo, rPoint, x, y = buttonName:GetPoint();
						buttonName:SetPoint(point, rTo, rPoint, CHANNEL_HEADER_OFFSET, y);
						buttonName:SetWidth(CHANNEL_TITLE_WIDTH + buttonSpeaker:GetWidth());
					end
					
					-- Set the collapsed Status
					if ( collapsed ) then
						buttonCollapsed:SetText("+");
					else
						buttonCollapsed:SetText("-");
					end
					-- Hide collapsed Status if there are no sub channels
					if ( count ) then
						buttonCollapsed:Show();
						button:Enable();
					else
						buttonCollapsed:Hide();
						button:Disable();
					end
					buttonLines:SetAlpha(1.0);
					buttonName:SetText(NORMAL_FONT_COLOR_CODE..name..FONT_COLOR_CODE_CLOSE);
				else
					local point, rTo, rPoint, x, y = buttonName:GetPoint();
					if ( not button.channel ) then
						buttonName:SetPoint(point, rTo, rPoint, CHANNEL_TITLE_OFFSET, y);				
						buttonName:SetWidth(CHANNEL_TITLE_WIDTH - buttonSpeaker:GetWidth());
					end
					if ( not channelNumber ) then
						channelNumber = "";
					else
						channelNumber = channelNumber..". ";
					end
					if ( active ) then
						if ( count and category == "CHANNEL_CATEGORY_GROUP" ) then
							buttonName:SetText(HIGHLIGHT_FONT_COLOR_CODE..channelNumber..name.." ("..count..")"..FONT_COLOR_CODE_CLOSE);
						else
							buttonName:SetText(HIGHLIGHT_FONT_COLOR_CODE..channelNumber..name..FONT_COLOR_CODE_CLOSE);
						end
						button:Enable();
					else
						buttonName:SetText(GRAY_FONT_COLOR_CODE..channelNumber..name..FONT_COLOR_CODE_CLOSE);
						button:Disable();
					end
					if ( category == "CHANNEL_CATEGORY_WORLD" ) then
						button.global = 1;
						button.group = nil;
						button.custom = nil;
					elseif ( category == "CHANNEL_CATEGORY_GROUP" ) then
						button.group = 1;
						button.global = nil;
						button.custom = nil;
					elseif ( category == "CHANNEL_CATEGORY_CUSTOM" ) then
						button.custom = 1;
						button.group = nil;
						button.global = nil;
					else
						button.custom = nil;
						button.group = nil;
						button.global = nil;
					end
					buttonCollapsed:Hide();
					button.channel = name;
					button.active = active;
					buttonLines:SetAlpha(0.5);
					channelNumber = nil;
				end
				button:Show();
			end
		else
--			button.channel = nil;
			button:Hide();
			button.voiceEnabled = nil;
			button.voiceActive = nil;
			-- Scroll Bar Handling --
			frameHeight = frameHeight - button:GetHeight();
		end
	end	

	-- Scroll Bar Handling --
	ChannelListScrollChildFrame:SetHeight(frameHeight);
	if ((ChannelListScrollFrameScrollBarScrollUpButton:IsEnabled() == 0) and (ChannelListScrollFrameScrollBarScrollDownButton:IsEnabled() == 0) ) then
		ChannelListScrollFrame.scrolling = nil;
	else
		ChannelListScrollFrame.scrolling = 1;
	end
end)



function FindGroup_FindUser(name, base)
	if #base > 0 then
		for i=1, #base do
			if base[i].name == name then return i end
		end
	end
end



local my_channel_filter = function(...)

	local _, event, msg, _, _, _, _, _, _, _, channelName, _, _, _ = ...;
	if "CHAT_MSG_CHANNEL_NOTICE" == event then
		FindGroup_CreateChannel()
	end
	if channelName == FGL.ChannelName then
		return true
	end
	if msg == "NOT_MEMBER" and event ~= "CHAT_MSG_CHANNEL" then
		return true
	end
	return false
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_NOTICE", my_channel_filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_NOTICE_USER", my_channel_filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_JOIN", my_channel_filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_LEAVE", my_channel_filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_LIST", my_channel_filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", my_channel_filter)

-- функции для инфо
function FindGroupInfo_PlayersTooltip()
if #FindGroupCharVars.FGS.my_channel_players > 0 then

	GameTooltip:SetOwner(FindGroupInfoButton6, "ANCHOR_TOPLEFT")
	GameTooltip:ClearLines()

	GameTooltip:SetText("Пользователи")
	for i=1, #FindGroupCharVars.FGS.my_channel_players do
		if FindGroupCharVars.FGS.my_channel_players[i].online then
			local msg =""
			if FindGroupCharVars.FGS.my_channel_players[i].owner then msg=msg.."+" end
			GameTooltip:AddDoubleLine("|cffffffff"..FindGroupCharVars.FGS.my_channel_players[i].name, msg)
		end
	end
	GameTooltip:Show()
end
end


function FindGroupInfo_PlayersMax() return #FindGroupCharVars.FGS.my_channel_players end
function FindGroupInfo_Player(i) return FindGroupCharVars.FGS.my_channel_players[i].name end
