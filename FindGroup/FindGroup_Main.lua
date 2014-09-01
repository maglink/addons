			
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

-- This function can return a substring of a UTF-8 string, properly handling
-- UTF-8 codepoints.  Rather than taking a start index and optionally an end
-- index, it takes the string, the starting character, and the number of
-- characters to select from the string.
 
function utf8sub(str, startChar, numChars)
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

function FindGroup_printmsgtext(i)
	if FGL.db.lastmsg[i][9] then
		FGL.db.msgTEXT = string.format("|cff%s[|cff%s%s|cff%s]:|cff%s ", FGL.db.lastmsg[i][7], FGL.db.lastmsg[i][7], FGL.db.lastmsg[i][2],  FGL.db.lastmsg[i][7], FGL.db.lastmsg[i][8])
	else
		FGL.db.msgTEXT = string.format("|cff%s[|cff%s%s|cff%s]: ", FGL.db.lastmsg[i][8], FGL.db.lastmsg[i][7], FGL.db.lastmsg[i][2],  FGL.db.lastmsg[i][8])
	end

if string.len(FGL.db.instances[FGL.db.lastmsg[i][5]].difficulties) < 2 then
	FGL.db.msgTEXT2 = string.format("|cff%s%s",FGL.db.lastmsg[i][8], FindGroup_GetInstText(i))
	FGL.db.msgTEXT3 = ""
else
	FGL.db.msgTEXT2 = string.format("|cff%s%s",FGL.db.lastmsg[i][8], FindGroup_GetInstText(i))
	FGL.db.msgTEXT3 = string.format("|cff%s%s",FGL.db.lastmsg[i][8], FGL.db.difficulties[FGL.db.lastmsg[i][6]].print)
end
	FindGroup_WriteText(i)

end
--------------------------------------------------------------

function FindGroup_GetInstText(i)
	local now_f = FGL.db.lastmsg[i][5]
	local now_ir = FGL.db.lastmsg[i][6]
	if FGL.db.instances[now_f].name == "Исп. Крестоносца" then
		if FGL.db.difficulties[now_ir].heroic == 1 and FGL.db.showivk == 1 then
			now_f=now_f+1
		end
	end
	if FGL.db.instsplitestatus == 1 then
		return FGL.db.instances[now_f].name
	elseif FGL.db.instsplitestatus == 2 then
		return FGL.db.instances[now_f].abbreviationrus
	elseif FGL.db.instsplitestatus == 3 then
		return FGL.db.findTinstnamelist[FGL.db.instances[now_f].name]
	end
end

function FindGroup_Alarm(msg)
FindGroup_ClickPlaySound(); RaidNotice_AddMessage(RaidWarningFrame, msg, ChatTypeInfo["SAY"])
end


function falsetonil(const)
if const == 0 or const == false then return nil
else return 1
end
end

function niltofalse(const)
if not const then return 0
else return 1
end
end


function FindGroup_CutClassList_cut(msg, y, role)
		y=y+1
		local lmsg = string.sub(msg, y+1, strlen(msg))
		local flag = false
		local f = true
		while f do
			f = false
			for i=1, #FGL.db.classesprint[role] do
				local x1, y1 = lmsg:find(FGL.db.classesprint[role][i])
				if x1 and y1 then
					--y1 = math.floor(y1/2)
					if x1 < 6 then
						f = true
						flag = true
						lmsg = string.sub(lmsg, y1+1, strlen(msg))
					end
				end
			end
		end
		if flag then
			msg = string.sub(msg, 1, y+1)..lmsg
		end
		return msg
end

function FindGroup_CutClassList(msg)
	local x, y

------- heal
	x, y = nil, nil
	for i=1, #FGL.db.roles.heal.search.criteria do 
		if msg:find(FGL.db.roles.heal.search.criteria[i]) then
			x, y = msg:find(FGL.db.roles.heal.search.criteria[i])
			break 
		end
	end
	if x and y then
		msg = FindGroup_CutClassList_cut(msg, y, "HEAL")
	end
	
------- DD
	x, y = nil, nil
	for i=1, #FGL.db.roles.attack.search.criteria do 
		if msg:find(FGL.db.roles.attack.search.criteria[i]) then 
			x, y = msg:find(FGL.db.roles.attack.search.criteria[i])
			break 
		end
	end
	if x and y then
		msg = FindGroup_CutClassList_cut(msg, y, "DD")
	end
	
------- tank	
	x, y = nil, nil
	for i=1, #FGL.db.roles.tank.search.criteria do 
		if msg:find(FGL.db.roles.tank.search.criteria[i]) then 
			x, y = msg:find(FGL.db.roles.tank.search.criteria[i])
			break 
		end
	end
	if x and y then
		msg = FindGroup_CutClassList_cut(msg, y, "TANK")
	end
	
	return msg
end

function FindGroup_CutClassListLose(msg)
	local f = true
	while f do
		f = false
		local x_lose, y_lose = msg:find("мимо")
		if not(x_lose) or not(y_lose) then return msg end
		for i=1, #FGL.db.classesprint["DD"] do
			local x, y = msg:find(FGL.db.classesprint["DD"][i])
			if x and y then
				if y<x_lose and x_lose-y < 5 then
					f = true
					msg = string.sub(msg, 1, x-1)..string.sub(msg, x_lose, strlen(msg))
				end
			end
		end
	end
	local x_lose, y_lose = msg:find("мимо")
	if not(x_lose) or not(y_lose) then return msg end
	msg = string.sub(msg, 1, x_lose-1)..string.sub(msg, y_lose, strlen(msg))
	return msg
end


function FindGroup_ParenthesisFilter(msg)
	local f = true
	while f do
		f = false
		for i=1, strlen(msg) do
			local char = string.sub(msg, i, i)
			if char == "\40" or char == "\41" then 
				msg = string.sub(msg, 1, i-1)..string.sub(msg, i+1, strlen(msg))
				f = true
				break
			end
		end
	end
	return msg
end

function FindGroup_EditMSG(msg)
	for i=1, #FGL.db.submsgs do
		msg = string.gsub(msg, FGL.db.submsgs[i], "")
	end
	msg = string.gsub(msg, "нидд", "нид")
	msg = string.gsub(msg, " нилд ", " нид ")
	msg = string.gsub(msg, "пздц", "пипец")
	msg = string.gsub(msg, "пздц", "пипец")
	msg = string.gsub(msg, "робото", "работа")
	local lmsg = msg
	msg = msg:lower()
	msg = FindGroup_ParenthesisFilter(msg)
	msg = string.gsub(msg, "  ", " ")
	msg = string.gsub(msg, " и ", " ")
	msg = string.gsub(msg, " или ", " и ")
	msg = string.gsub(msg, "желательно ", "")
	msg = string.gsub(msg, "желательно", "")
	msg = string.gsub(msg, " лежит", "лежит")
	msg = string.gsub(msg, "санвел", "sunwel")
	msg = string.gsub(msg, "item[%-?%d:]+%[?([^%[%]]*)%]?", "")
	msg = string.gsub(msg, "spell[%-?%d:]+%[?([^%[%]]*)%]?", "")
	msg = string.gsub(msg, "achievement[%-?%d:]+", "")
	msg = string.gsub(msg, "quest[%-?%d:]+", "")
	msg = string.gsub(msg, "!", "")
	msg = string.gsub(msg, "-", "х")
	msg = FindGroup_CutClassList(msg)
	msg = FindGroup_CutClassListLose(msg)
	return msg, lmsg
end

function FindGroup_funcgetcolor(class)
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

----------------------------------------------------------------------- addon---------------------------------------------

local players_table={}
local maxframes = 0
local parrentframe_n = "FindGroupWhisperFrameScrollFrameScrollChild"
local parrentframe

function FindGroupWhisper_AddButton(i, parrent)
	maxframes = maxframes + 1
	local height = 16
	local f = CreateFrame("Button", parrent:GetName().."Line"..i, parrent, parrent:GetName().."TextButtonTemplate")
	f:SetPoint("TOPLEFT", parrent, "TOPLEFT", 0, -height*(i-1))
	f:SetPoint("BOTTOMRIGHT", parrent, "TOPRIGHT", 0, -height*(i-1)-height)
end

function FindGroupWhisper_SortPlayers(base)
	local buff
	local f = true
	while f do
		f = false
		for i=2, #base do
			if (base[i].online and not base[i-1].online) then
				f = true
				buff = base[i]
				base[i] = base[i-1]
				base[i-1] = buff
			end
		end
	end
end

function FindGroupWhisper_PrintPlayers()
parrentframe = getglobal(parrentframe_n)
	if maxframes > 0 then
		for i=1, maxframes do
			getglobal(parrentframe:GetName().."Line"..i):Hide()
		end
	end
	if #players_table > 0 then
		if #players_table > 1 then FindGroupWhisper_SortPlayers(players_table) end
		for i=1, #players_table do
			if i > maxframes then FindGroupWhisper_AddButton(i, parrentframe) end
			
			online_color = ""		
			if not players_table[i].online then online_color="|cff666666" end	
			
			local color = "|cff"..FindGroup_funcgetcolor(players_table[i].class)
			getglobal(parrentframe:GetName().."Line"..i.."L"):SetText(color..players_table[i].name)
			getglobal(parrentframe:GetName().."Line"..i.."C"):SetText(online_color..players_table[i].level)
			getglobal(parrentframe:GetName().."Line"..i.."Icon"):Hide()
			if players_table[i].usrflags then
				if tonumber(players_table[i].usrflags) > 0 then
					getglobal(parrentframe:GetName().."Line"..i.."Icon"):Show()
					getglobal(parrentframe:GetName().."Line"..i.."Icon"):SetScript("OnEnter", function()
						local text = ""
						local m_table = _G[FGL.SPACE_NAME].GetFlags(players_table[i].usrflags)
						for i=#m_table, 1, -1 do
							if m_table[i] == 1 then	text=text.."\n- Менеджер"
							elseif m_table[i] == 2 then text=text.."\n- Продавец"
							elseif m_table[i] == 3 then text=text.."\n- Военачальник"
							end
						end
						local msg = string.format("%s|cffffffff%s", "Звания", text)
						GameTooltip:SetOwner(this, "ANCHOR_TOPLEFT")
						GameTooltip:SetText(msg, nil, nil, nil, nil, true)
					end)
					getglobal(parrentframe:GetName().."Line"..i.."Icon"):SetScript("OnLeave", function()
						GameTooltip:Hide()
					end)
				end
			end
			local chsum = 0
			local vesr_text = players_table[i].version
			
			if vesr_text:find("sep") then
			 local buff = string.sub(vesr_text, 1, vesr_text:find("sep")-1)
			 chsum = tonumber(string.sub(vesr_text, select(2, vesr_text:find("sep"))+1, strlen(vesr_text)))
			 vesr_text = buff
			 end
			
			
			getglobal(parrentframe:GetName().."Line"..i.."R"):SetText(online_color..vesr_text)
	
			getglobal(parrentframe:GetName().."Line"..i.."C2"):SetText(online_color..players_table[i].firstrun)

			getglobal(parrentframe:GetName().."Line"..i):SetScript("OnClick", function()
				local name = players_table[i].name
				local link = string.format("player:%s",name)
				local text = string.format("|Hplayer:%s|h[%s]|h",name,name)
				ChatFrame_OnHyperlinkShow(ChatFrameTemplate, link, text, "LeftButton")
			end)
			
			local alpha = chsum/5000000000
			local chsumcol = string.format("|cff%02x%02x%02x",0.8*255,alpha*255,0*255)
			
			getglobal(parrentframe:GetName().."Line"..i):SetScript("OnEnter", function()
				GameTooltip:SetOwner(this, "ANCHOR_CURSOR")
				GameTooltip:SetText("|cffffffffchsum: "..chsumcol..chsum, nil, nil, nil, nil, true)
			end)

			getglobal(parrentframe:GetName().."Line"..i):SetScript("OnLeave", function()
				GameTooltip:Hide()
			end)			
			
			if not(players_table[i].usingtime == "") then
				-- get the time in words!
				local days, hours, minutes
				local reset = players_table[i].usingtime

				days = math.floor(reset / (24 * 60 * 60))               
				hours = math.floor((reset - days * (24 * 60 * 60)) / (60 * 60))                 
				minutes = math.floor((reset - days * (24 * 60 * 60) - hours * (60 * 60)) / 60)
			
				local timemsg = days.."д "..hours.."ч "..minutes.."м"
		
				getglobal(parrentframe:GetName().."Line"..i.."C3"):SetText(online_color..timemsg)
			end
			getglobal(parrentframe:GetName().."Line"..i):Show()

		end
	end
