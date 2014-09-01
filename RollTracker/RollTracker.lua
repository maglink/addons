local RollTracker, RTL = ...;

local L = RTL.locales[GetLocale() or "__index"]

RTL.SPACE_NAME = "RollTracker: link"
RTL.SPACE_VERSION = "1.0"

_G[RTL.SPACE_NAME] = {}
_G[RTL.SPACE_NAME].Interface = {}

	
RTL.criteria = {
	roll = {
	"рол",
	"роол",
	"олл",
	"рооол",
	"rol",
	"rool",
	"кщд",
	"hjk",
	"кому",
	"рл",
	},
	reroll = {
	"pere",
	"пере",
	"заного",
	"еще раз",
	"ещё раз",
	"ещераз",
	"ещёраз",
	"опять",
	"rerol",
	"рерол",
	},
}

local rolltable={}
local rollcounttable={}
local itemnummax=1
local itemnum=itemnummax
local itemtable={}
local lastmsg={}
local showstatus, pinstatus
local addonloaded
local ROLLTRACKER_CONFIRM_CLEAR_ROLLS
local tooltipfade,tooltipfadesec,tooltipfadehide=0,5,1
local tooltippoints = {}
local finishingtable = {}
local maxitems = 10
local lastfindtime = 0
local lastfindtime_max = 60

ROLLTRACKER_CONFIRM_CLEAR_ROLLS = L["ROLLTRACKER_CONFIRM_CLEAR_ROLLS"]
rolltable[itemnummax] = {}
rollcounttable[itemnummax] = {}
itemtable[itemnummax] = {}
itemtable[itemnummax].text = L["No Item"]
finishingtable[itemnummax] = true


function RollTracker_SetLocaleText()
	RollTrackerFrameClearButton:Disable()
	RollTrackerFrameComboBox3Text:SetText(RollTracker_GetItemText(itemnum))
	RollTrackerTooltip:SetSize(RollTrackerFrameComboBox3:GetWidth(), 50)
	
	RollTrackerFrameRollButton:SetText(L["Roll"])
	RollTrackerFrameClearButton:SetText(L["Clear"])
end


local sendchat =  function(msg, chan, chantype)
	if chantype == "self" then
		-- To self.
		print("RollTracker:", msg)
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

local GetClassColor = function(class)
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

-- Init
function RollTracker_OnLoad()

	RollTracker_SetLocaleText()
	
	if not RollTrackerDB then RollTrackerDB = {} end -- fresh DB
	local x, y, w, h = RollTrackerDB.X, RollTrackerDB.Y, RollTrackerDB.Width, RollTrackerDB.Height
	if not x or not y or not w or not h then
		RollTracker_SaveAnchors()
	else
		this:ClearAllPoints()
		this:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, y)
		this:SetWidth(w)
		this:SetHeight(h)
	end

		if RollTrackerDB.SHOWSTATUS == 1 then 
			RollTracker_ShowWindow() 
		else 
			RollTracker_HideWindow()
		end

	pinstatus = RollTrackerDB.PINSTATUS
		if pinstatus == nil then pinstatus = 0 end
		if pinstatus == 1 then pinstatus = 0 else pinstatus = 1 end 
		RollTracker_PinButton()

	-- slash command
	SLASH_ROLLTRACKER1 = "/rolltracker";
	SLASH_ROLLTRACKER2 = "/rt";
	SlashCmdList["ROLLTRACKER"] = function (msg)
		if msg == "clear" then
			RollTracker_ClearRolls()
		elseif msg == "show" then
			RollTracker_ShowWindow()
		elseif msg == "hide" then
			RollTracker_HideWindow()
		elseif msg == "open" then
			RollTracker_ShowWindow()
		elseif msg == "close" then
			RollTracker_HideWindow()
		elseif msg == "toggle" then
			if RollTrackerFrame:IsVisible() then
				RollTracker_HideWindow()
			else
				RollTracker_ShowWindow()
			end
		else
			RollTracker_ShowWindow()
		end
	end
end

function RollTracker_ShowWindow()
	RollTracker_UpdateList()
	RollTrackerFrame:Show()
	RollTrackerDB.SHOWSTATUS = 1
end

function RollTracker_HideWindow()
	RollTrackerFrame:Hide()
	RollTrackerDB.SHOWSTATUS = 0
