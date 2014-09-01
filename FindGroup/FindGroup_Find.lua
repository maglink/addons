local double_message={}

------------------------------------------------------------------------FIND FUNCTION---------------------------------------------------------------------------------------------------------------
--[[
local get_msg_frame = CreateFrame("Frame")
get_msg_frame:RegisterEvent("CHAT_MSG_OFFICER")
get_msg_frame:RegisterEvent("CHAT_MSG_CHANNEL")
get_msg_frame:RegisterEvent("CHAT_MSG_GUILD")
get_msg_frame:RegisterEvent("CHAT_MSG_YELL")
get_msg_frame:RegisterEvent("CHAT_MSG_SYSTEM")
get_msg_frame:SetScript("OnEvent", function(...) FindGroup_GFIND(...) end)
]]



local my_channel_filter = function(...)
	if FindGroup_GFIND(...) then
		if falsetonil(FGL.db.channelfilterstatus) then
			return true
		end
	end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", my_channel_filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", my_channel_filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", my_channel_filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", my_channel_filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", my_channel_filter)

function FindGroup_GFIND(...)

	local self, event, msg, sender, lang, channel, target, flags, unknown, channelNumber, channelName, unknown, counter, guid = ...;

	if FindGroup_getignor(sender) then return end -- если отправитель в игнорлисте
	
	---галочки в опциях
	if not falsetonil(FGL.db.closefindstatus) and not FindGroupFrame:IsVisible() then return end -- фоновый режим
	if not falsetonil(FGL.db.channelguildstatus) and event == "CHAT_MSG_OFFICER" then return end -- канал гильдии
	if not falsetonil(FGL.db.channelguildstatus) and event == "CHAT_MSG_GUILD" then return end -- канал гильдии
	if not falsetonil(FGL.db.channelyellstatus) and event == "CHAT_MSG_YELL" then return end -- канал крика
	if not falsetonil(FGL.db.raidfindstatus) then -- поиск своих сообщений и сообщений группы/рейда
		if UnitInRaid(sender) or UnitInParty(sender) then 
			return 
		end
	end
	---
	
	
	--анонс (системное сообщение)
	local NOTICE_BG = false
	if event == "CHAT_MSG_SYSTEM" then
		local x, y = (string.lower(msg)):find("анон")
		if x then
			if FindGroupCharVars.battlemode then
				if not(FindGroupCharVars.battlemodepatch) 
				or FindGroupCharVars.battlemodepatch == 1 then
					sender = strsub(msg, x, x+14)
					msg = strsub(msg, x+19)
					NOTICE_BG = true
				else 
					return 
				end
			else 
				return
			end
		else
			return
		end
	end

	local msg, lmsg = FindGroup_EditMSG(msg) -- создание поискового шаблона и преобразование сообщения

	-- проверка на добавление к предыдущему сообщению 
	if double_message.name then
		if GetTime() - double_message.time < 1 then
			for i=1, FGL.db.nummsgsmax do
				if FGL.db.lastmsg[i] then
					if FGL.db.lastmsg[i][2] then
						local findtext = FGL.db.lastmsg[i][1]
						if not findtext then findtext = "" end
						if FGL.db.lastmsg[i][2]==sender and not(lmsg==findtext) and not(lmsg:find(findtext)) then
							FGL.db.lastmsg[i][1]= FGL.db.lastmsg[i][1]..lmsg
							FGL.db.lastmsg[i][1] = string.gsub(FGL.db.lastmsg[i][1], "|r", "|r|cff" .. FGL.db.lastmsg[i][8] .. "")
							double_message={}
							FGL.db.lastmsg[i][14] = FindGroup_FindAchieve(FGL.db.lastmsg[i][1], IR)
							FGL.db.lastmsg[i][15] = FindGroup_FindQuest(FGL.db.lastmsg[i][1], IR)
							return
						end
					end
				end
			end
		end
	end

	-- предварительное определение инстанса
	local favorite = FindGroup_GetInstFav(msg, 1, 1)

	if favorite == 0 then
		if FindGroup_FindException1(msg) then return end
		if FindGroup_FindException(msg) then return end
	end

	local achieve 
	local IR -- режим сложности
	local new_text -- с отсеченным текстом ачивки
	
	-- повторное определение инстанса с хар-ками
	favorite, achieve, IR, new_text = FindGroup_GetInstFav(msg, 1)

	if not(favorite > 0) then return end -- Если до сихпор не определен инстанс, то сообщение отсекается
	
	if event == "CHAT_MSG_SYSTEM" and FGL.db.instances[favorite].patch ~= "notice" then return 
	elseif event ~= "CHAT_MSG_SYSTEM" and FGL.db.instances[favorite].patch == "notice" then return
	end
	
	-----------------patches
		
		for h=1, #FGL.db.patches do
			if FGL.db.instances[favorite].patch == FGL.db.patches[h].point then 
				if FGL.db.findpatches[h] == false then return end
			end
		end
		
	-----------------findlist

		if not IR then  
			IR = FindGroup_GetInstIR(msg, favorite)
		end
		if IR == 1 then
			if not falsetonil(FGL.db.findlistvalues[1]) then return end
		elseif IR == 2 then
			if not falsetonil(FGL.db.findlistvalues[2]) then return end
		elseif IR == 3 or IR == 5 or IR == 7 or IR == 8 then
			if not falsetonil(FGL.db.findlistvalues[3]) then return end
		elseif IR == 4 or IR == 6 then
			if not falsetonil(FGL.db.findlistvalues[4]) then return end
		end
		
		
		if new_text then
			msg = new_text
		end
		
			---------------------------------------------------------------
		local neednow={}
	---------------
	------- heal

	neednow[1] = FindGroup_FindNeedNow(msg, 1, FGL.db.roles.heal, FGL.db.iconclasses.heal)

	------- DD

	neednow[2] = FindGroup_FindNeedNow(msg, 2, FGL.db.roles.attack, FGL.db.iconclasses.dd)

	------- tank

	neednow[3] = FindGroup_FindNeedNow(msg, 3, FGL.db.roles.tank, FGL.db.iconclasses.tank)

	----- all

	for i=1, #FGL.db.roles.all.search.criteria do 
		if msg:find(FGL.db.roles.all.search.criteria[i]) then 
			for f=1,3 do 
				neednow[f] = 1 
			end
			break
		end
	end
			for f=1,3 do 
				if neednow[f] then
					neednow[f] = 1 
				end
			end


	---------
	if not falsetonil(FGL.db.iconstatus) then 
	if not(FGL.db.needs[1] and neednow[1]) then  neednow[1] = nil end
	if not(FGL.db.needs[2] and neednow[2]) then  neednow[2] = nil end
	if not(FGL.db.needs[3] and neednow[3]) then  neednow[3] = nil end
	end
		if not(FGL.db.needs[1] and neednow[1]) and not(FGL.db.needs[2] and neednow[2]) and not(FGL.db.needs[3] and neednow[3]) then 
			if favorite == 0 then
				return 
			end
			--[[]
			elseif FGL.db.instances[favorite].patch == "notice" then
				return 
			end
			]]
		end
		----------------------------------------------------------------------------------------------
	--______________________

		if not(neednow[1]) and not(neednow[2]) and not(neednow[3]) then
			if FGL.db.instances[favorite].patch ~= "notice" and FGL.db.instances[favorite].patch ~= "pvp" then
				return
			end
		end
		
		
	-------------------

			if not achieve then  
				achieve = FindGroup_FindAchieve(lmsg, IR)
				if not achieve then  
					achieve = FindGroup_FindAchieve(msg, IR) 
				end
			end
			local quest = FindGroup_FindQuest(lmsg, IR)
				if not quest then quest = FindGroup_FindQuest(msg, IR) end
			local rep = FindGroup_FindRep(lmsg)
				if not rep then rep = FindGroup_FindRep(msg) end
			local arena_flag = FindGroup_FindArena(lmsg, favorite)
				if arena_flag then
					neednow ={}
					if quest then
						return
					end
				end
					local nownum, colorenab
					for i=1, FGL.db.nummsgsmax do
						--if FGL.db.lastmsg[i][2] == sender and FGL.db.lastmsg[i][5] == favorite and FGL.db.lastmsg[i][6] == IR then nownum = i end
						if FGL.db.lastmsg[i][2] == sender then 
						if FGL.db.lastmsg[i][1] == lmsg then colorenab = 1 end
						nownum = i 
						end
					end
			local snownum = 0
			
					if not nownum then
					local funclastmsg={}
					for i=1,FGL.db.nummsgsmax do funclastmsg[i]=FGL.db.lastmsg[i] end
					for i=1,FGL.db.nummsgsmax do
					if not FGL.db.lastmsg[i+1] then FGL.db.lastmsg[i+1]={} end
					FGL.db.lastmsg[i+1]=funclastmsg[i]
					FGL.db.lastmsg[i+1][11]=nil
					end
					FGL.db.nummsgsmax = FGL.db.nummsgsmax + 1
					nownum = 1
					snownum = 1
					end
			
				if not FGL.db.lastmsg[nownum] then FGL.db.lastmsg[nownum]={} end
					local s_color = "ff1111"
					if event ~= "CHAT_MSG_SYSTEM" then
						s_color = FindGroup_funcgetcolor(select(2,GetPlayerInfoByGUID(guid)))
					end
					local s_nowtime = string.format("|cff%02x%02x%02x[%s:%s:%s]|r",0.63*255,0.63*255,0.63*255,  date("%H"), date("%M"), date("%S"))
					FGL.db.lastmsg[nownum] = {
						lmsg, 															
						sender,
						date("%M"),
						date("%S"),
						favorite,
						IR,
						s_color,
						"ffffff",
						NOTICE_BG,
						FindGroup_getneedsTEXT(neednow[1], neednow[2], neednow[3]),		--10
						msg,
						0,
						s_nowtime,
						achieve,
						quest,
						rep,
						arena_flag
					}

				double_message.time = GetTime()
				double_message.name = sender
		
		
		--- РАССКРАСКА начало
				local instcd
				if event ~= "CHAT_MSG_SYSTEM" then
					instcd = FindGroup_GetInstInfo(nownum)
				end
				if instcd then
					if falsetonil(FGL.db.raidcdstatus) then
						FGL.db.lastmsg[nownum][8] = string.format("%02x%02x%02x",0.63*255,0.63*255,0.63*255)
					else
						FindGroup_ClearText(nownum)
						return
					end
				else
					local scolor = "PARTY_LEADER"
					if FGL.db.instances[favorite].patch == "events" then
						scolor="WHISPER"
					elseif FGL.db.instances[favorite].patch == "pvp" then
						scolor="SAY"
					elseif FGL.db.instances[favorite].patch == "notice" then
						scolor="SYSTEM"
					else
						local fl = 0
						for j=1, string.len(FGL.db.instances[favorite].difficulties) do
							if FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[favorite].difficulties, j, j))].maxplayers > 5 then fl = 1 end
							if FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[favorite].difficulties, j, j))].maxplayers < 6 then scolor = "PARTY" end
						end
						if fl == 1 and scolor == "PARTY_LEADER" then scolor = "RAID" end
						if fl == 1 and scolor == "PARTY" then scolor = "PARTY_LEADER" end
					end
					FGL.db.lastmsg[nownum][8] = string.format("%02x%02x%02x",ChatTypeInfo[scolor].r*255,ChatTypeInfo[scolor].g*255,ChatTypeInfo[scolor].b*255)
					
				end
				FGL.db.lastmsg[nownum][1] = string.gsub(FGL.db.lastmsg[nownum][1], "|r", "|r|cff" .. FGL.db.lastmsg[nownum][8] .. "")
		--- РАССКРАСКА конец
			
			----------------------CHECK alarm
			
			if falsetonil(FGL.db.alarmstatus) and not(colorenab) then
				if FindGroup_CheckAlarm(favorite, IR, achieve, instcd, NOTICE_BG) then
					FindGroup_Alarm(lmsg)
				end
			end
			
			---------------------
			
			if snownum==1 then -- новая строка?
				if FGL.db.enterline > 0 then -- курсор завис над одной из строк?
					local k
					k = FGL.db.enterline - FindGroupFrameSlider:GetValue()
					local max = 17
					local buf={}
				
					for i=1,max do buf[i] = FGL.db.lastmsg[k][i] end
					FGL.db.lastmsg[k]={}
				
					for i=1,max do FGL.db.lastmsg[k][i] = FGL.db.lastmsg[k+1][i]  end
					FGL.db.lastmsg[k+1]={}
				
					for i=1,max do FGL.db.lastmsg[k+1][i] = buf[i] end	
					buf={}
				end
			end
			
			FindGroup_AllReWrite() 
			FindGroup_SliderCheck() -- проверка видимости и положения слайдера сообщений
				
	return true -- выход с добавлением сообщения в окно поиска