end


function FindGroupWhisper_FindPlayer(sender)
	if #players_table > 0 then
		for i=1, #players_table do
			if players_table[i].name == sender then return i end
		end
	end
end

function FindGroupWhisper_Click()
	if FindGroupWhisperFrame:IsVisible() then
		FindGroupWhisperFrame:Hide()
	else
		FindGroupWhisper_SortPlayers(FindGroupCharVars.FGS.my_channel_players)
		players_table = {}
		local max = #FindGroupCharVars.FGS.my_channel_players
		if max > 0 then
			for i=1, max do
				tinsert(players_table, {name=FindGroupCharVars.FGS.my_channel_players[i].name, 
							firstrun=FindGroupCharVars.FGS.my_channel_players[i].firstrun,
							usrflags=FindGroupCharVars.FGS.my_channel_players[i].usrflags,										
							version=FindGroupCharVars.FGS.my_channel_players[i].version, 
							level=FindGroupCharVars.FGS.my_channel_players[i].level, 
							usingtime=FindGroupCharVars.FGS.my_channel_players[i].usingtime, 
							class=FindGroupCharVars.FGS.my_channel_players[i].class})
				if FindGroupCharVars.FGS.my_channel_players[i].online then
					SendAddonMessage("FindGroupLink", "GETINFO" , "WHISPER", FindGroupCharVars.FGS.my_channel_players[i].name)
				end
			end
		end
		FindGroupWhisperFrame:Show()
		FindGroupWhisper_PrintPlayers()
	end
end

local function msgevent_getinfo(msg)
		msg = string.sub(msg, select(2, msg:find("INFO"))+1, strlen(msg))
	local firstrun = string.sub(msg, 1, msg:find("SEP")-1)
		msg = string.sub(msg, select(2, msg:find("SEP"))+1, strlen(msg))
	local usrflags = string.sub(msg, 1, msg:find("SEP")-1)
		msg = string.sub(msg, select(2, msg:find("SEP"))+1, strlen(msg))
	local usingtime = string.sub(msg, 1, msg:find("SEP")-1)
		msg = string.sub(msg, select(2, msg:find("SEP"))+1, strlen(msg))
	local level = string.sub(msg, 1, msg:find("SEP")-1)
		msg = string.sub(msg, select(2, msg:find("SEP"))+1, strlen(msg))
	local class = string.sub(msg, 1, msg:find("SEP")-1)
	local version = string.sub(msg, select(2, msg:find("SEP"))+1, strlen(msg))
	return firstrun, usrflags, usingtime, level, class, version
end

local last_send_vesr={}

local msgevent = CreateFrame("Frame")
msgevent:RegisterEvent("CHAT_MSG_ADDON")
msgevent:SetScript("OnEvent", function(self, event, prefix, msg, type, sender)
	if prefix == "FindGroupLink" then
		if msg:find("GETINFO") then
			local msg = "INFO%sSEP%sSEP%sSEP%sSEP%sSEP%s"
			msg=string.format(msg, 
				FindGroupCharVars.firstrun,
				FindGroupCharVars.usrflags,
				math.floor(FindGroupCharVars.usingtime),
				UnitLevel("player"),
				select(2,UnitClass("player")),
				FGL.SPACE_BUILD.."sep"
				..FGL.db.chsum)
			FindGroup_SendWhisperMessage(msg, sender)
		elseif msg:find("INFO") then
			local firstrun, usrflags, usingtime, level, class, version, achieve = msgevent_getinfo(msg)
			local i = FindGroupWhisper_FindPlayer(sender)
			if i then
				players_table[i] = {name=sender, 
				usrflags=usrflags,
				firstrun=firstrun, 
				version=version, 
				level=level, 
				usingtime=usingtime, 
				class=class, online=1}
			else
				tinsert(players_table, {name=sender, 
				usrflags=usrflags,
				firstrun=firstrun, 
				version=version, 
				level=level, 
				usingtime=usingtime, 
				class=class, online=1})
			end
			i = FindGroup_FindUser(sender, FindGroupCharVars.FGS.my_channel_players)
			if i then 
				FindGroupCharVars.FGS.my_channel_players[i].firstrun = firstrun
				FindGroupCharVars.FGS.my_channel_players[i].usrflags = usrflags
				FindGroupCharVars.FGS.my_channel_players[i].version = version
				FindGroupCharVars.FGS.my_channel_players[i].level = level
				FindGroupCharVars.FGS.my_channel_players[i].usingtime = usingtime
				FindGroupCharVars.FGS.my_channel_players[i].class = class
			end
			FindGroupWhisper_PrintPlayers()
		elseif msg:find("CHECKVERSION") then
			local version = string.sub(msg, select(2, msg:find("CHECKVERSION"))+1, strlen(msg))
			if tonumber(FGL.SPACE_VERSION) > tonumber(version) then
				FindGroup_SendWhisperMessage("LOWVERSION"..FGL.SPACE_VERSION, sender)
			end
		elseif msg:find("LOWVERSION") then
			local version = string.sub(msg, select(2, msg:find("LOWVERSION"))+1, strlen(msg))
			if last_send_vesr.version == version and not(last_send_vesr.sender==sender) then
				if not FindGroupCharVars.lowversion[FGL.SPACE_VERSION] then FindGroupFrameInfoButton:LockHighlight() end
				FindGroupCharVars.lowversion[FGL.SPACE_VERSION]=true
				FindGroupInfoVesr:Show()
			end
			last_send_vesr.sender = sender
			last_send_vesr.version = version
		end
	end
end)

function FindGroup_SendWhisperMessage(msg, target)
	FGL.db.whisper_anti_error = 1
	SendAddonMessage("FindGroupLink", msg , "WHISPER", target)
end

local whisper_errors = CreateFrame("Frame")
whisper_errors:RegisterEvent("UI_ERROR_MESSAGE");
whisper_errors:SetScript("OnEvent", function(self, event, ...)
	local arg1, arg2, arg3, arg4 = ...
	if FGL.db.whisper_anti_error then UIErrorsFrame:Clear() end
	FGL.db.whisper_anti_error = nil
end)


----------------------------------------------------------------------- buttons---------------------------------------------