end

function RollTracker_Tooltip_Show()
	if itemtable[itemnum].link then
		RollTrackerTooltipText:SetText(RollTracker_GetItemText(RollTracker_GetCBItemI()))
		RollTrackerTooltipInfo:SetText(itemtable[itemnum].info)
		if RollTrackerTooltipText:GetWidth() > RollTrackerTooltipInfo:GetWidth() then
			RollTrackerTooltip:SetWidth(RollTrackerTooltipText:GetWidth()+55)
		else
			RollTrackerTooltip:SetWidth(RollTrackerTooltipInfo:GetWidth()+55)
		end
		RollTrackerTooltipTexture:SetNormalTexture(GetItemIcon(itemtable[itemnum].link))
		RollTrackerTooltip:SetAlpha(1)
		RollTrackerTooltip:ClearAllPoints()
		if RollTrackerFrame:IsVisible() then
			RollTrackerTooltip:SetPoint("BOTTOMLEFT" , RollTrackerFrameComboBox3Text , "TOPLEFT" , 0, 5)
		elseif tooltippoints.relativeTo then
			RollTrackerTooltip:SetPoint(tooltippoints.point  , tooltippoints.relativeTo , tooltippoints.relativePoint , tooltippoints.xOffset, tooltippoints.yOffset)
		end
		RollTrackerTooltip:Show()
	end
end

function RollTracker_Tooltip_Click()
	if not(RollTrackerFrame:IsVisible()) then
		RollTracker_Tooltip_Hide()
		RollTracker_ShowWindow()
	end
end

function RollTracker_Tooltip_Hide() 
	tooltipfade=0
	RollTrackerTooltip:Hide()
end

function RollTracker_GetItemMax()
	return itemnummax
end

function RollTracker_ClicktoCBItem(i)
	itemnum = RollTracker_GetItemMax() - i + 1
	RollTracker_UpdateList()
end

function RollTracker_GetItemText(i)
	i = RollTracker_GetItemMax() - i + 1
	return itemtable[i].text
end

function RollTracker_CBgettttitle(i) 
	i = RollTracker_GetItemMax() - i + 1
	return itemtable[i].tooltiptitle 
end

function RollTracker_CBgettttext(i) 
	i = RollTracker_GetItemMax() - i + 1
	return itemtable[i].tooltiptext 
end
	function RollTracker_GetCBItemI() 
	return RollTracker_GetItemMax() - itemnum + 1 
end

function RollTracker_OnHyperlinkShow(self,button)
local link, text = itemtable[itemnum].link, itemtable[itemnum].text
if not link or not text then return end
SetItemRef(link, text, button, self)
end

GameTooltip:HookScript("OnTooltipSetUnit", function()
	if ( UnitName("mouseover") == GameTooltip:GetUnit() ) then
	local point, relativeTo, relativePoint, xOffset, yOffset = GameTooltip:GetPoint(1)
	tooltippoints.point = point
	tooltippoints.relativeTo = relativeTo
	tooltippoints.relativePoint = relativePoint
	tooltippoints.xOffset = xOffset
	tooltippoints.yOffset = yOffset
	end
end)

-- Event handler
local roll_event = CreateFrame("Frame")

roll_event:RegisterEvent("CHAT_MSG_RAID")
roll_event:RegisterEvent("CHAT_MSG_RAID_LEADER")
roll_event:RegisterEvent("CHAT_MSG_RAID_WARNING")
roll_event:RegisterEvent("CHAT_MSG_PARTY")
roll_event:RegisterEvent("CHAT_MSG_PARTY_LEADER")
--roll_event:RegisterEvent("CHAT_MSG_CHANNEL")

roll_event:SetScript("OnEvent", function(self, event, ...) RollTracker_GFIND(self, event, ...) end)