end

---------------------------------------------------------------END FIND FUNCTION------------------------------------------------------------------------------------------------------------------------------

local function chsize(char)
    if not char then
        return 0
    elseif char > 240 then
        return 4
    elseif char > 225 then
        return 3
    elseif char > 192 then
        return 2
    else
        return 1
    end
end
 
  local function utf8sub(str, startChar, numChars)
  local startIndex = 1
  while startChar > 1 do
      local char = string.byte(str, startIndex)
      startIndex = startIndex + chsize(char)
      startChar = startChar - 1
  end
 
  local currentIndex = startIndex
 
  while numChars > 0 and currentIndex <= #str do
    local char = string.byte(str, currentIndex)
    currentIndex = currentIndex + chsize(char)
    numChars = numChars -1
  end
  return str:sub(startIndex, currentIndex - 1)
end

function FindGroup_getignor(sender)
for num=1, GetNumIgnores() do if sender == GetIgnoreName(num) then return 1 end end
end

function FindGroup_getneedsTEXT(a,b,c)
if a and b and c then
	if not falsetonil(FGL.db.iconstatus) then
	if FGL.db.needs[1] and FGL.db.needs[2] and FGL.db.needs[3] then return 123
	elseif FGL.db.needs[1] and FGL.db.needs[2] then return 12
	elseif FGL.db.needs[1] and FGL.db.needs[3] then return 13
	elseif FGL.db.needs[2] and FGL.db.needs[3] then return 23
	end