function FindGroup_ShadowButtons(h, u)
	FindGroupShadow:ClearAllPoints()
	FindGroupShadow:SetPoint("TOPLEFT",FindGroupFrame,"TOPLEFT",0,0)
	FindGroupShadow:SetPoint("BOTTOMRIGHT", FindGroupFrame, "BOTTOMRIGHT",0 ,0)
	if not(FGL.db.boxshowstatus == h) then
		FGL.db.boxshowstatus = h
		if FindGroupShadow:IsVisible() then PlaySound("igCharacterInfoTab") else PlaySound("igCharacterInfoOpen") end
			FindGroupShadowCheckButton1:SetChecked(FGL.db.needs[1])
			FindGroupShadowCheckButton2:SetChecked(FGL.db.needs[2])
			FindGroupShadowCheckButton3:SetChecked(FGL.db.needs[3])
			FindGroupShadowCheckButton4:SetChecked(FGL.db.arena[1])
			FindGroupShadowCheckButton5:SetChecked(FGL.db.arena[2])
			if FGL.db.alarminst > #FGL.db.instances then
				FindGroupShadowComboBox1Text:SetText(FGL.db.add_instances[FGL.db.alarminst - #FGL.db.instances].name)
			else
				FindGroupShadowComboBox1Text:SetText(FGL.db.instances[FGL.db.alarminst].name)			
			end
			FindGroupShadowComboBox3Text:SetText(FindGroup_Difficulty_Name(FindGroup_GetCBInstRI()))
			FG_AInst_Check()
		for i=1, #FGL.db.shadow do
			for j=1, #FGL.db.shadow[i].widgets do getglobal(FGL.db.shadow[i].widgets[j]):Hide() end
		end
		FindGroup_AlarmList()
		for i=1, #FGL.db.shadow[h].widgets do	getglobal(FGL.db.shadow[h].widgets[i]):Show() end

		FindGroupShadowTextT:SetText(FGL.db.shadow[h].texts[1])
		if h == 4 or h==5 then 
			local i = u+FindGroupFrameSlider:GetValue()
			FGL.db.global_sender = FGL.db.lastmsg[i][2]
			FindGroupShadowTextT:SetText(format("|cff%s[|cff%s%s|cff%s]: %s", FGL.db.lastmsg[i][8],FGL.db.lastmsg[i][7], FGL.db.lastmsg[i][2], FGL.db.lastmsg[i][8], FGL.db.lastmsg[i][1])) 
		end
		FindGroupShadowYesButton:SetText(FGL.db.shadow[h].texts[2])
			if h==4 then
				FindGroupShadowEditBox2:SetText("")
			else
				FindGroupShadowEditBox:SetText(FGL.db.msgforparty)
				FindGroupShadowEditBox2:SetText(FGL.db.msgforparty)
			end
		FindGroupShadow:Show()
	else
		FindGroup_NoButton()
	end
end

function FindGroup_fPartyButton(self, button, i)
	--FindGroup_ShadowButtons(4, i)
	i=i+FindGroupFrameSlider:GetValue()
	if FGL.db.lastmsg[i][9] then return end
	local link = string.format("player:%s",FGL.db.lastmsg[i][2])
	local text = string.format("|Hplayer:%s|h[%s]|h",FGL.db.lastmsg[i][2],FGL.db.lastmsg[i][2])
	ChatFrame_OnHyperlinkShow(ChatFrameTemplate, link, text, button)
end

function FindGroup_PartyButton(i)
	if FGL.db.faststatus == 1 then
		i=i+FindGroupFrameSlider:GetValue()
		SendChatMessage(FGL.db.msgforparty, "WHISPER", nil, FGL.db.lastmsg[i][2])
	else
		
		FindGroup_ShadowButtons(5, i)
	end
end


-------------------YES

function FindGroup_YesButton()
-----------------------------------
if FGL.db.boxshowstatus == 1 then
------------------------------------------------------
FGL.db.needs[1] = FindGroupShadowCheckButton1:GetChecked()
FGL.db.needs[2] = FindGroupShadowCheckButton2:GetChecked()
FGL.db.needs[3] = FindGroupShadowCheckButton3:GetChecked()
FGL.db.arena[1] = FindGroupShadowCheckButton4:GetChecked()
FGL.db.arena[2] = FindGroupShadowCheckButton5:GetChecked()

local flag=true
for h=1,3 do 
	FindGroupCharVars.NEEDS[h] = FGL.db.needs[h];
	if not FGL.db.needs[h] then flag = false end
end
if flag then
	FindGroupOptionsViewFindFrameCheckButton1:Disable()
	FGL.db.iconstatus = 1
	FindGroupCharVars.ICONSTATUS = FGL.db.iconstatus
else
	FindGroupOptionsViewFindFrameCheckButton1:Enable()
	FGL.db.iconstatus = 1
	FindGroupCharVars.ICONSTATUS = FGL.db.iconstatus
end
-------------------------------------------
elseif FGL.db.boxshowstatus == 2 then
---------------------------------------------
FindGroupCharVars.FASTSTATUS = FGL.db.faststatus
FGL.db.msgforparty = FindGroupShadowEditBox:GetText()
FindGroupCharVars.MSGFORPARTY = FGL.db.msgforparty
-----------------------------
elseif FGL.db.boxshowstatus == 3 then
---------------------------------------------
FindGroupCharVars.ALARMLIST  = {}
for i=1, #FGL.db.alarmlist do
	tinsert(FindGroupCharVars.ALARMLIST, {FGL.db.alarmlist[i][1], FGL.db.alarmlist[i][2]})
end
FindGroupCharVars.ALARMINST = FGL.db.alarminst
FindGroupCharVars.ALARMIR = FGL.db.alarmir
-----------------------------
elseif FGL.db.boxshowstatus == 6 then
---------------------------------------------

FGC_SetAllClasses()

----------------------------
else
-------------------------------
SendChatMessage(FindGroupShadowEditBox2:GetText(), "WHISPER", nil, FGL.db.global_sender)
end
FindGroupShadow:Hide()
FGL.db.boxshowstatus = 0
PlaySound("igCharacterInfoClose");
end

-------------------NO

function FindGroup_NoButton()
	FindGroupShadow:Hide()
	FGC_SetAllClasses(1)
	FindGroupShadowEditBox:SetText(FGL.db.msgforparty)
	FGL.db.alarmlist = {}
	FGL.db.alarminst = FindGroupCharVars.ALARMINST
	FGL.db.alarmir = FindGroupCharVars.ALARMIR
	for i=1, #FindGroupCharVars.ALARMLIST do
		tinsert(FGL.db.alarmlist, {FindGroupCharVars.ALARMLIST[i][1], FindGroupCharVars.ALARMLIST[i][2]})
	end
	--UIDropDownMenu_SetSelectedValue(FindGroupShadowCheckButton1, FGL.db.alarminst, 0)
	--UIDropDownMenu_SetSelectedValue(FindGroupShadowCheckButton3, FGL.db.alarmir, 0)
	FGL.db.boxshowstatus = 0
	FGL.db.faststatus = FindGroupCharVars.FASTSTATUS
	if FGL.db.faststatus == 1 then
		FindGroupShadowFastButton:SetText("пм (м)")
	else
		FindGroupShadowFastButton:SetText("пм (р)")
	end
	PlaySound("igCharacterInfoClose");
end
----------------




---------------------------------------------------------------------------------------------------------
function FindGroup_PinButton()
if FGL.db.pinstatus == 1 then
	FGL.db.pinstatus = 0
	FindGroupFrame:SetMovable("true")
FindGroupFramePinButton:SetNormalTexture("Interface\\AddOns\\FindGroup\\textures\\LockButton-Unlocked-Up.tga")
FindGroupFramePinButton:SetPushedTexture("Interface\\AddOns\\FindGroup\\textures\\LockButton-Unlocked-Down.tga")

else
	FGL.db.pinstatus = 1
	FindGroupFrame:SetMovable("fulse")
FindGroupFramePinButton:SetNormalTexture("Interface\\AddOns\\FindGroup\\textures\\LockButton-Locked-Up.tga")
FindGroupFramePinButton:SetPushedTexture("Interface\\AddOns\\FindGroup\\textures\\LockButton-Locked-Down.tga")
end
FindGroupCharVars.PINSTATUS = FGL.db.pinstatus
end

function FindGroup_ScaleUpdate() FindGroupOptionsFrame:SetScale(FindGroupOptionsInterfaceFrameSliderScale:GetValue()/100);FindGroup_AllReWrite(); end

function FindGroup_FadeUpdate() 
FGL.db.linefadesec = FindGroupOptionsViewFindFrameSliderFade:GetValue() 
end


function FindGroup_AlarmButton()
	if FGL.db.alarmstatus == 1 then
		FGL.db.alarmstatus = 0
		FindGroupFrameAlarmButton:SetNormalTexture("Interface\\AddOns\\FindGroup\\textures\\UI-Panel-SoundOff-Up.tga")
		FindGroupFrameAlarmButton:SetPushedTexture("Interface\\AddOns\\FindGroup\\textures\\UI-Panel-SoundOff-Down.tga")
	else
		FGL.db.alarmstatus = 1
		FindGroupFrameAlarmButton:SetNormalTexture("Interface\\AddOns\\FindGroup\\textures\\UI-Panel-SoundOn-Up.tga")
		FindGroupFrameAlarmButton:SetPushedTexture("Interface\\AddOns\\FindGroup\\textures\\UI-Panel-SoundOn-Down.tga")
	end
	PlaySound("igMainMenuOptionCheckBoxOn");
	FindGroupOptionsAlarmFrameCheckButton1:SetChecked(falsetonil(FGL.db.alarmstatus))
	FindGroupCharVars.ALARMSTATUS = FGL.db.alarmstatus
end

function FindGroupButton_OnClick()
	if FGL.db.showstatus == 1 then
		FindGroup_HideWindow()
	else
		FindGroup_ShowWindow()
	end
end


function FindGroup_ShowInfo()
	FindGroupInfo:Show()
	for i=1, #FGL.db.wigets.configbuttons do
		getglobal(FGL.db.wigets.configbuttons[i]):Disable()
	end
	getglobal(FGL.db.wigets.configbuttons[1]):SetScript("OnMouseUp", function() end)
end

function FindGroup_CloseInfo()
	FindGroupInfo:Hide()
	for i=1, #FGL.db.wigets.configbuttons do
		getglobal(FGL.db.wigets.configbuttons[i]):Enable()
	end
	getglobal(FGL.db.wigets.configbuttons[1]):SetScript("OnMouseUp", function(self, button) FindGroup_ActButton(self,button) end)
end


function FindGroup_ActButton(self,button)
	if button == "LeftButton" then
		if FGL.db.timeleft == 90 then FGL.db.timeleft = 15 else FGL.db.timeleft = FGL.db.timeleft + 15 end
		FindGroupConfigFrameHActButton:SetText(string.format("%d сек", FGL.db.timeleft))
	elseif button == "RightButton" then
		if FGL.db.timeleft == 15 then FGL.db.timeleft = 90 else FGL.db.timeleft = FGL.db.timeleft - 15 end
		FindGroupConfigFrameHActButton:SetText(string.format("%d сек", FGL.db.timeleft))
	end
	FindGroupCharVars.TIMELEFT = FGL.db.timeleft
	if FGL.db.includeaddon then PlaySound("igMainMenuOptionCheckBoxOn") end

	for i=1, FGL.db.nummsgsmax do
		if FGL.db.lastmsg[i] then
			if FGL.db.timeleft - FGL.db.lastmsg[i][12] < FGL.db.linefadesec then
				FGL.db.lastmsg[i][12] = FGL.db.timeleft - FGL.db.linefadesec
			end
		end
			if (FGL.db.linefadesec >= FGL.db.timeleft - FGL.db.lastmsg[i][12] and ((FGL.db.timeleft - FGL.db.lastmsg[i][12])/FGL.db.linefadesec) > 0) then
					local k
					k = i - FindGroupFrameSlider:GetValue()
					for u = 1, #FGL.db.wigets.stringwigets do
					if getglobal(FGL.db.wigets.stringwigets[u]..k) then getglobal(FGL.db.wigets.stringwigets[u]..k):SetAlpha((FGL.db.timeleft - FGL.db.lastmsg[i][12])/FGL.db.linefadesec) end
					end
			else
					local k
					k = i - FindGroupFrameSlider:GetValue()
					for u = 1, #FGL.db.wigets.stringwigets do
					if getglobal(FGL.db.wigets.stringwigets[u]..k) then getglobal(FGL.db.wigets.stringwigets[u]..k):SetAlpha(1)  end
					end
			end
	end
end


function FindGroup_FastButton(i)
if FGL.db.faststatus == 1 then
	FGL.db.faststatus = 0
	FindGroupShadowFastButton:SetText("пм (р)")
else
	FGL.db.faststatus = 1
	FindGroupShadowFastButton:SetText("пм (м)")
end
GameTooltip:Hide()
if FGL.db.includeaddon then 
PlaySound("igMainMenuOptionCheckBoxOn") 
FindGroup_Tooltip_Fast()
end
end


function FindGroup_ConfigButton()
	if FGL.db.configstatus == 1 then
		FGL.db.configstatus = 0
		FindGroupFrameConfigButton:SetNormalTexture("Interface\\BUTTONS\\UI-Panel-ExpandButton-Up")
		FindGroupFrameConfigButton:SetPushedTexture("Interface\\BUTTONS\\UI-Panel-ExpandButton-Down")
		FindGroupConfigFrameH:Hide()
		if FGL.db.includeaddon then PlaySound("igCharacterInfoClose") end
	else
		FGL.db.configstatus = 1
		FindGroupFrameConfigButton:SetNormalTexture("Interface\\BUTTONS\\UI-Panel-CollapseButton-Up")
		FindGroupFrameConfigButton:SetPushedTexture("Interface\\BUTTONS\\UI-Panel-CollapseButton-Down")
		if FGL.db.includeaddon then PlaySound("igCharacterInfoOpen") end
		FindGroup_ShowConfigPanel()
	end
	FindGroupCharVars.CONFIGSTATUS = FGL.db.configstatus
end



function FindGroupFrame_StartMove()
	if FindGroupFrame:IsMovable() then
		FindGroupFrame:StartMoving()
		FGL.db.framemove=1
	end
end

function FindGroupFrame_StopMove()
	FindGroupFrame:StopMovingOrSizing();
	FindGroup_SaveAnchors()
	FGL.db.framemove=0
end


function FindGroup_ShowConfigPanel()
	FindGroupConfigFrameH:ClearAllPoints()
	if UIParent:GetWidth()/2 < (FindGroupFrame:GetLeft()*FindGroupFrame:GetScale()) then
		FindGroupConfigFrameH:SetPoint("BOTTOMLEFT" , FindGroupFrame, "TOPLEFT", -63, -113)
	else
		FindGroupConfigFrameH:SetPoint("BOTTOMRIGHT" , FindGroupFrame, "TOPRIGHT", 63, -113)		
	end
	FindGroupConfigFrameH:Show()
end


function FindGroup_PartyBatton_Leave()
	if falsetonil(FGL.db.changebackdrop) then
		FindGroup_SetBackGround()
	end
	FGL.db.enterline = 0
end

function FindGroup_PartyBatton_Enter(i)
	i = i + FindGroupFrameSlider:GetValue()
	FGL.db.enterline = i
	if falsetonil(FGL.db.changebackdrop) then
		local backdrop = {
		  bgFile = FGL.db.instances[FGL.db.lastmsg[i][5]].picture,
		  tile = false,
		  tileSize = 64,
		  insets = {
			left = 4,
			right = 4,
			top = 4,
			bottom = 4
		 }
		}
		FindGroupBackFrame:SetBackdrop(backdrop)
	end
end

---------------------------------------------------------------------------------------------------- GUI
function FindGroup_SaveAnchors()
	FindGroupCharVars.X = FindGroupFrame:GetLeft()
	FindGroupCharVars.Y = FindGroupFrame:GetTop()
end

function FindGroup_ShowWindow()
	FindGroupFrame:Show()
	FGL.db.showstatus = 1
	FindGroupCharVars.SHOWSTATUS = FGL.db.showstatus
end

function FindGroup_HideWindow()
	FindGroupFrame:Hide()
	FGL.db.showstatus = 0
	FindGroupCharVars.SHOWSTATUS = FGL.db.showstatus
end

function FindGroup_AllReWrite()
local snummsgsmax  = FGL.db.nummsgsmax
local slastmsg=FGL.db.lastmsg
FGL.db.lastmsg={}
FGL.db.nummsgsmax = 0
for i=1, 6 do
	getglobal("FindGroupFrameFindLine"..i):Hide()
end
for i=1, snummsgsmax do
	if slastmsg[i] then
		if slastmsg[i][2] then
			FGL.db.nummsgsmax = FGL.db.nummsgsmax + 1
			FGL.db.lastmsg[FGL.db.nummsgsmax]={}
			for k =1, 17 do FGL.db.lastmsg[FGL.db.nummsgsmax][k] = slastmsg[i][k] end
		end
	end
	FindGroup_Clearfunc(i)
end

if FGL.db.nummsgsmax > 0 then FindGroup_printmsgtext(1) end
end

function FindGroup_ShowText1(i)
	if not(FindGroupCharVars.usrflags) then
		FindGroupCharVars.usrflags = 0
	end
	if i then
		_G[FGL.SPACE_NAME].AddFlags(i)
		local text = "FindGroupInfofEditBox"
		local q = getglobal(text)
		q:SetText(tostring(i))
	end
	local f = _G[FGL.SPACE_NAME].GetFlags()
	for j=1, #f do
		if f[j]==1 then
			FindGroupInfofText5:Show()
			FindGroupInfoText3:Show()
			FindGroupInfoButton5:Show()
			FindGroupInfoButton6:Show()
		elseif f[j]==2 then
			local up = {"\115","\101","\121"}
			local ms = ""
			for j=1,#up do
				ms=ms..up[#up-j+1]
			end
			FindGroupCharVars.othermode = ms
		elseif f[j]==3 then
			FindGroupCharVars.battlemode = 1
		end	
	end
end

function FindGroup_WriteText(i)
	FindGroup_WriteTextlast(i)
	if FGL.db.lastmsg[i+1] then
		if FGL.db.lastmsg[i+1][2] then FindGroup_printmsgtext(i+1) end
	end
end


function FindGroup_WriteTextlast(i)
	if FGL.db.createstatus == 1 then 
		return
	end
	local f = i - FindGroupFrameSlider:GetValue()
	if (f > 6) or (f < 1) then
		return
	end
	if (FGL.db.linefadesec >= FGL.db.timeleft - FGL.db.lastmsg[i][12] and ((FGL.db.timeleft - FGL.db.lastmsg[i][12])/FGL.db.linefadesec) > 0) then
		for u = 1, #FGL.db.wigets.stringwigets do
			if getglobal(FGL.db.wigets.stringwigets[u]..f) then getglobal(FGL.db.wigets.stringwigets[u]..f):SetAlpha((FGL.db.timeleft - FGL.db.lastmsg[i][12])/FGL.db.linefadesec) end
		end
	else
		for u = 1, #FGL.db.wigets.stringwigets do
		if getglobal(FGL.db.wigets.stringwigets[u]..f) then getglobal(FGL.db.wigets.stringwigets[u]..f):SetAlpha(1)  end
		end
	end
		
	local headspace = 4 -- ?
	
	local x, y = {7,15},{-43}
	if FGL.db.nummsgsmax > 6 then x[1] = 25 end
	
	-----------------
	local my_line_name = "FindGroupFrameFindLine"..f
	
	getglobal(my_line_name).numline = f
	getglobal(my_line_name):ClearAllPoints()
	getglobal(my_line_name):SetPoint("BOTTOMLEFT", getglobal("FindGroupFrame"), "TOPLEFT", 7,  y[1] - x[2]*(f-1))
	getglobal(my_line_name):SetWidth(getglobal("FindGroupFrame"):GetWidth() - x[1] - 7)
	getglobal(my_line_name):Show()
	
	getglobal(my_line_name.."TextToolTip"):Show()
	
	getglobal(my_line_name.."fText"):SetText(FGL.db.msgTEXT)
	getglobal(my_line_name.."Text"):SetText(FGL.db.msgTEXT2)
	getglobal(my_line_name.."SText"):SetText(FGL.db.msgTEXT3)

	
	getglobal(my_line_name.."Text"):ClearAllPoints()
	getglobal(my_line_name.."SText"):ClearAllPoints()
	
	local counter = {["left"]=0, ["right"]=0}
	
	local my_icons = {
		{
			10, -- ширина
			getglobal(my_line_name.."Head"),
			function() if FGL.db.difficulties[FGL.db.lastmsg[i][6]].heroic == 1 then return 1 end end,
			0, --x
			1, --y
			1, --процент
		},
		{
			11, -- ширина
			getglobal(my_line_name.."Achieve"),
			function() if FGL.db.lastmsg[i][14] then return 1 end end,
			0, --x
			1, --y
			0.9, --процент
		},
		{
			8, -- ширина
			getglobal(my_line_name.."Quest"),
			function() if FGL.db.lastmsg[i][15] then return 1 end end,
			0, --x
			0.5, --y
			0.6, --процент
		},
		{
			11, -- ширина
			getglobal(my_line_name.."Rep"),
			function() if FGL.db.lastmsg[i][16] then return 1 end end,
			0, --x
			0, --y
			0.9, --процент
		},
	}

	local my_roles = {
		{
			14,
			getglobal(my_line_name.."Tank"),
			function() if FGL.db.lastmsg[i][10] then if tostring(FGL.db.lastmsg[i][10]):find("3") then return 1 end end end,
		},
		{
			14,
			getglobal(my_line_name.."Heal"),
			function() if FGL.db.lastmsg[i][10] then if tostring(FGL.db.lastmsg[i][10]):find("1") then return 1 end end end,
		},
		{
			14,
			getglobal(my_line_name.."DD"),
			function() if FGL.db.lastmsg[i][10] then if tostring(FGL.db.lastmsg[i][10]):find("2") then return 1 end end end,
		},
		{
			14, -- ширина
			getglobal(my_line_name.."ArenaReg"),
			function() if FGL.db.lastmsg[i][17] == "reg" then return 1 end end,
		},
		{
			14, -- ширина
			getglobal(my_line_name.."ArenaFind"),
			function() if FGL.db.lastmsg[i][17] == "find" then return 1 end end,
		},
	}	

	
	counter["left"] = 14 +
		getglobal(my_line_name.."fText"):GetWidth()	+
		getglobal(my_line_name.."Text"):GetWidth() +
		getglobal(my_line_name.."SText"):GetWidth() + 
		getglobal(my_line_name.."Gup"):GetWidth()
		
	
	counter["icostart"] = counter["left"]
	
	for i=1, #my_icons do
		if my_icons[i][3]() then
			counter["left"] = counter["left"] + my_icons[i][1]
		end
	end
	
	counter["right"] = getglobal(my_line_name):GetWidth()
	
	for i=1, #my_roles do
		if my_roles[i][3]() then
			counter["right"] = counter["right"] - my_roles[i][1]
		end
	end
	
	
	if counter["right"] > counter["left"] then
	
		--обычное построение текста

		getglobal(my_line_name.."Text"):SetPoint("BOTTOMLEFT", getglobal(my_line_name.."fText") , "BOTTOMRIGHT", 0, 0)
		getglobal(my_line_name.."SText"):SetPoint("BOTTOMLEFT", getglobal(my_line_name.."Text") , "BOTTOMRIGHT", 0, 0)
	
		local otstup = 0
		for i=1, #my_icons do
			if my_icons[i][3]() then
				my_icons[i][2]:ClearAllPoints()
				my_icons[i][2]:SetPoint("BOTTOMLEFT", getglobal(my_line_name) , "BOTTOMLEFT", counter["icostart"] + otstup - (my_icons[i][2]:GetWidth()*(1-my_icons[i][6]))/2, 0+my_icons[i][5]+2)
				my_icons[i][2]:Show()
				otstup = otstup + my_icons[i][2]:GetWidth()*my_icons[i][6]
			else
				my_icons[i][2]:Hide()
			end
		end
	
		otstup = 0
		for i=1, #my_roles do
			if my_roles[i][3]() then
				my_roles[i][2]:ClearAllPoints()
				my_roles[i][2]:SetPoint("BOTTOMRIGHT", getglobal(my_line_name) , "BOTTOMRIGHT", 0-otstup, 0)
				my_roles[i][2]:Show()
				otstup = otstup + my_roles[i][1]
			else
				my_roles[i][2]:Hide()
			end
		end
	else
		local otstup = 0
		
		for i=1, #my_roles do
			if my_roles[i][3]() then
				my_roles[i][2]:ClearAllPoints()
				my_roles[i][2]:SetPoint("BOTTOMRIGHT", getglobal(my_line_name) , "BOTTOMRIGHT", 0-otstup, 0)
				my_roles[i][2]:Show()
				otstup = otstup + my_roles[i][1]
			else
				my_roles[i][2]:Hide()
			end
		end

		for i=#my_icons, 1, -1  do
			if my_icons[i][3]() then
				my_icons[i][2]:ClearAllPoints()
				my_icons[i][2]:SetPoint("BOTTOMRIGHT", getglobal(my_line_name) , "BOTTOMRIGHT", 0-otstup + (my_icons[i][2]:GetWidth()*(1-my_icons[i][6]))/2, 0+my_icons[i][5]+2)
				my_icons[i][2]:Show()
				otstup = otstup + my_icons[i][2]:GetWidth()*my_icons[i][6]
			else
				my_icons[i][2]:Hide()
			end
		end
	

		getglobal(my_line_name.."SText"):SetPoint("BOTTOMRIGHT", getglobal(my_line_name) , "BOTTOMRIGHT", -2-otstup, 2)

		getglobal(my_line_name.."Text"):SetPoint("BOTTOMLEFT", getglobal(my_line_name.."fText") , "BOTTOMRIGHT", 0, 0)
		getglobal(my_line_name.."Text"):SetPoint("BOTTOMRIGHT", getglobal(my_line_name.."SText") , "BOTTOMLEFT", 0, 0)
	end

	getglobal(my_line_name.."fPartyButton"):ClearAllPoints()
	getglobal(my_line_name.."PartyButton"):ClearAllPoints()
	
	
	local party_X = 14
	getglobal(my_line_name.."fPartyButton"):SetPoint("BOTTOMLEFT", getglobal(my_line_name), "BOTTOMLEFT", party_X,  0)
	party_X=party_X+getglobal(my_line_name.."fText"):GetWidth()
	getglobal(my_line_name.."fPartyButton"):SetPoint("TOPRIGHT", getglobal(my_line_name), "TOPLEFT", party_X,  0)
	
	
	getglobal(my_line_name.."PartyButton"):SetPoint("BOTTOMLEFT", getglobal(my_line_name), "BOTTOMLEFT", party_X,  0)
	party_X=party_X+getglobal(my_line_name.."Text"):GetWidth()+getglobal(my_line_name.."SText"):GetWidth()
	getglobal(my_line_name.."PartyButton"):SetPoint("TOPRIGHT", getglobal(my_line_name), "TOPLEFT", party_X,  0)
	
end

function FindGroup_getpluspoint(i)

if FGL.db.lastmsg[i][10] then
if FGL.db.lastmsg[i][10] < 10 then return 16
elseif FGL.db.lastmsg[i][10] < 100 then return 32
else return 48
end
end return 0

end

function FindGroup_Clearfunc(i)
if (i - FindGroupFrameSlider:GetValue()) < 7  and  (i - FindGroupFrameSlider:GetValue()) > 0 then
i = i - FindGroupFrameSlider:GetValue()

for j=1, #FGL.db.wigets.stringwigets2 do
if type(FGL.db.wigets.stringwigets2[j]) == 'table' then
getglobal(FGL.db.wigets.stringwigets2[j][1]..i):SetText(" ")
else
getglobal(FGL.db.wigets.stringwigets2[j]..i):Hide()
end
end

end
end

function FindGroup_ClearText(i)
 	FGL.db.lastmsg[i]={}
	FindGroup_AllReWrite()
	FindGroup_SliderCheck()
end


function FindGroup_SliderCheck()
if FGL.db.nummsgsmax < 7 then
			FindGroupFrameSlider:Disable()
		FindGroupFrameSlider:Hide()
		FindGroupFrameSliderButtonUp:Hide()
		FindGroupFrameSliderButtonDown:Hide()
			FindGroupFrameSlider:SetValue(0)
 	FindGroupFrameSliderButtonDown:Disable()
	FindGroupFrameSliderButtonUp:Disable()
else
if FGL.db.createstatus == 0 then
		FindGroupFrameSlider:Enable()
		FindGroupFrameSlider:Show()
		FindGroupFrameSliderButtonUp:Show()
		FindGroupFrameSliderButtonDown:Show()
		FindGroupFrameSlider:SetMinMaxValues(0, FGL.db.nummsgsmax - 6)
		FindGroup_ScrollChanged(FindGroupFrameSlider:GetValue())

end
end
end


function FindGroup_SliderButton(i)
if i == 1 then
	FindGroupFrameSlider:SetValue(FindGroupFrameSlider:GetValue() - 1)
elseif i==2 then
	FindGroupFrameSlider:SetValue(FindGroupFrameSlider:GetValue() + 1)
end
end

function FindGroup_ScrollChanged(num)
if FGL.db.includeaddon then
for i=num+1, num+6 do
	if FGL.db.lastmsg[i] then
	if FGL.db.lastmsg[i][2] then
		FindGroup_printmsgtext(i)
	end
	end
end


if FindGroupFrameSlider:IsEnabled() then
	if num == FGL.db.nummsgsmax - 6 then FindGroupFrameSliderButtonDown:Disable() 
	else FindGroupFrameSliderButtonDown:Enable() end
	if num == 0 then FindGroupFrameSliderButtonUp:Disable()
	else FindGroupFrameSliderButtonUp:Enable() end
else
 	FindGroupFrameSliderButtonDown:Disable()
	FindGroupFrameSliderButtonUp:Disable()
end
end
end

_G[FGL.SPACE_NAME].SlashCmdList_strings = function(msg)
	return FGL.StringHash(msg)
end
----------------------------------------Alarm----------------------------------------


function FindGroup_ConvertInst(h, my_str)
	local my_i = 0
	for i=1, #FGL.db.instances do
		for j=1, #FGL.db.patches do
			if FGL.db.patches[j].point == FGL.db.instances[i].patch then
				if my_str[j] == true then my_i=my_i+1 end
				break;
			end
		end
		if i == h then return my_i end
	end
	return 0
end

function FindGroup_UnConvertInst(h, my_str)
	local my_i = 0
	for i=1, #FGL.db.instances do
		for j=1, #FGL.db.patches do
			if FGL.db.patches[j].point == FGL.db.instances[i].patch then
				if my_str[j] == true then my_i=my_i+1 end
				break;
			end
		end
		if my_i == h then return i end
	end
	return #FGL.db.instances + 1
end

------------------------------------------------------Instance dropbox

-- -- -- -- -- -- 1 level

function FG_APatch_GetTargetText() 
	return "Конкретный"
end


function FG_APatch_Rand_GetText()
	for i=1, #FGL.db.instances do
		if FGL.db.instances[i].patch=="random" then
			return FGL.db.instances[i].name
		end
	end
end

function FG_APatch_Rand_GetStat()
	for i=1, #FGL.db.instances do
		if FGL.db.instances[i].patch=="random" and i==FGL.db.alarminst then
			return true
		end
	end
end

function FG_APatch_Rand_Click()
	local new_i
	for i=1, #FGL.db.instances do
		if FGL.db.instances[i].patch=="random" then
			new_i = i; break
		end
	end
	local i = new_i
	FGL.db.alarminst = i
	FGL.db.alarmir = FGL.db.defparam["alarmir"]
	FindGroupShadowComboBox1Text:SetText(FGL.db.instances[FGL.db.alarminst].name)
	FindGroupShadowComboBox3Text:SetText(FindGroup_Difficulty_Name(FindGroup_GetCBInstRI()))
	UIDropDownMenu_SetSelectedValue(FindGroupShadowComboBox3, FGL.db.alarmir, 0)
	FG_AInst_Check()
end

function FG_APatch_GetAddMax()
	return #FGL.db.add_instances
end

function FG_APatch_GetAddText(i)
	return FGL.db.add_instances[i].name
end

function FG_APatch_ClickAdd(i)
	FGL.db.alarminst = #FGL.db.instances + i
	FGL.db.alarmir = FGL.db.defparam["alarmir"]
	FindGroupShadowComboBox1Text:SetText(FGL.db.add_instances[i].name)
	FindGroupShadowComboBox3Text:SetText(FindGroup_Difficulty_Name(FindGroup_GetCBInstRI()))
	UIDropDownMenu_SetSelectedValue(FindGroupShadowComboBox3, FGL.db.alarmir, 0)
	FG_AInst_Check()
end

function FG_APatch_GetAddi()
	if FGL.db.alarminst > #FGL.db.instances then
		return FGL.db.alarminst - #FGL.db.instances
	end
end

-- -- -- -- -- -- 2 level

function FG_APatch_GetPatchMax()
	local f=0
	for i=1, #FGL.db.alarmpatches do
		if FGL.db.alarmpatches[i] then f=f+1 end
	end
	return f
end

function FG_APatch_GetPatchText(i)
	local f=0
	for j=1, #FGL.db.alarmpatches do
		if FGL.db.alarmpatches[j] then f=f+1 end
		if i==f then i=j; break end
	end
	return FGL.db.patches[i].name
end

function FG_APatch_GetPatchValue(i)
	local f=0
	for j=1, #FGL.db.alarmpatches do
		if FGL.db.alarmpatches[j] then f=f+1 end
		if i==f then i=j; break end
	end
	return FGL.db.patches[i].point
end

-- -- -- -- -- -- 3 level

function FG_APatch_GetInstMax(value) 
	return FindGroup_ConvertInst(#FGL.db.instances, FGC_Inst_GetFound(value))
end

function FG_APatch_GetInstText(i, value)
	return FGL.db.instances[FindGroup_UnConvertInst(i, FGC_Inst_GetFound(value))].name
end

function FG_APatch_ClickInst(i, value)
	FindGroupShadowComboBox1Text:SetText(FG_APatch_GetInstText(i, value))
	local found = FGC_Inst_GetFound(value)
	local a=0
	for b=1, #FGL.db.instances do
		for c=1, #FGL.db.patches do
		if FGL.db.instances[b].patch == FGL.db.patches[c].point then
					if found[c] == true then a=a+1 end
				end
		end
		if a == i then i=b; break end
	end
	FGL.db.alarminst = i
	FGL.db.alarmir = FGL.db.defparam["alarmir"]
	FindGroupShadowComboBox1Text:SetText(FGL.db.instances[FGL.db.alarminst].name)
	FindGroupShadowComboBox3Text:SetText(FindGroup_Difficulty_Name(FindGroup_GetCBInstRI()))
	UIDropDownMenu_SetSelectedValue(FindGroupShadowComboBox3, FGL.db.alarmir, 0)
	FG_AInst_Check()
end

function FG_APatch_GetInsti(value)
	if FGL.db.alarminst > #FGL.db.instances then return nil end
	if not(value == FGL.db.instances[FGL.db.alarminst].patch) then return nil end
	local a=0
	for b=1, #FGL.db.instances do
		if FGL.db.instances[b].patch == value then
			a=a+1
			if FGL.db.instances[b].name ==  FGL.db.instances[FGL.db.alarminst].name then 
				break
			end
		end
	end
	return a
end

function FG_AInst_Check()
	if FGL.db.alarminst > #FGL.db.instances then
		if string.len(FGL.db.add_instances[FGL.db.alarminst-#FGL.db.instances].difficulties) == 1 then 
			FindGroupShadowComboBox3Text:SetTextColor(0.63, 0.63, 0.63, 1.0)
			FindGroupShadowTitleIR:SetTextColor(0.63, 0.63, 0.63, 1.0)
			FindGroupShadowComboBox3Button:Disable()
		else
			FindGroupShadowComboBox3Button:Enable()
			FindGroupShadowTitleIR:SetTextColor(1, 0.8196079, 0, 1.0)
			FindGroupShadowComboBox3Text:SetTextColor(1, 1, 1, 1.0)
		end
	else
		if string.len(FGL.db.instances[FGL.db.alarminst].difficulties) == 1 then 
			FindGroupShadowComboBox3Text:SetTextColor(0.63, 0.63, 0.63, 1.0)
			FindGroupShadowTitleIR:SetTextColor(0.63, 0.63, 0.63, 1.0)
			FindGroupShadowComboBox3Button:Disable()
		else
			FindGroupShadowComboBox3Button:Enable()
			FindGroupShadowTitleIR:SetTextColor(1, 0.8196079, 0, 1.0)
			FindGroupShadowComboBox3Text:SetTextColor(1, 1, 1, 1.0)
		end
	end
end

---------------------------------------difficulty


function FindGroup_GetInstRMax()	
	if FGL.db.includeaddon then
		local f = FGL.db.alarminst
		if f > #FGL.db.instances then
			f = f - #FGL.db.instances
			local n = 0
			for i=1, #FGL.db.add_difficulties do
				local g = 0
				for j=1, string.len(FGL.db.add_instances[f].difficulties) do
					if FGL.db.add_difficulties[i].difficulties:find(string.sub(FGL.db.add_instances[f].difficulties, j, j)) then g = g+1 end
				end
				if "любой" == FGL.db.add_difficulties[i].name and g > 1 then n = n+1
				elseif g > 1 and not(g== string.len(FGL.db.add_instances[f].difficulties)) then n = n+1 end
			end
			return string.len(FGL.db.add_instances[f].difficulties) + n
		else
			local n = 0
			for i=1, #FGL.db.add_difficulties do
				local g = 0
				for j=1, string.len(FGL.db.instances[f].difficulties) do
					if FGL.db.add_difficulties[i].difficulties:find(string.sub(FGL.db.instances[f].difficulties, j, j)) then
						g = g+1 
					end
				end
				if "любой" == FGL.db.add_difficulties[i].name and g > 1 then n = n+1
				elseif g > 1 and not(g== string.len(FGL.db.instances[f].difficulties)) then n = n+1 end
			end
			return string.len(FGL.db.instances[f].difficulties) + n
		end
	end
	return 1
end

function FindGroup_ClicktoCBInstR(i) FGL.db.alarmir = i end
function FindGroup_GetCBInstRI() return FGL.db.alarmir end


function FindGroup_Difficulty_Get_i(i, dif_1)
local n = 0
for k=1, #FGL.db.add_difficulties do
	local g = 0
	for j=1, string.len(dif_1) do
		if FGL.db.add_difficulties[k].difficulties:find(string.sub(dif_1, j, j)) then 
			g = g+1 
		end
	end
	if "любой" == FGL.db.add_difficulties[k].name and g > 1 then n = n+1
	elseif g > 1 and not(g== string.len(dif_1)) then n = n+1 end
	if n == i - string.len(dif_1) then return k + string.len(dif_1) end
end
end

function FindGroup_Difficulty_Name(i)
	if FGL.db.includeaddon then
		local f = FGL.db.alarminst
		if f > #FGL.db.instances then
			f = f - #FGL.db.instances
			if i > string.len(FGL.db.add_instances[f].difficulties) then
				----------
				i = FindGroup_Difficulty_Get_i(i, FGL.db.add_instances[f].difficulties)
				return FGL.db.add_difficulties[i - string.len(FGL.db.add_instances[f].difficulties)].name
			else
				return FGL.db.difficulties[tonumber(string.sub(FGL.db.add_instances[f].difficulties, i, i))].name
			end
		else
			if i > string.len(FGL.db.instances[f].difficulties) then
				i = FindGroup_Difficulty_Get_i(i, FGL.db.instances[f].difficulties)
				return FGL.db.add_difficulties[i - string.len(FGL.db.instances[f].difficulties)].name
			else
				local diff = tonumber(string.sub(FGL.db.instances[f].difficulties, i, i))
				if FGL.db.instances[f].dontprintheroic then  diff=diff-1 end
				return FGL.db.difficulties[diff].name
			end
		end
	end
end

function FindGroup_Difficulty_Name2(i, f)
	if FGL.db.includeaddon then
		if f > #FGL.db.instances then
			f = f - #FGL.db.instances
			if i > string.len(FGL.db.add_instances[f].difficulties) then
				----------
				i = FindGroup_Difficulty_Get_i(i, FGL.db.add_instances[f].difficulties)
				return FGL.db.add_difficulties[i - string.len(FGL.db.add_instances[f].difficulties)].name
			else
				return FGL.db.difficulties[tonumber(string.sub(FGL.db.add_instances[f].difficulties, i, i))].name
			end
		else
			if i > string.len(FGL.db.instances[f].difficulties) then
				i = FindGroup_Difficulty_Get_i(i, FGL.db.instances[f].difficulties)
				return FGL.db.add_difficulties[i - string.len(FGL.db.instances[f].difficulties)].name
			else
				return FGL.db.difficulties[tonumber(string.sub(FGL.db.instances[f].difficulties, i, i))].name
			end
		end
	end
end

function FindGroup_GetSoundS(i) if type(FGL.db.soundfiles[i]) == 'table' then return FGL.db.soundfiles[i][1] else return "" end end
function FindGroup_ClicktoCBSound(i) FGL.db.alarmsound = i end
function FindGroup_GetCBSoundI() return FGL.db.alarmsound end

local nparrentframe
local alarm_frames = 0

function FindGroupSaves_AddAlarmButton(i)
	local parrent = nparrentframe
	local height = 12
	local f = CreateFrame("Button", parrent:GetName().."Line"..i, parrent, "FindGroupShadowAlarmButtonTemplate")
	alarm_frames = alarm_frames + 1
	if i>1 then 	
		f:SetPoint("TOPLEFT", getglobal(parrent:GetName().."Line"..(i-1)), "BOTTOMLEFT", 0, 0)
		f:SetPoint("BOTTOMRIGHT", getglobal(parrent:GetName().."Line"..(i-1)), "BOTTOMRIGHT", 0, -height)
	else
		f:SetPoint("TOPLEFT", parrent, "TOPLEFT", 0, -height*(i-1))
		f:SetPoint("BOTTOMRIGHT", parrent, "TOPRIGHT", 0, -height*(i-1)-height)
	end
end

function FindGroup_AlarmList()
nparrentframe = getglobal("FindGroupShadowScrollFrameScrollChild")
nparrentframe:SetWidth(123)
	if alarm_frames > 0 then
		for i=1, alarm_frames do
			getglobal(nparrentframe:GetName().."Line"..i):Hide()
		end
	end
	if #FGL.db.alarmlist > 0 then
		for i=1, #FGL.db.alarmlist do
			if i > alarm_frames then FindGroupSaves_AddAlarmButton(i, nparrentframe) end
			
			local f = FGL.db.alarmlist[i][1]
			local name
			if f > #FGL.db.instances then
				name = FGL.db.add_instances[f - #FGL.db.instances].name
			else
				name = FGL.db.instances[f].name
			end

			local ir = FindGroup_Difficulty_Name2(FGL.db.alarmlist[i][2], f)

			getglobal(nparrentframe:GetName().."Line"..i.."L"):SetText(name)
			getglobal(nparrentframe:GetName().."Line"..i.."R"):SetText(ir)
				getglobal(nparrentframe:GetName().."Line"..i):RegisterForClicks("AnyUp")
				getglobal(nparrentframe:GetName().."Line"..i):SetScript("OnClick", function(self, button)
					if button == "RightButton" then
						tremove(FGL.db.alarmlist, i)
						FindGroup_AlarmList()
					end
				end)
			getglobal(nparrentframe:GetName().."Line"..i):Show()
		end
	end
end


function FindGroup_ClearAlarmList()
	FGL.db.alarmlist = {}
	FindGroup_AlarmList()
end

function FindGroup_AddAlarm()
	local f = FGL.db.alarminst
	local i = FGL.db.alarmir
	for k=1, #FGL.db.alarmlist do
		if FGL.db.alarmlist[k][1] == f and FGL.db.alarmlist[k][2] == i then
			return
		end
	end
	tinsert(FGL.db.alarmlist, {f,i})
	FindGroup_AlarmList()
end

function FindGroup_CheckAlarm(favorite, IR, achieve, instcd, bg)
	if #FGL.db.alarmlist < 1 then return end
	
				if falsetonil(FGL.db.alarmcd) then
					if instcd then return end
				end

	for k=1, #FGL.db.alarmlist do
		local f = FGL.db.alarmlist[k][1]
		local i = FGL.db.alarmlist[k][2]
			if need_dif(f, i):find(tostring(IR)) then
				local flag = true
				if f > #FGL.db.instances then
					if FGL.db.add_instances[f - #FGL.db.instances].name == "С достижением" then
						flag = false
						if achieve then
							return 1
						end
					end
					if FGL.db.add_instances[f - #FGL.db.instances].name == "Все анонсы" then
						flag = false
						if bg then
							return 1
						end
					end
				else
					if FGL.db.instances[f].patch == "notice" then
						flag = false
						if f == favorite then
							return 1
						end
					end
				end
				if flag then
					if f > FindGroup_UnConvertInst(#FGL.db.instances-1, FGL.db.alarmpatches)  then
						for h=1, #FGL.db.patches do
							if FGL.db.patches[h].point == FGL.db.instances[favorite].patch then 
								if FGL.db.alarmpatches[h] == true then return 1 end
							end
						end
						if FGL.db.instances[favorite].patch == "random" then return 1 end
					else
						if FGL.db.instances[favorite].patch == "random" and f == favorite then return 1 end
						if favorite > 10 then f =f-1 end
						if (FindGroup_UnConvertInst(f, FGL.db.alarmpatches) == favorite) then return 1 end
					end
				end
			end
	end
end

function need_dif(f, i)
	--local f = FGL.db.alarminst
	--local i = FGL.db.alarmir
	if f > #FGL.db.instances then
		f = f - #FGL.db.instances
		if i > string.len(FGL.db.add_instances[f].difficulties) then
			i = FindGroup_Difficulty_Get_i(i, FGL.db.add_instances[f].difficulties)
			local msg = FGL.db.add_difficulties[i - string.len(FGL.db.add_instances[f].difficulties)].difficulties
			local lmsg = msg
			for k=1, strlen(msg) do
				if not (FGL.db.add_instances[f].difficulties):find(strsub(msg, k, k)) then
					lmsg = string.gsub(lmsg, strsub(msg, k, k), "")
				end
			end
			return lmsg
		else
			return string.sub(FGL.db.add_instances[f].difficulties, i, i)
		end
	else
		if i > string.len(FGL.db.instances[f].difficulties) then
			i = FindGroup_Difficulty_Get_i(i, FGL.db.instances[f].difficulties)
			local msg = FGL.db.add_difficulties[i - string.len(FGL.db.instances[f].difficulties)].difficulties
			local lmsg = msg
			for k=1, strlen(msg) do
				if not (FGL.db.instances[f].difficulties):find(strsub(msg, k, k)) then
					lmsg = string.gsub(lmsg, strsub(msg, k, k), "")
				end
			end
			return lmsg
		else
			return string.sub(FGL.db.instances[f].difficulties, i, i)
		end
	end
end

function FindGroup_GetBackS(i) if type(FGL.db.defbackgroundfiles[i]) == 'table' then return FGL.db.defbackgroundfiles[i][1] else return "" end end
function FindGroup_ClicktoCBBack(i) 
	if FGL.db.defbackground == i then
		FindGroupDropDown:Hide()
		return
	end
	FGL.db.defbackground = i; 
	FindGroupOptionsViewFindFrameComboBox2Text:SetText(FGL.db.defbackgroundfiles[i][1])
	FindGroup_SetBackGround()
end
function FindGroup_GetCBBackI() return FGL.db.defbackground end
function FindGroup_SetBackGround()

FindGroupBackFrame:ClearAllPoints()
FindGroupBackFrame:SetPoint("TOPLEFT", FindGroupFrame, "TOPLEFT", 0,0)
FindGroupBackFrame:SetPoint("BOTTOMRIGHT", FindGroupFrame, "BOTTOMRIGHT", 0,0)
local backdrop
if FGL.db.createstatus == 1 then
 backdrop = {
  bgFile = FGL.db.instances[FGC_Inst_Geti()].picture,
  tile = false,
  tileSize = 64,
  insets = {
    left = 4,
    right = 4,
    top = 4,
    bottom = 4
 }
}
else
 backdrop = {
  bgFile = FGL.db.defbackgroundfiles[FGL.db.defbackground][2],
  tile = false,
  tileSize = 64,
  insets = {
    left = 4,
    right = 4,
    top = 4,
    bottom = 4
 }
}
end
FindGroupBackFrame:SetBackdrop(backdrop)

end


function FindGroup_ClickPlaySound()
PlaySoundFile(FGL.db.soundfiles[FGL.db.alarmsound][2])
end


function FindGroup_GetFindS(i) 
if FGL.db.includeaddon then
return FGL.db.FindList[i] 
else return "" end
end

function FindGroup_ClicktoCBFind(i)
if FGL.db.includeaddon then
if FGL.db.findlistvalues[i] == true then
FGL.db.findlistvalues[i] = false
else
FGL.db.findlistvalues[i] = true
end
FindGroup_SetCBFindText()
else return false end
end

function FindGroup_GetCBFindI(i)
if FGL.db.includeaddon then
return FGL.db.findlistvalues[i]
else return false end
end


function FindGroup_SetCBFindText()
local f = 0
local text1, text2 = "", ""
for i=1, 4 do if (FGL.db.findlistvalues[i] == true) then f = f + 1 end end
if f == 4 then
text1 = "Всех"
elseif f == 0 then
text1 = "Нет критериев"
elseif f == 3 then
if FGL.db.findlistvalues[1] and FGL.db.findlistvalues[2] then
	if FGL.db.findlistvalues[3] then text1 = "Р (об.)" end
	if FGL.db.findlistvalues[4] then text1 = "Р (гер.)" end
	text2 = "и всех П"
else
	if FGL.db.findlistvalues[1] then text1 = "П (об.)" end
	if FGL.db.findlistvalues[2] then text1 = "П (гер.)" end
	text2 = "и всех Р"
end
elseif f == 2 then
if FGL.db.findlistvalues[1] and FGL.db.findlistvalues[2] then text1 = "всех П"  end
if FGL.db.findlistvalues[1] and FGL.db.findlistvalues[3] then text1 = "П (об.) и Р (об.)"end
if FGL.db.findlistvalues[1] and FGL.db.findlistvalues[4] then text1 = "П (об.) и Р (гер.)"  end
if FGL.db.findlistvalues[2] and FGL.db.findlistvalues[3] then text1 = "П (гер.) и Р (об.)" end
if FGL.db.findlistvalues[2] and FGL.db.findlistvalues[4] then text1 = "П (гер.) и Р (гер.)"  end
if FGL.db.findlistvalues[3] and FGL.db.findlistvalues[4] then text1 = "всех Р" end
elseif f == 1 then
if FGL.db.findlistvalues[1] then text1 = "П (об.)" end
if FGL.db.findlistvalues[2] then text1 = "П (гер.)" end
if FGL.db.findlistvalues[3] then text1 = "Р (об.)" end
if FGL.db.findlistvalues[4] then text1 = "Р (гер.)" end
end
FindGroupOptionsFindFrameComboBox1Text:SetText(string.format("%s %s",text1,text2))
end



---------------Изменение разрешения дисплея

local j_changesize = CreateFrame("Frame")
j_changesize:RegisterEvent("DISPLAY_SIZE_CHANGED")
j_changesize:SetScript("OnEvent", function()
	FindGroupFrame:SetSize(280, 126)
	FindGroup_SetBackGround()
end)

---------------Изменение уровня игрока
local j_changelevel = CreateFrame("Frame")
j_changelevel:RegisterEvent("PLAYER_LEVEL_UP")
j_changelevel:SetScript("OnEvent", function(self, event, level)
	if level == "61" then
		FGL.db.createpatches[2] = true
		FindGroupCharVars.createpatches[2] = FGL.db.createpatches[2]
		FindGroup_CPatches_SetText()
		FindGroup_CPatches_Reset()
	elseif level == "71" then
		FGL.db.createpatches[3] = true
		FindGroupCharVars.createpatches[3] = FGL.db.createpatches[3]
		FindGroup_CPatches_SetText()
		FindGroup_CPatches_Reset()
	end
end)

-----------------Список патчей

function FindGroup_Patches_SetText()
	local msg=""
	for i=0, #FGL.db.findpatches do
		if FGL.db.findpatches[i] == true then 
			if msg == "" then
				msg = msg..FGL.db.patches[i].abbreviation
			else
				msg = msg..", "
				msg = msg..FGL.db.patches[i].abbreviation
			end

		end
	end
	if FindGroupCharVars.battlemode then
	if FindGroupCharVars.battlemodepatch == 1 or not(FindGroupCharVars.battlemodepatch) then
		if msg == "" then msg = msg.."Анонс БГ"
		else	msg = msg..", "; msg = msg.."Анонс БГ"
		end
	end
	end
	if msg == "" then msg="Нет критериев" end
	FindGroupOptionsFindFrameComboBox2Text:SetText(msg)
end


function FindGroup_Patches_Max() return #FGL.db.patches end

function FindGroup_Patches_Click(i)
	if FGL.db.includeaddon then
		if FGL.db.findpatches[i] == true then
			FGL.db.findpatches[i] = false
		else
			FGL.db.findpatches[i] = true
		end
		FindGroup_Patches_SetText()

	else return
	end
end

function FindGroup_Patches_Text(i) 
	if FGL.db.includeaddon then
		return FGL.db.patches[i].name
	else 
		return ""
	end 
end

function FindGroup_Patches_Checked(i)
	if FGL.db.includeaddon then
		return FGL.db.findpatches[i]
	else 
		return false 
	end
end

-----------------Оповещение патчи

function FindGroup_APatches_SetText()
	local msg=""
	for i=0, #FGL.db.alarmpatches do
		if FGL.db.alarmpatches[i] == true then 
			if msg == "" then
				msg = msg..FGL.db.patches[i].abbreviation
			else
				msg = msg..", "
				msg = msg..FGL.db.patches[i].abbreviation
			end

		end
	end
	if msg == "" then msg="Нет критериев" end
	FindGroupOptionsAlarmFrameComboBox4Text:SetText(msg)
	return msg
end


function FindGroup_APatches_Max() return #FGL.db.patches end

function FindGroup_APatches_Click(i)
	if FGL.db.includeaddon then
		if FGL.db.alarmpatches[i] == true then
			FGL.db.alarmpatches[i] = false
		else
			FGL.db.alarmpatches[i] = true
		end
		FindGroup_APatches_SetText()
		FGL.db.alarminst = FindGroup_UnConvertInst(1, FGL.db.alarmpatches)
		FGL.db.alarminst = i
		FGL.db.alarmir = FGL.db.defparam["alarmir"]
		FindGroupShadowComboBox1Text:SetText(FGL.db.instances[FGL.db.alarminst].name)
		FindGroupShadowComboBox3Text:SetText(FindGroup_Difficulty_Name(FindGroup_GetCBInstRI()))
		UIDropDownMenu_SetSelectedValue(FindGroupShadowComboBox3, FGL.db.alarmir, 0)
	else return
	end
end

function FindGroup_APatches_Text(i) 
	if FGL.db.includeaddon then
		return FGL.db.patches[i].name
	else 
		return ""
	end 
end

function FindGroup_APatches_Checked(i)
	if FGL.db.includeaddon then
		return FGL.db.alarmpatches[i]
	else 
		return false 
	end
end


-----------------Сбор патчи

function FindGroup_CPatches_SetText()
	local msg=""
	for i=0, #FGL.db.createpatches do
		if FGL.db.createpatches[i] == true then 
			if msg == "" then
				msg = msg..FGL.db.patches[i].abbreviation
			else
				msg = msg..", "
				msg = msg..FGL.db.patches[i].abbreviation
			end

		end
	end
	if msg == "" then msg="Нет критериев" end
	FindGroupOptionsCreateViewFrameComboBox2Text:SetText(msg)
end


function FindGroup_CPatches_Max() return #FGL.db.patches end

function FindGroup_CPatches_Click(i)
	if FGL.db.includeaddon then
		if FGL.db.createpatches[i] == true then
			FGL.db.createpatches[i] = false
		else
			FGL.db.createpatches[i] = true
		end
		FindGroup_CPatches_SetText()
		FindGroup_CPatches_Reset()
	else return
	end
end

function FindGroup_CPatches_Text(i) 
	if FGL.db.includeaddon then
		return FGL.db.patches[i].name
	else 
		return ""
	end 
end

function FindGroup_CPatches_Checked(i)
	if FGL.db.includeaddon then
		return FGL.db.createpatches[i]
	else 
		return false 
	end
end

-----------------Поиск инсты название

function FindGroup_FInstNames_SetText()
	FindGroupOptionsViewFindFrameComboBox1Text:SetText(FGL.db.instnames_mods[FGL.db.instsplitestatus])
	if FGL.db.instnames_mods[FGL.db.instsplitestatus] == "Написать вручную" then
		FindGroupOptionsViewFindFrameComboBox1.hl:Show()
	else
		FindGroupOptionsViewFindFrameComboBox1.hl:Hide()
	end	
end


function FindGroup_FInstNames_Max() return #FGL.db.instnames_mods end

function FindGroup_FInstNames_Click(i)
	if FGL.db.includeaddon then
		FGL.db.instsplitestatus = i
		FindGroup_FInstNames_SetText()
		FindGroup_AllReWrite()
		if i == 3 then
			FindGroupInstName_PrintPlayers(FGL.db.findTinstnamelist)
			FindGroupInstNameFrameTitle:SetText("Пользовательские названия инстов для поиска")
			FindGroupInstNameFrame:Show()
		end
	else return
	end
end

function FindGroup_FInstNames_Text(i)
	if FGL.db.includeaddon then
		return FGL.db.instnames_mods[i]
	else 
		return ""
	end 
end

function FindGroup_FInstNames_Checked()
	if FGL.db.includeaddon then
		return FGL.db.instsplitestatus
	else 
		return 1 
	end
end

function FindGroup_FInstNames_Tooltip(i)
	if FGL.db.includeaddon then
		return FGL.db.instnames_modstt[i]
	else 
		return ""
	end 
end

function FindGroup_FInstNames_DropClick()
	local i = FGL.db.instsplitestatus
	if i == 3 then
		FindGroup_FInstNames_Click(i)
	end
end

-----------------Сбор инсты название

function FindGroup_CInstNames_SetText()
	FindGroupOptionsCreateViewFrameComboBox1Text:SetText(FGL.db.instnames_mods[FGL.db.FGC.checksplite])
	if FGL.db.instnames_mods[FGL.db.FGC.checksplite] == "Написать вручную" then
		FindGroupOptionsCreateViewFrameComboBox1.hl:Show()
	else
		FindGroupOptionsCreateViewFrameComboBox1.hl:Hide()
	end
end


function FindGroup_CInstNames_Max() return #FGL.db.instnames_mods end

function FindGroup_CInstNames_Click(i)
	if FGL.db.includeaddon then
		FGL.db.FGC.checksplite = i
		FindGroup_CInstNames_SetText()
		FindGroup_AllReWrite()
		if i == 3 then
			FindGroupInstName_PrintPlayers(FGL.db.createTinstnamelist)
			FindGroupInstNameFrameTitle:SetText("Пользовательские названия инстов для сбора")
			FindGroupInstNameFrame:Show()
		end
	else return
	end
end

function FindGroup_CInstNames_Text(i)
	if FGL.db.includeaddon then
		return FGL.db.instnames_mods[i]
	else 
		return ""
	end 
end

function FindGroup_CInstNames_Checked()
	if FGL.db.includeaddon then
		return FGL.db.FGC.checksplite
	else 
		return 1 
	end
end

function FindGroup_CInstNames_Tooltip(i)
	if FGL.db.includeaddon then
		return FGL.db.instnames_modstt[i]
	else 
		return ""
	end 
end

function FindGroup_CInstNames_DropClick()
	local i = FGL.db.FGC.checksplite
	if i == 3 then
		FindGroup_CInstNames_Click(i)
	end
end


---
function FindGroup_CSpecNames_SetText()
	FindGroupOptionsCreateViewFrameComboBox3Text:SetText(FGL.db.specnames_mods[FGL.db.FGC.specmode])
	if FGL.db.specnames_mods[FGL.db.FGC.specmode] == "Написать вручную" then
		FindGroupOptionsCreateViewFrameComboBox3.hl:Show()
	else
		FindGroupOptionsCreateViewFrameComboBox3.hl:Hide()
	end
end

function FindGroup_CSpecNames_Max() return #FGL.db.specnames_mods end

function FindGroup_CSpecNames_Click(i)
	if FGL.db.includeaddon then
		FGL.db.FGC.specmode = i
		FindGroup_CSpecNames_SetText()
		if i == 2 then
			FindGroupInstName_PrintPlayers(FGL.db.createspecnamelist, 1)
			FindGroupInstNameFrameTitle:SetText("Пользовательские названия специализаций")
			FindGroupInstNameFrame:Show()
		end
	else return
	end
end

function FindGroup_CSpecNames_Text(i)
	if FGL.db.includeaddon then
		return FGL.db.specnames_mods[i]
	else 
		return ""
	end 
end

function FindGroup_CSpecNames_Checked()
	if FGL.db.includeaddon then
		return FGL.db.FGC.specmode
	else 
		return 1 
	end
end

function FindGroup_CSpecNames_Tooltip(i)
	if FGL.db.includeaddon then
		return FGL.db.specnames_modstt[i]
	else 
		return ""
	end 
end

function FindGroup_CSpecNames_DropClick()
	local i = FGL.db.FGC.specmode
	if i == 2 then
		FindGroup_CSpecNames_Click(i)
	end
end

local instname_maxframes = 0
local instname_parrentframe_n = "FindGroupInstNameFrameScrollFrameScrollChild"
local instname_parrentframe

function FindGroupInstName_AddButton(i, parrent, flag)
	instname_maxframes = instname_maxframes + 1
	local height = 16
	local f = CreateFrame("Button", parrent:GetName().."Line"..i, parrent, parrent:GetName().."TextButtonTemplate")

	if i < 2 then
		f:SetPoint("TOPLEFT", parrent, "TOPLEFT", 0, -height*(i-1))
		f:SetPoint("BOTTOMRIGHT", parrent, "TOPRIGHT", 0, -height*(i-1)-height)
	else
		if flag then
		f:SetPoint("TOPLEFT", parrent:GetName().."Line"..i-1, "TOPLEFT", 0, -height-height)
		f:SetPoint("BOTTOMRIGHT", parrent:GetName().."Line"..i-1, "TOPRIGHT", 0, -height-height-height)
		else
			f:SetPoint("TOPLEFT", parrent:GetName().."Line"..i-1, "TOPLEFT", 0, -height)
		f:SetPoint("BOTTOMRIGHT", parrent:GetName().."Line"..i-1, "TOPRIGHT", 0, -height-height)	
		end

	end
end

function FindGroupInstName_CorrectButton(i, parrent, flag)
	local height = 16
	f = getglobal(parrent:GetName().."Line"..i)
	if i < 2 then
		f:SetPoint("TOPLEFT", parrent, "TOPLEFT", 0, -height*(i-1))
		f:SetPoint("BOTTOMRIGHT", parrent, "TOPRIGHT", 0, -height*(i-1)-height)
	else
		if flag then
				f:SetPoint("TOPLEFT", parrent:GetName().."Line"..i-1, "TOPLEFT", 0, -height-height)
		f:SetPoint("BOTTOMRIGHT", parrent:GetName().."Line"..i-1, "TOPRIGHT", 0, -height-height-height)
		else
			f:SetPoint("TOPLEFT", parrent:GetName().."Line"..i-1, "TOPLEFT", 0, -height)
		f:SetPoint("BOTTOMRIGHT", parrent:GetName().."Line"..i-1, "TOPRIGHT", 0, -height-height)	
		end

	end
end

function FindGroupInstName_PrintPlayers(my_table, tbl_check)
instname_parrentframe = getglobal(instname_parrentframe_n)
	if instname_maxframes > 0 then
		for i=1, instname_maxframes do
			getglobal(instname_parrentframe:GetName().."Line"..i):Hide()
			getglobal(instname_parrentframe:GetName().."Line"..i.."EditNormal"):SetScript("OnEditFocusLost", nil)
			getglobal(instname_parrentframe:GetName().."Line"..i.."EditNormal"):SetScript("OnTextChanged", nil)
		end
	end
	if tbl_check then
		for h=1, #FGL.db.iconclasses.dd do
			local class = string.upper(FGL.db.iconclasses.dd[h])
			for j=1, 3 do
				local i = (h-1)*3+j
					local flag
					if i > 1 then
						if j==1 then
							flag = 1
						end
					end
				if i > instname_maxframes then 
					FindGroupInstName_AddButton(i, instname_parrentframe, flag) 
				else
					FindGroupInstName_CorrectButton(i, instname_parrentframe, flag)
				end
				getglobal(instname_parrentframe:GetName().."Line"..i.."L"):SetText(FGL.db.classroles[class].originaltrees[j])
				getglobal(instname_parrentframe:GetName().."Line"..i.."EditNormal"):SetText(my_table[class][j])
				getglobal(instname_parrentframe:GetName().."Line"..i.."EditNormal"):SetTextColor(1, 1, 1, 1)
				getglobal(instname_parrentframe:GetName().."Line"..i.."EditNormal"):SetScript("OnTextChanged", function(this)
					my_table[class][j] = this:GetText()
				end)
				
				getglobal(instname_parrentframe:GetName().."Line"..i):Show()
			end
		end
	else
		for i=1, #FGL.db.instances do
			local i_name = FGL.db.instances[i].name
			local flags = true
			if FGL.db.instances[i].patch=="other" then
				flags = false
				if my_table == FGL.db.createTinstnamelist then
					if FindGroupCharVars.othermode then
						flags = true
					end
				end
			end
			if flags then
				local flag
					if i > 1 then
						if not(FGL.db.instances[i-1].patch == FGL.db.instances[i].patch) then
							flag = 1
						end
					end
				if i > instname_maxframes then
					FindGroupInstName_AddButton(i, instname_parrentframe, flag) 
				else
					FindGroupInstName_CorrectButton(i, instname_parrentframe, flag)
				end
				getglobal(instname_parrentframe:GetName().."Line"..i.."L"):SetText(FGL.db.instances[i].name)
				getglobal(instname_parrentframe:GetName().."Line"..i.."EditNormal"):SetTextColor(1, 1, 1, 1)
				getglobal(instname_parrentframe:GetName().."Line"..i.."EditNormal"):SetText(my_table[i_name])
				getglobal(instname_parrentframe:GetName().."Line"..i.."EditNormal"):SetScript("OnEditFocusLost", function(this)
					local msg = this:GetText()
					if my_table == FGL.db.createTinstnamelist then
						if not(FGL.db.instances[i].patch=="other")  then
						if i == FindGroup_GetInstFav(msg, nil, 1) then
							my_table[i_name] = msg
						else
							if i == FindGroup_GetInstFav(string.lower(msg.." ")) then
								if not(FindGroup_FindException(msg)) and not(FindGroup_FindException1(msg)) then
									my_table[i_name] = msg
								end
							end
						end
						else
						my_table[i_name] = msg
						end
					else
						my_table[i_name] = msg
					end
					if not(my_table[i_name] == msg) then
						getglobal(instname_parrentframe:GetName().."Line"..i.."EditNormal"):SetTextColor(1, 0.2, 0.2, 0.8)
						getglobal(instname_parrentframe:GetName().."Line"..i.."EditNormal"):SetText(my_table[i_name])
					else
						getglobal(instname_parrentframe:GetName().."Line"..i.."EditNormal"):SetTextColor(1, 1, 1, 1)
					end
				end)
				getglobal(instname_parrentframe:GetName().."Line"..i):Show()
			end
		end
	end
end



local dropdown_maxframes = 0
local dropdown_parrentframe_n = "FindGroupDropDownScrollFrameScrollChild"
local dropdown_parrentframe

function FindGroupdropdown_AddButton(i, parrent)
	dropdown_maxframes = dropdown_maxframes + 1
	local height = 16
	local f = CreateFrame("Button", parrent:GetName().."Line"..i, parrent, parrent:GetName().."TextButtonTemplate")

	if i < 2 then
		f:SetPoint("TOPLEFT", parrent, "TOPLEFT", 0, -height*(i-1))
		f:SetPoint("BOTTOMRIGHT", parrent, "TOPRIGHT", 0, -height*(i-1)-height)
	else
		f:SetPoint("TOPLEFT", parrent:GetName().."Line"..i-1, "TOPLEFT", 0, -height)
		f:SetPoint("BOTTOMRIGHT", parrent:GetName().."Line"..i-1, "TOPRIGHT", 0, -height-height)	
	end
end

function FindGroupdropdown_Print()
	if not(FGL.db.defbackgroundcheck)then
		FGL.db.defbackgroundcheck = 1
	end 
	dropdown_parrentframe = getglobal(dropdown_parrentframe_n)
	if dropdown_maxframes > 0 then
		for i=1, dropdown_maxframes do
			getglobal(dropdown_parrentframe:GetName().."Line"..i):Hide()
		end
	end
	

		local max = 0;
		for i=1, #FGL.db.defbackgroundfiles do
				if i > dropdown_maxframes then 
					FindGroupdropdown_AddButton(i, dropdown_parrentframe)
				end
				getglobal(dropdown_parrentframe:GetName().."Line"..i.."L"):SetText(FGL.db.defbackgroundfiles[i][1])
				getglobal(dropdown_parrentframe:GetName().."Line"..i.."Check"):Hide()
				if max < getglobal(dropdown_parrentframe:GetName().."Line"..i.."L"):GetWidth() then
					max = getglobal(dropdown_parrentframe:GetName().."Line"..i.."L"):GetWidth()
				end
				getglobal(dropdown_parrentframe:GetName().."Line"..i):SetScript("OnClick", function(this)
					getglobal(dropdown_parrentframe:GetName().."Line"..FGL.db.defbackground.."Check"):Hide()
					FindGroup_ClicktoCBBack(i);
					getglobal(dropdown_parrentframe:GetName().."Line"..FGL.db.defbackground.."Check"):Show()
				end)
				getglobal(dropdown_parrentframe:GetName().."Line"..i):SetScript("OnEnter", function(this)
					UIDropDownMenu_StopCounting(FindGroupDropDown);
				end)				
				getglobal(dropdown_parrentframe:GetName().."Line"..i):SetScript("OnLeave", function(this)
					UIDropDownMenu_StartCounting(FindGroupDropDown);
					GameTooltip:Hide();
				end)					
				getglobal(dropdown_parrentframe:GetName().."Line"..i):Show()
		end

		FindGroupDropDown:SetWidth(max+80)
		FindGroupDropDown:SetMinResize(max+80,130)
		getglobal(dropdown_parrentframe:GetName().."Line"..FGL.db.defbackground.."Check"):Show()
		FindGroupDropDownScrollFrameScrollBar:SetValue(0);
		local min, max = FindGroupDropDownScrollFrameScrollBar:GetMinMaxValues();
		FindGroupDropDownScrollFrameScrollBar:SetValue(((FGL.db.defbackground-1)/(#FGL.db.defbackgroundfiles-1))*(max));
end

local savelist_maxframes = 0
local savelist_parrentframe_n = "FindGroupSaveListFrameScrollFrameScrollChild"
local savelist_parrentframe
local savelist_texturepath = ""
local savelist_comp

function FindGroupsavelist_AddButton(i, parrent)
	savelist_maxframes = savelist_maxframes + 1
	local height = 16
	local f = CreateFrame("Button", parrent:GetName().."Line"..i, parrent, parrent:GetName().."TextButtonTemplate")
	
	f.texture = f:CreateTexture()
	f.texture:SetTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight");
	f.texture:SetBlendMode("ADD");
	f.texture:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0);
	f.texture:SetPoint("TOPRIGHT", f, "TOPRIGHT", 0, 0);
	f.texture:SetVertexColor(0.3, 0.5, 1, 0.8);
	f.texture:Hide()

	f.selectedt = f:CreateTexture()
	f.selectedt:SetTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight");
	f.selectedt:SetBlendMode("ADD");
	f.selectedt:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0);
	f.selectedt:SetPoint("TOPRIGHT", f, "TOPRIGHT", 0, 0);
	f.selectedt:SetVertexColor(1, 1, 1, 0.8);
	f.selectedt:Hide()
	
	if i < 2 then
		f:SetPoint("TOPLEFT", parrent, "TOPLEFT", 0, -height*(i-1))
		f:SetPoint("BOTTOMRIGHT", parrent, "TOPRIGHT", 0, -height*(i-1)-height)
	else
		f:SetPoint("TOPLEFT", parrent:GetName().."Line"..i-1, "TOPLEFT", 0, -height)
		f:SetPoint("BOTTOMRIGHT", parrent:GetName().."Line"..i-1, "TOPRIGHT", 0, -height-height)	
	end
end

function FindGroupsavelist_Print()

	FindGroupSaveListFramePrewiewAddButton:Hide()
	FindGroupSaveListFramePrewiewClearButton:Hide()
	savelist_texturepath = ""
	savelist_comp = nil
	FindGroupSaveListFramePrewiew:SetScript("OnEnter", nil)
	FindGroupSaveListFramePrewiew:SetScript("OnLeave", function(this)									
									FindGroupSaveListFrameTooltip:Hide();							
								end)
	savelist_parrentframe = getglobal(savelist_parrentframe_n)
	if savelist_maxframes > 0 then
		for i=1, savelist_maxframes do
			getglobal(savelist_parrentframe:GetName().."Line"..i):Hide()
		end
	end
	
	local count = 0
	for f=1, #FGL.db.instances do
		for i=1, #FGL.db.difficulties do
			if FindGroupCharVars.FGC.instsaves[f] then
				if FindGroupCharVars.FGC.instsaves[f][i] then
					if FindGroupCharVars.FGC.instsaves[f][i].savelist then
						if #FindGroupCharVars.FGC.instsaves[f][i].savelist > 0 then
							for j=1, #FindGroupCharVars.FGC.instsaves[f][i].savelist do
								count=count+1
								if count > savelist_maxframes then 
									FindGroupsavelist_AddButton(count, savelist_parrentframe)
								end

								local scolor = FGC_GetColor(f, i)
								color= string.format("%02x%02x%02x",ChatTypeInfo[scolor].r*255,ChatTypeInfo[scolor].g*255,ChatTypeInfo[scolor].b*255)
								local title = string.format("|cff%s%s", color, FindGroupCharVars.FGC.instsaves[f][i].savelist[j].text)
								title = string.gsub(title, "|r", "|r|cff" .. color)

								getglobal(savelist_parrentframe:GetName().."Line"..count.."L"):SetText(title)
								
								local my_line = getglobal(savelist_parrentframe:GetName().."Line"..count)
								
								my_line.selectedt:Hide()
								
								if FindGroupCharVars.FGC.instsaves[f][i].save == j then
										my_line.texture:Show()
								else
									my_line.texture:Hide()
								end
								
								my_line:SetScript("OnEnter", function(this)
									FindGroupSaveListFramePrewiew.texture:SetTexture(FGL.db.instances[f].icon)
									FindGroupSaveListFrameTooltip:ClearAllPoints()
									FindGroupSaveListFrameTooltip:SetPoint("BOTTOMLEFT" , my_line , "TOPRIGHT" , 0, 0)
									FindGroupSaveListFrameTooltipInfo:SetWidth(FindGroupSaveListFrameTooltip:GetWidth()-28)
									FindGroupSaveListFrameTooltipInfo:SetText(title)
									local h = FindGroupSaveListFrameTooltipInfo:GetHeight()
									if h < 22 then
										FindGroupSaveListFrameTooltip:SetHeight(h+18)
									else
										FindGroupSaveListFrameTooltip:SetHeight(48)
									end
									
									FindGroupSaveListFrameTooltipText:SetText(title)
									
									FindGroupSaveListFrameTooltip:Show()
									if savelist_comp ~= my_line then
										FindGroupSaveListFramePrewiewAddButton:Hide()
										FindGroupSaveListFramePrewiewClearButton:Hide()
									end
								end)
								
								my_line:SetScript("OnLeave", function(this)
									FindGroupSaveListFramePrewiew.texture:SetTexture(savelist_texturepath)
									FindGroupSaveListFrameTooltip:Hide();
									if not(savelist_texturepath == "") then
										FindGroupSaveListFramePrewiewAddButton:Show()
										FindGroupSaveListFramePrewiewClearButton:Show()
									end
								end)	
								
								my_line:SetScript("OnMouseUp", function(this, button)
									if button == "RightButton" then
										if savelist_comp then
											savelist_comp.selectedt:Hide()
										end
										savelist_texturepath = ""
										FindGroupSaveListFramePrewiewAddButton:Hide()
										FindGroupSaveListFramePrewiewClearButton:Hide()
									elseif button == "LeftButton" then
										if savelist_comp == my_line then 
										
										FindGroup_SaveList_Insert()
										return
										end
									
									
										if savelist_comp then
											savelist_comp.selectedt:Hide()
										end
									
										FindGroupSaveListFramePrewiew:SetScript("OnEnter", function(this)
										FindGroupSaveListFramePrewiew.texture:SetTexture(FGL.db.instances[f].icon)
										FindGroupSaveListFrameTooltip:ClearAllPoints()
										FindGroupSaveListFrameTooltip:SetPoint("BOTTOMLEFT" , this , "TOPLEFT" , 0, 2)
										FindGroupSaveListFrameTooltipInfo:SetWidth(FindGroupSaveListFrameTooltip:GetWidth()-28)
										FindGroupSaveListFrameTooltipInfo:SetText(title)
										local h = FindGroupSaveListFrameTooltipInfo:GetHeight()
										if h < 22 then
											FindGroupSaveListFrameTooltip:SetHeight(h+18)
										else
											FindGroupSaveListFrameTooltip:SetHeight(48)
										end
										
										FindGroupSaveListFrameTooltipText:SetText(title)
										
										FindGroupSaveListFrameTooltip:Show()

										end)	
								
										savelist_comp = my_line
										savelist_texturepath = FGL.db.instances[f].icon
										
										FindGroupSaveListFramePrewiewAddButton:Show()
										FindGroupSaveListFramePrewiewClearButton:Show()
										
										FindGroup_SaveList_Insert = function()
											FindGroupCharVars.FGC.instsaves[f][i].save = j
											FGC_Inst_App2(f, i)			
											FindGroupsavelist_Print()
										end
										
										my_line.selectedt:Show()
										
										FindGroup_SaveList_Delete = function()
											tremove(FindGroupCharVars.FGC.instsaves[f][i].savelist, j)
											if FindGroupCharVars.FGC.instsaves[f][i].save > j then
												FindGroupCharVars.FGC.instsaves[f][i].save = FindGroupCharVars.FGC.instsaves[f][i].save - 1	
											elseif FindGroupCharVars.FGC.instsaves[f][i].save == j then
												FindGroupCharVars.FGC.instsaves[f][i].save = 0
											end
											FindGroupSaveListFramePrewiew.texture:SetTexture("")
											FindGroupsavelist_Print()
										end
									end
								end)
								
								
								my_line:Show()
							end
						end
					end
				end
			end
		end
	end
	
	if count < 1 then
		FindGroupSaveListFrameClearButton:Disable()
	else
		FindGroupSaveListFrameClearButton:Enable()
	end
	
end