function RollTracker_GFIND(self, event, ...)
	local msg, sender, lang, channel, target, flags, unknown, channelNumber, channelName, unknown, counter, guid = ...;
	
	--report
	if RollTracker_findself(msg) then return end

	local yesadd, reroll
	if msg:find("\124Hitem:") then
		if RollTracker_findroll(msg) then yesadd = 1 end
		if RollTracker_findreroll(msg) then reroll = 1 end
		if not yesadd and not reroll and RollTracker_checkmasterorleader(sender) then 
			lastmsg[sender]=msg; lastmsg.sender = sender
			lastfindtime = lastfindtime_max
		end
	else
		if RollTracker_findroll(msg) then yesadd = 1 end
		if RollTracker_findreroll(msg) then reroll = 2
		elseif yesadd and lastmsg[sender] then msg = "" .. msg .. "" .. lastmsg[sender] .. "" 
		else yesadd=nil
		end
		if lastmsg[sender] then lastmsg[sender] = nil; lastmsg.sender = nil end
	end


	if not RollTracker_checkmasterorleader(sender) then yesadd=nil end
	if yesadd then RollTracker_CreateNewRoll(msg, sender, reroll) end
end


------***********************START_CREATE_ROLL***********************************

function RollTracker_CreateNewRoll(msg, sender, reroll)
	local _, _, Color, Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, Name
	lastmsg.sender = nil
	--------------------------------------------------------------------
	if not(reroll == 2) then
	_, _, Color, Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, Name = string.find(msg, "\124(%x*)\124H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*)\124h?%[?([^%[%]]*)%]?\124h?\124r?")
	Color = string.format("\124%s",Color)
	end
	-------------------------------------------------------------------------------------------------------------------------------------
	if reroll == 1 and (itemnummax > 1) then
	finishingtable[itemnummax] = false
	lastfindtime = lastfindtime_max
	itemnummax=itemnummax + 1
	itemnum = itemnummax
	for i=2,itemnummax do
	i = itemnummax - i +1
		if itemtable[i].link == string.format("%s:%d:%d:%d:%d:%d:%d:%d:%d:%d",Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl) then	itemnum=i;break end
	end
	if not(itemnum == itemnummax) then itemnummax=itemnummax - 1 end
	------------------------------------------------------------------------------------------------------------------------------------
	elseif reroll == 2 and (itemnummax > 1) then
		itemnum = itemnummax
	------------------------------------------------------------------------------------------------------------------------------------
	else
	itemnummax=itemnummax + 1
	itemnum = itemnummax
	end
	if not(reroll == 2) then
	itemtable[itemnum] = {}
	itemtable[itemnum].text = string.format("%s|H%s:%d:%d:%d:%d:%d:%d:%d:%d:%d|h[%s]|h|r",Color, Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, Name)
	itemtable[itemnum].link = string.format("%s:%d:%d:%d:%d:%d:%d:%d:%d:%d",Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl)
		local lmsg = msg
		msg = msg:lower()
		msg = string.gsub(msg, "\124(%x*)\124H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*)\124h?%[?([^%[%]]*)%]?\124h?\124r?", "")
		msg = string.format("NOSPACE%s",msg)
		msg = string.gsub(msg, "NOSPACE  ", "")
		msg = string.gsub(msg, "NOSPACE ", "")
		msg = string.gsub(msg, "NOSPACE", "")
	itemtable[itemnum].location, _ = GetInstanceInfo()
	itemtable[itemnum].info = string.format("|cffaaaaaa[%s][|cff%s%s|cffaaaaaa]:|r %s",date("%H:%M:%S"),GetClassColor(select(2,UnitClass(sender))),sender,msg)
	itemtable[itemnum].tooltiptitle = string.format("|cffaaaaaa%s  %s", date("%H:%M:%S"), itemtable[itemnum].location)
	if msg then
		if not(msg=="") and not(msg==" ") then
			itemtable[itemnum].tooltiptext = string.format("|cff%s%s|cffffffff: %s",GetClassColor(select(2,UnitClass(sender))), sender, msg)
		else
			itemtable[itemnum].tooltiptext = nil
		end
	end
	
	itemtable[itemnum].sender = sender
	itemtable[itemnum].time = date("%H:%M:%S")
	local hour, minute = GetGameTime();
	if hour < 10 then
		hour = "0"..hour
	end
	if minute < 10 then
		minute = "0"..minute
	end
	itemtable[itemnum].gametime = string.format("%s:%s:%s", hour, minute, date("%S"))
	
	end
	lastfindtime = lastfindtime_max
	rolltable[itemnum] = {}
	rollcounttable[itemnum] = {}
	RollTrackerFrameComboBox3Text:SetText(RollTracker_GetItemText(RollTracker_GetCBItemI()))
	RollTracker_UpdateList()
	RollTrackerFrameClearButton:Enable()
	RollTrackerFrameRollButton:Enable()
	finishingtable[itemnum] = false
	tooltipfade = tooltipfadesec