else
	return 123
end
elseif a and b then
	if not falsetonil(FGL.db.iconstatus) then
	if FGL.db.needs[1] and FGL.db.needs[2] then return 12
	elseif FGL.db.needs[1] then return 1
	elseif FGL.db.needs[2] then return 2
	end
else
	return 12
end
elseif a and c then
	if not falsetonil(FGL.db.iconstatus) then
	if FGL.db.needs[1] and FGL.db.needs[3] then return 13
	elseif FGL.db.needs[1] then return 1
	elseif FGL.db.needs[3] then return 3
	end
else
	return 13
end
elseif b and c then
	if not falsetonil(FGL.db.iconstatus) then
	if FGL.db.needs[2] and FGL.db.needs[3] then return 23
	elseif FGL.db.needs[2] then return 2
	elseif FGL.db.needs[3] then return 3
	end
else
	return 23
end
elseif a then return 1
elseif b then return 2
elseif c then return 3
end
end

local add_find_text ={{"героич", "10 игроков"}, {"героич", "25 игроков"}, "героич", "10 игроков", "25 игроков"}
function findpattern(text, pattern, start)
	if string.find(text, pattern, start) then
		return string.sub(text, string.find(text, pattern, start))
	end
end


function FindGroup_GetInstFav(msg, flag, pvp_flag)