end

------***********************END_CREATE_ROLL***********************************

function RollTracker_findself(msg)
	msg = msg:lower()
	if msg:find(RTL.SPACE_NAME:lower()) then return 1 else return nil end
end

function RollTracker_findreroll(msg)
	msg = msg:lower()
	msg = string.gsub(msg, "\124(%x*)\124H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*)\124h?%[?([^%[%]]*)%]?\124h?\124r?", "")

	for i=1, #RTL.criteria.reroll do
		if msg:find(RTL.criteria.reroll[i]) then return 1 end
	end
end

function RollTracker_findroll(msg)
	msg = msg:lower()
	msg = string.gsub(msg, "\124(%x*)\124H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*)\124h?%[?([^%[%]]*)%]?\124h?\124r?", "")
	
	for i=1, #RTL.criteria.roll do
		if msg:find(RTL.criteria.roll[i]) then return 1 end
	end

end

function RollTracker_checkmasterorleader(sender)

	local master, leader
	local lootmethod, masterlooterPartyID, masterlooterRaidID = GetLootMethod()
	local masterlootername
	if masterlooterRaidID then
			masterlootername = GetRaidRosterInfo(masterlooterRaidID)
	elseif masterlooterPartyID then
		if masterlooterPartyID == 0 then
			masterlootername = UnitName("player")
		else
			masterlootername = UnitName("party"..masterlooterPartyID)
		end
	end
	if masterlootername == sender then master=1 end
	if UnitIsPartyLeader(sender) then leader=1 end
	if master or leader then return 1 end

end

function RollTracker_CHAT_MSG_LOOT(self, event, ...)
		local msg, _ = ...;
		if msg:find("\124Hitem:") then
			local _, _, _, _, _, _, _, _, _, _, _, _, _, Name = string.find(msg, "\124(%x*)\124H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*)\124h?%[?([^%[%]]*)%]?\124h?\124r?")
			if (itemtable[itemnummax].text):find(Name) then
				lastfindtime = lastfindtime_max/6
			end
		end
end

function RollTracker_CHAT_MSG_SYSTEM(self, event, ...)

	local pattern = string.gsub(RANDOM_ROLL_RESULT, "[%(%)-]", "%%%1")
	pattern = string.gsub(pattern, "%%s", "(.+)")
	pattern = string.gsub(pattern, "%%d", "%(%%d+%)")


	for name, roll, low, high in string.gmatch(arg1, pattern) do
	if itemnummax == 0 then
		itemnummax=itemnummax + 1
		itemnum=itemnummax
		rolltable[itemnummax] = {}
		rollcounttable[itemnummax] = {}
		itemtable[itemnummax] = {}
		itemtable[itemnummax].text = L["No Item"]
		finishingtable[itemnummax] = true
		local hour, minute = GetGameTime();
		if hour < 10 then
			hour = "0"..hour
		end
		if minute < 10 then
			minute = "0"..minute
		end
		itemtable[itemnummax].gametime = string.format("%s:%s:%s", hour, minute, date("%S"))
		RollTrackerFrameComboBox3Text:SetText(RollTracker_GetItemText(itemnum))
	elseif lastmsg.sender then
		local msg = lastmsg[lastmsg.sender]
		local sender = lastmsg.sender
		RollTracker_CreateNewRoll(msg, sender, reroll)
		if not lastmsg == {} then
			lastmsg[lastmsg.sender] = nil
			lastmsg.sender = nil
		end
	elseif finishingtable[itemnum] and finishingtable[1] and not(itemtable[itemnummax].text == L["No Item"]) then
		itemnummax=itemnummax + 1
		itemnum=itemnummax
		rolltable[itemnummax] = {}
		rollcounttable[itemnummax] = {}
		itemtable[itemnummax] = {}
		itemtable[itemnummax].text = L["No Item"]
		finishingtable[itemnummax] = true
		local hour, minute = GetGameTime();
		if hour < 10 then
			hour = "0"..hour
		end
		if minute < 10 then
			minute = "0"..minute
		end
		itemtable[itemnummax].gametime = string.format("%s:%s:%s", hour, minute, date("%S"))
		RollTrackerFrameComboBox3Text:SetText(RollTracker_GetItemText(itemnum))
	end
			
			
	-- check for rerolls. >1 if rolled before
	local nowitemnum = itemnummax
	
		rollcounttable[nowitemnum][name] = rollcounttable[nowitemnum][name] and rollcounttable[nowitemnum][name] + 1 or 1
		table.insert(rolltable[nowitemnum], {
				Name = name,
				Roll = tonumber(roll),
				Low = tonumber(low),
				High = tonumber(high),
				Count = rollcounttable[nowitemnum][name],
				Class = select(2,UnitClass(name))
			})
			RollTracker_UpdateList()
		end
end


-- Sort and format the list
local function RollTracker_Sort(a, b)
	return a.Roll < b.Roll
end

local function RollTracker_UnSort(a, b)
	return a.Roll > b.Roll
end

function RollTracker_UpdateList()
	local rollText = ""
	local numroll = 0
	table.sort(rolltable[itemnum], RollTracker_Sort)
	for i, roll in pairs(rolltable[itemnum]) do
		if roll.Count == 1 and (roll.Low == 1 and roll.High == 100) then
			numroll = numroll + 1
			rollText = string.format(" %d: |cff%s%s|r\n", roll.Roll, GetClassColor(roll.Class), roll.Name) .. rollText
			RollTrackerFrameClearButton:Enable()
		end
	end
	RollTrackerRollText:SetText(rollText)
	if (table.getn(rolltable[itemnum]) - numroll) == 0 then
		if numroll == 0 then	RollTrackerFrameStatusText:SetText(string.format(" ")) else
			RollTrackerFrameStatusText:SetText(string.format(L["Roll(s)"], numroll))
		end else RollTrackerFrameStatusText:SetText(string.format(L["Roll(s) and FakeRoll(s)"], numroll, table.getn(rolltable[itemnum]) - numroll))
	end
end

function RollTrackerButton_OnClick()
			if showstatus == 1 then
			RollTrackerFrame:Hide()
			showstatus = 0
			else
			RollTracker_ShowWindow()
			showstatus = 1
			end
end

function RollTracker_Report(channel, chantype, max,  report_set_name)

	if (chantype == "channel") then
		local list = {GetChannelList()}
		for i=1,table.getn(list)/2 do
			if(channel == list[i*2]) then
				channel = list[i*2-1]
				break
			end
		end
	end

	if itemnum > 1 then
		if itemtable[itemnum].sender then
			sendchat(string.format(L["ReportText_Player"], RTL.SPACE_NAME, itemtable[itemnum].text, itemtable[itemnum].sender, itemtable[itemnum].gametime), channel, chantype)
		else
			sendchat(string.format(L["ReportText_NoItem"], RTL.SPACE_NAME, itemtable[itemnum].text, itemtable[itemnum].gametime), channel, chantype)			
		end
	else
		sendchat(string.format(L["ReportText"], RTL.SPACE_NAME, itemtable[itemnum].text), channel, chantype)
	end
		table.sort(rolltable[itemnum], RollTracker_UnSort)
		for i, roll in pairs(rolltable[itemnum]) do
			if i > max then break end
			if roll.Count == 1 and (roll.Low == 1 and roll.High == 100) then
					local backspace = ""
					if roll.Roll == 100 then backspace = ""
					elseif (roll.Roll < 100) and (roll.Roll > 9) then backspace = " "
					else backspace = " 0" end
					sendchat(string.format(" %s%d: %s", backspace, roll.Roll, roll.Name), channel, chantype)
			end
		end
end


local RollTracker_cleaning = function()
rollcounttable={}
rolltable={}
itemtable={}

itemnummax=1
itemnum=itemnummax
rolltable[itemnummax] = {}
rollcounttable[itemnummax] = {}
itemtable[itemnummax] = {}
itemtable[itemnummax].text = L["No Item"]
finishingtable[itemnummax] = true
		local hour, minute = GetGameTime();
		if hour < 10 then
			hour = "0"..hour
		end
		if minute < 10 then
			minute = "0"..minute
		end
		itemtable[itemnummax].gametime = string.format("%s:%s:%s", hour, minute, date("%S"))
	RollTrackerFrameClearButton:Disable()
	RollTrackerFrameComboBox3Text:SetText(RollTracker_GetItemText(itemnum))
	RollTracker_UpdateList()