-- Achieve
	local x_g, y_g = string.find(msg, "[", nil, true)
	
	if flag then
	for i=1, #FGL.db.instances do
		local check = 1
		if pvp_flag then
			if not(FGL.db.instances[i].patch == "pvp") and not(FGL.db.instances[i].patch == "notice") then
				check = nil
			end
		end
		if check then
			if x_g and y_g then
				if FGL.db.instances[i].achieve then
					for j=1, #FGL.db.difficulties do
						if FGL.db.instances[i].achieve[j] then
							for k = 1, #FGL.db.instances[i].achieve[j] do
								local id = FGL.db.instances[i].achieve[j][k]
								local achieve = GetAchievementLink(id)
								if achieve then
									local x, y = achieve:find("|h")
									achieve = string.sub(achieve, y+2, strlen(achieve))
									x, y = achieve:find("|h")
									achieve = string.sub(achieve, 1, x-2)
									achieve, _ = FindGroup_EditMSG(achieve)
									local num_add_text
									for l=1, #add_find_text do
										if type(add_find_text[l]) == 'table' then
											if achieve:find(add_find_text[l][1]) and achieve:find(add_find_text[l][2]) then
												local x, y = achieve:find(add_find_text[l][1])
												achieve = string.sub(achieve, 1, x-3)
												num_add_text = l
												break
											end
										else
											if achieve:find(add_find_text[l]) then
												local x, y = achieve:find(add_find_text[l])
												achieve = string.sub(achieve, 1, x-3)
												num_add_text = l
												break
											end
										end
									end
									local x_n, y_n = msg:find(achieve)
									if x_n and y_n then
										if x_g - x_n < 6 and x_g - x_n > -6 then
											local new_text = string.sub(msg, 1, x_g-1)
											local ahv_x, ahv_y = string.find(string.sub(msg, x_g+1), "]", nil, true)
											if ahv_x and ahv_y then
												new_text = new_text..string.sub(msg, ahv_y+1)
												if num_add_text then
													local l = num_add_text
													if type(add_find_text[l]) == 'table' then
														if msg:find(add_find_text[l][1]) and msg:find(add_find_text[l][2]) then
															return i, GetAchievementLink(id), j, new_text
														end
													else
														if msg:find(add_find_text[l]) then
															return i, GetAchievementLink(id), j, new_text
														end
													end
												else
													return i, GetAchievementLink(id), j, new_text
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	end