end


StaticPopupDialogs["ROLLTRACKER_CONFIRM_CLEAR_ROLLS"] = {
	text = ROLLTRACKER_CONFIRM_CLEAR_ROLLS,
	button1 = YES,
	button2 = NO,
	enterClicksFirstButton = 0, -- YES on enter
	hideOnEscape = 1, -- NO on escape
	timeout = 0,
	OnAccept = RollTracker_cleaning,
}


			

function RollTracker_ClearRolls()
if RollTrackerFrameClearButton:IsEnabled() then
StaticPopup_Show("ROLLTRACKER_CONFIRM_CLEAR_ROLLS")
end
end

-- GUI
function RollTracker_SaveAnchors()
	RollTrackerDB.X = RollTrackerFrame:GetLeft()
	RollTrackerDB.Y = RollTrackerFrame:GetTop()
	RollTrackerDB.Width = RollTrackerFrame:GetWidth()
	RollTrackerDB.Height = RollTrackerFrame:GetHeight()
end

function RollTracker_AddFakeRolls(i)
for f=1,i do
		table.insert(rolltable[itemnum], {
			Name = tostring(f),
			Roll = f,
			Low = 1,
			High = 100,
			Count = 1
		})
end
RollTracker_UpdateList()
end

function RollTracker_PinButton()
if pinstatus == 1 then
	pinstatus = 0
	RollTrackerFrame:SetMovable("true")
RollTrackerFrameResizeGrip:Show()
RollTrackerFramePinButton:SetNormalTexture("Interface\\AddOns\\FindGroup\\textures\\LockButton-Unlocked-Up.tga")
RollTrackerFramePinButton:SetPushedTexture("Interface\\AddOns\\FindGroup\\textures\\LockButton-Unlocked-Down.tga")
else
	pinstatus = 1
	RollTrackerFrame:SetMovable("fulse")
RollTrackerFrameResizeGrip:Hide()
RollTrackerFramePinButton:SetNormalTexture("Interface\\AddOns\\FindGroup\\textures\\LockButton-Locked-Up.tga")
RollTrackerFramePinButton:SetPushedTexture("Interface\\AddOns\\FindGroup\\textures\\LockButton-Locked-Down.tga")
end
RollTrackerDB.PINSTATUS = pinstatus
end

local AceGUI = LibStub("AceGUI-3.0")
local ReportWindow

local function destroywindow()
	if ReportWindow then
		ReportWindow:ReleaseChildren()
		ReportWindow:Hide()
		ReportWindow:Release()
	end
	ReportWindow = nil
end


function RollTracker_ReportButton(this)
	if ReportWindow==nil then
		CreateReportWindow(this:GetParent())
		ReportWindow:Show()
	else
		ReportWindow:Hide()
	end
end