--Criteria

	for i=1, #FGL.db.instances do
		local check = 1
		if pvp_flag then
			if not(FGL.db.instances[i].patch == "pvp") and not(FGL.db.instances[i].patch == "notice") then
				check = nil
			end
		end
		if check then
		for j=1, #FGL.db.instances[i].search.criteria do
			if type(FGL.db.instances[i].search.criteria[j]) == 'table' then
				if #FGL.db.instances[i].search.criteria[j] == 1 then
					if string.sub(msg, 1, string.len(FGL.db.instances[i].search.criteria[j][1])+2):find(FGL.db.instances[i].search.criteria[j][1]) then 
						local new_text = string.sub(msg, string.len(FGL.db.instances[i].search.criteria[j][1])+1)
						return i, nil, nil, new_text
					end
				else
					local f=1
					for h=1, #FGL.db.instances[i].search.criteria[j] do
						if not(msg:find(FGL.db.instances[i].search.criteria[j][h])) then f = 0 end
					end
					if f==1 then return i end
				end
			else
				if msg:find(FGL.db.instances[i].search.criteria[j]) then
					local new_text = string.gsub(msg, FGL.db.instances[i].search.criteria[j], " ")
					return i, nil, nil, new_text
				end
			end
		end
		end
	end

	return 0
end

function FindGroup_FindAchieve(msg, diff)
	local achieve_x, y = msg:find("|Hachievement:")
	if achieve_x then
		local achieve = string.sub(msg, achieve_x-10, string.len(msg))
		local x, y = msg:find("]|h")
		local achieve_link = string.sub(achieve, 1, y)
		local _, id, _ = strsplit(":", achieve)
		return achieve_link
	end
	for i=2, #FGL.db.achievements do
		for j=1, #FGL.db.achievements[i].criteria do
			if msg:find(FGL.db.achievements[i].criteria[j]) then
				if FGL.db.achievements[i].checkdiff then
					if (FGL.db.achievements[i].checkdiff):find(""..diff) then
						return GetAchievementLink(FGL.db.achievements[i].id)
					end
				else
					return  GetAchievementLink(FGL.db.achievements[i].id)
				end
			end
		end
	end
	local i = 1
	for j=1, #FGL.db.achievements[i].criteria do
		if msg:find(FGL.db.achievements[i].criteria[j]) then
			return "true"
		end
	end
end

function FindGroup_FindQuest(msg, diff)
	local quest_x, _ = msg:find("|?c?f?f?(%x*)|?H?quest")
	if quest_x then
		local quest = string.sub(msg, quest_x, string.len(msg))
		local _, quest_y = quest:find("|r")
		if quest_y then
			quest = string.sub(quest, 1, quest_y)
			return quest
		end
	end
	local i = 1
	for j=1, #FGL.db.quests[i].criteria do
		if msg:find(FGL.db.quests[i].criteria[j]) then
			return "true"
		end
	end
end

function FindGroup_FindRep(msg)
	local i = 1
	for j=1, #FGL.db.reps[i].criteria do
		if msg:find(FGL.db.reps[i].criteria[j]) then
			return "true"
		end
	end
end

function FindGroup_FindArena(msg, f)
	if FGL.db.instances[f].patch ~= "pvp" then return end
	if not(FGL.db.instances[f].name:find("Арена")) then return end
	local i;
	--[[
	i = 2
	for j=1, #FGL.db.arenas[i].criteria do
		if msg:find(FGL.db.arenas[i].criteria[j]) then
			return "find"
		end
	end
	]]
	i = 1
	for j=1, #FGL.db.arenas[i].criteria do
		if msg:find(FGL.db.arenas[i].criteria[j]) then
			return "reg"
		end
	end
	return "find"
end



function FindGroup_FindNeedNow(msg, num, base, baseicon)
	local neednow
	for i=1, #base.search.criteria do 
		if msg:find(base.search.criteria[i]) then 
			neednow = 1;
			break 
		end 
	end
	if FGL.db.classfindstatus == 1 then
		for i=1, #baseicon do
			if GetClassFind(string.upper(baseicon[i]), num, msg) then
				neednow = 1
				break
			end
		end
	else
		if GetClassFind(select(2,UnitClass("PLAYER")), num, msg) then 
			neednow = 1
		end
	end
	if #base.search.exception > 0 then
		for i=1, #base.search.exception do
			if msg:find(base.search.exception[i]) then
				neednow = nil;
				break
			end
		end 
	end
	return neednow
end

function FindGroup_FindException1(msg)
	if #FGL.db.exceptions > 0 then 
		for i=1, #FGL.db.exceptions do 
			if msg:find(FGL.db.exceptions[i]) then 
				return 1
			end 
		end 
	end	
end

function FindGroup_FindException(msg)
	for i=1, #FGL.db.fp_exceptions.itype do
		for j=1, #FGL.db.fp_exceptions.inst do
			local text
			text = FGL.db.fp_exceptions.itype[i]..FGL.db.fp_exceptions.inst[j]
			if msg:find(text) then
				return 1
			end
			text = FGL.db.fp_exceptions.itype[i].." "..FGL.db.fp_exceptions.inst[j]
			if msg:find(text) then
				return 1
			end
		end
	end
	for i=1, #FGL.db.classesprint["DD"] do
		if FindGroup_TinyFind(msg, FGL.db.classesprint["DD"][i], " я", 6)then
			return 1
		end
		if FindGroup_TinyFind(msg, FGL.db.classesprint["DD"][i], "я ", 6)then
			return 1
		end
		if FindGroup_TinyFind(msg, FGL.db.classesprint["DD"][i], "не берут", 6) then
			return 1
		end
	end
end

function FindGroup_GetInstIR_heroic(msg)
	local x, y = msg:find("гер")
	local text="0123456789 "
	if x and y then
		if y == strlen(msg) then return 1 end
		local flag1, flag2
		for i=1, 3 do
			for j=1, strlen(text) do
				if strsub(msg, x-i, x-i) == strsub(text, j, j) then flag1 = 1 end
			end
		end
		for i=-3, -1 do
			for j=1, strlen(text) do
				if strsub(msg, y-i, y-i) == strsub(text, j, j) then flag2 = 1 end
			end
		end
		if flag1 and flag2 then return 1 end
	end
	x, y = msg:find("г")
	text="0123456789. "
	if x and y then
		local flag1, flag2
		for i=1, 2 do
			for j=1, strlen(text) do
				if strsub(msg, x-i, x-i) == strsub(text, j, j) then flag1 = 1 end
			end
		end
		for i=-2, -1 do
			for j=1, strlen(text) do
				if strsub(msg, y-i, y-i) == strsub(text, j, j) then flag2 = 1 end
			end
		end
		if flag1 and flag2 then return 1 end
	end
end

function FindGroup_GetInstIR_normal(msg)
	local x, y = msg:find("об")
	local text="0123456789 "
	if x and y then
		if y == strlen(msg) then return 1 end
		local flag1, flag2
		for i=1, 3 do
			for j=1, strlen(text) do
				if strsub(msg, x-i, x-i) == strsub(text, j, j) then flag1 = 1 end
			end
		end
		for i=-3, -1 do
			for j=1, strlen(text) do
				if strsub(msg, y-i, y-i) == strsub(text, j, j) then flag2 = 1 end
			end
		end
		if flag1 and flag2 then return 1 end
	end
	x, y = msg:find("о")
	text="0123456789. "
	if x and y then
		local flag1, flag2
		for i=1, 2 do
			for j=1, strlen(text) do
				if strsub(msg, x-i, x-i) == strsub(text, j, j) then flag1 = 1 end
			end
		end
		for i=-2, -1 do
			for j=1, strlen(text) do
				if strsub(msg, y-i, y-i) == strsub(text, j, j) then flag2 = 1 end
			end
		end
		if flag1 and flag2 then return 1 end
	end