function CreateReportWindow(window)
if not(type(RollTrackerDB.report) == 'table') then RollTrackerDB.report = {} end
	-- ASDF = window
	ReportWindow = AceGUI:Create("Window")
	local frame = ReportWindow
	frame:EnableResize(nil)
	frame:SetWidth(250)
	frame:SetLayout("Flow")
	frame:SetHeight(300)
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	frame:SetTitle(L["Report"] .. (" - %s"):format("RollTracker"))
	frame:SetCallback("OnClose", function(widget, callback)
		destroywindow()
	end)
	
	local lines = AceGUI:Create("Slider")
	lines:SetLabel(L["Lines"])
	lines:SetValue(RollTrackerDB.report.number ~= nil and RollTrackerDB.report.number	 or 10)
	lines:SetSliderValues(1, 25, 1)
	lines:SetCallback("OnValueChanged", function(self,event, value) 
		RollTrackerDB.report.number = value
		-- Spew("value", value)
	end)
	lines:SetFullWidth(true)
	
	local channeltext = AceGUI:Create("Label")
	channeltext:SetText(L["Channel"])
	channeltext:SetFullWidth(true)
	frame:AddChildren(lines, channeltext)
	
	
	local channellist = {
		{"Whisper", "whisper"},
		{"Whisper Target", "whisper"},
		{"Say", "preset"},
		{"Raid", "preset"},
		{"Party", "preset"},
		{"Guild", "preset"},
		{"Officer", "preset"},
		{"Self", "self"},
	}
	local list = {GetChannelList()}
	for i=2, #list, 2 do
		if list[i] ~= "Trade" and list[i] ~= "General" and list[i] ~= "LookingForGroup" then
			channellist[#channellist+1] = {list[i], "channel"}
		end
	end
	for i=1,#channellist do
		--print(channellist[i][1], channellist[i][2])
		local checkbox = AceGUI:Create("CheckBox")
		_G[RTL.SPACE_NAME].Interface["ReportCheck" .. i] = checkbox
		checkbox:SetType("radio")
		checkbox:SetRelativeWidth(0.5)
		-- checkbox:SetValue(false)
		if RollTrackerDB.report.chantype == "channel" then
			if channellist[i][1] == RollTrackerDB.report.channel then
				frame.channel = channellist[i][1]
				frame.chantype = channellist[i][2]
				checkbox:SetValue(true)
			end
		elseif RollTrackerDB.report.chantype == "whisper" then
			if channellist[i][1] == "Whisper" then
				frame.channel = channellist[i][1]
				frame.chantype = channellist[i][2]
				checkbox:SetValue(true)
			end
		elseif RollTrackerDB.report.chantype == "preset" then
			-- print("pass")
			if rawget(L, channellist[i][1]) and L[channellist[i][1]] == RollTrackerDB.report.channel then
				frame.channel = channellist[i][1]
				frame.chantype = channellist[i][2]
				checkbox:SetValue(true)
			end
		elseif RollTrackerDB.report.chantype == "self" then
			if channellist[i][2] == "self" then
				frame.channel = channellist[i][1]
				frame.chantype = channellist[i][2]
				checkbox:SetValue(true)
			end
		end
		if i >= 9 then
			checkbox:SetLabel(channellist[i][1])
		else
			checkbox:SetLabel(L[channellist[i][1]])
		end
		checkbox:SetCallback("OnValueChanged", function(value)
			
			for i=1, #channellist do
				local c = _G[RTL.SPACE_NAME].Interface["ReportCheck" .. i]
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
	whisperbox:SetLabel("Whisper Target")
	if RollTrackerDB.report.chantype == "whisper" and RollTrackerDB.report.channel ~= L["Whisper"] then
		whisperbox:SetText(RollTrackerDB.report.channel)
		frame.target = RollTrackerDB.report.channel
	end
	whisperbox:SetCallback("OnEnterPressed", function(box, event, text) frame.target = text frame.button.frame:Click() end)
	whisperbox:SetCallback("OnTextChanged", function(box, event, text) frame.target = text end)
	whisperbox:SetFullWidth(true)
	
	local report = AceGUI:Create("Button")
	frame.button = report
	report:SetText(L["Report"])
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
			RollTrackerDB.report.channel = frame.channel
			RollTrackerDB.report.chantype = frame.chantype
			
			RollTracker_Report(frame.channel, frame.chantype, RollTrackerDB.report.number, RollTrackerDB.report.set)
			frame:Hide()
		end
		
	end)
	report:SetFullWidth(true)
	frame:AddChildren(whisperbox, report)
	frame:SetHeight(180 + 27* math.ceil(#channellist/2))
end

local updateframe = CreateFrame("Frame")
updateframe:SetScript("OnUpdate", function(self, elapsed)
	if lastfindtime > 0 then
		lastfindtime = lastfindtime - elapsed
	else
		lastfindtime = 0
		finishingtable[itemnummax] = true
		lastmsg = {}
	end
	
	if not(tooltipfade == 0) then
		if tooltipfade > 0 then
			if tooltipfade == tooltipfadesec then
				RollTracker_Tooltip_Show()
			elseif (tooltipfade < tooltipfadehide) then
				RollTrackerTooltip:SetAlpha(tooltipfade/tooltipfadehide)
			end
			tooltipfade = tooltipfade - elapsed
		else
			RollTracker_Tooltip_Hide()
		end
	end
end)