end

function FindGroup_GetInstIR(msg, favorite)
	local IR = 1
	if favorite > 0 then
	IR = tonumber(strsub(FGL.db.instances[favorite].difficulties, 1, 1))
	if string.len(FGL.db.instances[favorite].difficulties) == 1 then
		return tonumber(FGL.db.instances[favorite].difficulties)
	else
	
		for i=1, #FGL.db.difficulties do
			if FGL.db.difficulties[i].maxplayers > 5 then
			if FGL.db.difficulties[i].heroic == 1 then
				for j=2, #FGL.db.heroic do if msg:find(FGL.db.difficulties[i].maxplayers..FGL.db.heroic[j]) then return i end end
			else
				for j=2, #FGL.db.normal do if msg:find(FGL.db.difficulties[i].maxplayers..FGL.db.normal[j]) then return i end end
			end
			end
		end
		
		if msg:find("25") and msg:find("10") then
			local x, _ = msg:find("25")
			local y, _ = msg:find("10")
			if x > y then
				msg = string.gsub(msg, "25", "")
			else
				msg = string.gsub(msg, "10", "")
			end
		end
		
		local addmsg={" ", ""}
		
		local fl = 0
		
		for k=1, 2 do
		
		for i=4, #FGL.db.heroic do
			if msg:find(FGL.db.heroic[i]) then
				for j=1, #FGL.db.difficulties do
					if FGL.db.difficulties[j].maxplayers > 5 and FGL.db.difficulties[j].heroic == 1 then
						if msg:find(addmsg[k]..FGL.db.difficulties[j].maxplayers) and FGL.db.instances[favorite].difficulties:find(""..j) and not(msg:find(FGL.db.difficulties[j].maxplayers.."0")) then return j end 
					end
				end
			fl=2
			end
		end
		
		if FindGroup_GetInstIR_heroic(msg) then
				for j=1, #FGL.db.difficulties do
					if FGL.db.difficulties[j].maxplayers > 5 and FGL.db.difficulties[j].heroic == 1 then
						if msg:find(addmsg[k]..FGL.db.difficulties[j].maxplayers) and FGL.db.instances[favorite].difficulties:find(""..j) and not(msg:find(FGL.db.difficulties[j].maxplayers.."0")) then return j end 
					end
				end
			fl=2	
		end	

		for i=4, #FGL.db.normal do
			if msg:find(FGL.db.normal[i]) then
				for j=1, #FGL.db.difficulties do
					if FGL.db.difficulties[j].maxplayers > 5 and not FGL.db.difficulties[j].heroic == 1 then
						if msg:find(addmsg[k]..FGL.db.difficulties[j].maxplayers) and FGL.db.instances[favorite].difficulties:find(""..j) and not(msg:find(FGL.db.difficulties[j].maxplayers.."0")) then return j end 
					end
				end
			fl=1		
			end
		end

		if FindGroup_GetInstIR_normal(msg) then
				for j=1, #FGL.db.difficulties do
					if FGL.db.difficulties[j].maxplayers > 5 and not FGL.db.difficulties[j].heroic == 1 then
						if msg:find(addmsg[k]..FGL.db.difficulties[j].maxplayers) and FGL.db.instances[favorite].difficulties:find(""..j) and not(msg:find(FGL.db.difficulties[j].maxplayers.."0")) then return j end 
					end
				end
			fl=1
		end	
		
		
		for i=1, #FGL.db.difficulties do
					if FGL.db.difficulties[i].maxplayers > 5 and FGL.db.instances[favorite].difficulties:find(""..i) then
			if FGL.db.difficulties[i].heroic == 1 then
				if msg:find(addmsg[k]..FGL.db.difficulties[i].maxplayers..FGL.db.heroic[1]) then return i end
			else
				if msg:find(addmsg[k]..FGL.db.difficulties[i].maxplayers..FGL.db.normal[1]) then return i end
			end
				end
		end
		
		end
		
		if fl > 0 then
			if fl == 1 then
				for i=1, string.len(FGL.db.instances[favorite].difficulties) do
					if not(FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[favorite].difficulties, i, i))].heroic == 1) then
						return tonumber(string.sub(FGL.db.instances[favorite].difficulties, i, i))
					end
				end
			elseif fl == 2 then
				for i=1, string.len(FGL.db.instances[favorite].difficulties) do
					if FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[favorite].difficulties, i, i))].heroic == 1 then
						return tonumber(string.sub(FGL.db.instances[favorite].difficulties, i, i))
					end
				end
			end
			return fl
		end


		
	end
	end
	return IR
end

function FindGroup_FindID(msg, id)
	local id_criteria = FGL.db.id_criteria
	local f =false
	if msg:find(id_criteria[1]..id) then return 1 end
	if msg:find(id_criteria[1].." "..id) then return 1 end
	msg = string.gsub(msg, "нид", "")
	local x1, x2 = msg:find(id_criteria[1])
	local y1, y2 = msg:find(""..id)
	if x2 and y1 then
		if x2 - y1 == -2 then return 1 end
		if x2 - y1 == -1 then return 1 end
	end
	for i=2, #id_criteria do
		if msg:find(id_criteria[i]..id) then f=true;break end
	end
	if f then
		if msg:find(""..id) then return 1 end
	end
end

function FindGroup_GetInstInfo(i)
if FGL.db.lastmsg[i] then
RequestRaidInfo()
--
for f = 1, GetNumSavedInstances() do
local name, id, _, diff, _, _, _, _, maxPlayers = GetSavedInstanceInfo(f)
local diffname
if name then
         if diff == 1 then
            diffname = "10"
         elseif diff == 2 then
            diffname = "25"
         elseif diff == 3 then
            diffname = "10 гер"
         elseif diff == 4 then
            diffname = "25 гер"
         end
            
         if players == 40 then
            diffname = "40"
         elseif players == 20 then
            diffname = "20"
         elseif players == 5 then
			if diff == 1 then
				diffname = ""
			elseif diff == 2 then
				diffname = "5 гер"
			end
         end  


if diffname == FGL.db.difficulties[FindGroup_GetInstIR(FGL.db.lastmsg[i][11],FindGroup_GetInstFav(FGL.db.lastmsg[i][11]))].name then
name = name:lower()
if FindGroup_GetInstFav(FGL.db.lastmsg[i][11]) == FindGroup_GetInstFav(name) then
if FindGroup_FindID(FGL.db.lastmsg[i][11], id) and not(id == FGL.db.difficulties[FindGroup_GetInstIR(FGL.db.lastmsg[i][11],FindGroup_GetInstFav(FGL.db.lastmsg[i][11]))].maxplayers) then return nil end
if FindGroupSaves_FindPlayer(id, FGL.db.lastmsg[i][2]) then return nil end
return 1 
end

end

end
end
------------------------------------
local _, _, _, _, _, duration, _, _, _, _, _ = UnitDebuff("player", "Dungeon Deserter")
if duration and (FGL.db.instances[FindGroup_GetInstFav(FGL.db.lastmsg[i][11])].name == "Случайное") then return 1 end
if GetLFGRandomCooldownExpiration() and (FGL.db.instances[FindGroup_GetInstFav(FGL.db.lastmsg[i][11])].name == "Случайное") then return 1 end
----------------------------------
end
return nil
end

function FindGroup_TinyFind(msg, msg1, msg2, space)

	if not space then space = 4 end --расстояние между словосочетаниями
	
	local x1, y1 = msg:find(msg1)
	local x2, y2 = msg:find(msg2)
	if x2 and y1 then
		if abs(y1-x2) < space then return 1 end
	end
	if x1 and y2 then
		if abs(y2-x1) < space then return 1 end
	end
end

function GetClassFind(className, need, msg)
	local base = FGL.db.classfindtable[className][need]
	if #base < 1 then return end
	for i=1, #base do
		if type(base[i]) == 'table' then
			if FindGroup_TinyFind(msg, base[i][1], base[i][2], base[i][3]) then return 1 end
		else
			if msg:find(base[i]) and not(msg:find(base[i].." фул")) and not(msg:find("не "..base[i])) then 
				if need == 2 then
					local text = GetClassFind(className, 1, msg) or GetClassFind(className, 3, msg)
					-- есть ли еще запросы в тексте
					if text then
						--стоят ли они рядом
						if FindGroup_TinyFind(msg, base[i], text) then
							return 1
						end
					else
						return 1
					end
				else
					return base[i]
				end
			end
		end
	end

end
---------------------------------------------------------------