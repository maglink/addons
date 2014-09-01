-----------------------------------------------------------------------------TOOLTIPS---------------------------------------------------


function FindGroup_Tooltip_All(this)
	if not(falsetonil(FGL.db.tooltipsstatus)) then return end
	local name
	if FGL.db.tooltips[this:GetName()] then
		name = this:GetName()
	elseif this:GetName():find("FindGroupFrameFindLine") then
		
		name = string.gsub(   this:GetName(), "FindGroupFrameFindLine", "" )
		name = "FindGroupFrameFindLine" .. string.sub(name, 2)
		
	elseif this:GetName() == "FindGroupFrameCreateButton" then
		if FGL.db.createstatus == 1 then
			name = "FindGroupFrameCreateButton2"
		else
			if FindGroup_CreateTrigger_get() ==1 then
				name = "FindGroupFrameCreateButton3"
			else
				name = "FindGroupFrameCreateButton1"
			end
		end
	elseif this:GetName() == "FindGroupFrameConfigButton" then
		if FGL.db.createstatus == 1 then
			name = "FindGroupFrameConfigButton2"
		else
			name = "FindGroupFrameConfigButton1"
		end
	end
	if name then
		FGL.db.tooltips["FindGroupConfigFrameHTextButton"][3]=FGL.db.msgforparty
		local msg
		if FGL.db.tooltips[name][3] == "" then
			msg = string.format("%s", FGL.db.tooltips[name][2])
		else
			msg = string.format("%s\n|cffffffff%s", FGL.db.tooltips[name][2], FGL.db.tooltips[name][3])
		end
		GameTooltip:SetOwner(this, FGL.db.tooltips[name][1])
		GameTooltip:SetText(msg, nil, nil, nil, nil, true)
	end

end


function FindGroup_Tooltip_Fast()
local this = FindGroupShadowFastButton
if falsetonil(FGL.db.tooltipsstatus) then
GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT")
if FGL.db.faststatus == 1 then
	GameTooltip:SetText("Мгновенная отправка сообщений", nil, nil, nil, nil, true)
else
	GameTooltip:SetText("Ручная отправка сообщений", nil, nil, nil, nil, true)
end
end
end

function FindGroup_AchieveIcon_Enter(this)
	local name = this:GetName()
	local i = this:GetParent().numline
	i = i + FindGroupFrameSlider:GetValue()
	if FGL.db.lastmsg[i][14] then
		local text
		if FGL.db.lastmsg[i][14] ~= "true" then
			local id = FGL.db.lastmsg[i][14]
			text = ":\r"..id
		else
			text = ""
		end
		GameTooltip:SetOwner(this, ANCHOR_TOPRIGHT)
		GameTooltip:SetText("Достижение"..text, nil, nil, nil, nil, true)
	end
	this:SetNormalTexture("Interface\\AddOns\\FindGroup\\textures\\UI-GROUP-ACHIEV1")
end

function FindGroup_AchieveIcon_Leave(this)
	this:SetNormalTexture("Interface\\AddOns\\FindGroup\\textures\\UI-GROUP-ACHIEV0")
end

function FindGroup_AchieveIcon_Click(this)
	local name = this:GetName()
	local i = this:GetParent().numline
	i = i + FindGroupFrameSlider:GetValue()
	if FGL.db.lastmsg[i][14] then
		if FGL.db.lastmsg[i][14] ~= "true" then
			local id = FGL.db.lastmsg[i][14]
			ChatFrame_OnHyperlinkShow(ChatFrameTemplate, id, nil, "LeftButton")
		end
	end
end

function FindGroup_QuestIcon_Enter(this)
	local name = this:GetName()
	local i = this:GetParent().numline
	i = i + FindGroupFrameSlider:GetValue()
	if FGL.db.lastmsg[i][15] then
		local text
		if FGL.db.lastmsg[i][15] ~= "true" then
			text = ":\r"..FGL.db.lastmsg[i][15]
		else
			text = ""
		end
		GameTooltip:SetOwner(this, ANCHOR_TOPRIGHT)
		GameTooltip:SetText("Задание"..text, nil, nil, nil, nil, true)
	end
	--this:SetNormalTexture("Interface\\AddOns\\FindGroup\\textures\\UI-GROUP-QUEST1")
end

function FindGroup_QuestIcon_Leave(this)
	--this:SetNormalTexture("Interface\\AddOns\\FindGroup\\textures\\UI-GROUP-QUEST0")
end

function FindGroup_QuestIcon_Click(this) 
	local name = this:GetName()
	local i = this:GetParent().numline
	i = i + FindGroupFrameSlider:GetValue()
	if FGL.db.lastmsg[i][15] then
		if FGL.db.lastmsg[i][15] ~= "true" then
			local text = FGL.db.lastmsg[i][15]
			ChatFrame_OnHyperlinkShow(ChatFrameTemplate, text, nil, "LeftButton")
		end
	end
end

function FindGroup_RepIcon_Enter(this)
	GameTooltip:SetOwner(this, ANCHOR_TOPRIGHT)
	GameTooltip:SetText("Репутация", nil, nil, nil, nil, true)
	--this:SetNormalTexture("Interface\\AddOns\\FindGroup\\textures\\UI-GROUP-QUEST1")
end

function FindGroup_RepIcon_Leave(this)
	--this:SetNormalTexture("Interface\\AddOns\\FindGroup\\textures\\UI-GROUP-QUEST0")
end

function FindGroup_RepIcon_Click(this) 
	
end

function FindGroup_ArenaRegIcon_Enter(this)
	GameTooltip:SetOwner(this, ANCHOR_TOPRIGHT)
	GameTooltip:SetText("Призык к битве!", nil, nil, nil, nil, true)
end

function FindGroup_ArenaFindIcon_Enter(this)
	GameTooltip:SetOwner(this, ANCHOR_TOPRIGHT)
	GameTooltip:SetText("Поиск команды", nil, nil, nil, nil, true)
end

function FindGroup_Tooltip_SendParty(self)
	if falsetonil(FGL.db.tooltipsstatus) then
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")					
		GameTooltip:SetText("Отправить запрос", nil, nil, nil, nil, true)
	end
end
			
function FindGroup_Tooltip_msg(this)
FindGroup_PartyBatton_Enter(this:GetParent().numline)
local i = this:GetParent().numline + FindGroupFrameSlider:GetValue()
GameTooltip:SetOwner(this, "ANCHOR_TOPLEFT")


	local msg = "%s |cff%s[|Hplayer:%s|h|cff%s%s|h|cff%s]: %s"
	if FGL.db.lastmsg[i][9] then
		msg = "%s |cff%s[%s]:|cff%s%s"
		msg = string.format(msg, FGL.db.lastmsg[i][13], FGL.db.lastmsg[i][7], FGL.db.lastmsg[i][2], FGL.db.lastmsg[i][8], FGL.db.lastmsg[i][1])
	else
		msg = string.format(msg, FGL.db.lastmsg[i][13], FGL.db.lastmsg[i][8], FGL.db.lastmsg[i][2], FGL.db.lastmsg[i][7], FGL.db.lastmsg[i][2], FGL.db.lastmsg[i][8], FGL.db.lastmsg[i][1])
	end

GameTooltip:SetText(msg, "1.0", "1.0", "1.0", "1.0", true)


end

GameTooltip:HookScript("OnTooltipSetUnit", function()
	if ( UnitName("mouseover") == GameTooltip:GetUnit() ) then
	local point, relativeTo, relativePoint, xOffset, yOffset = GameTooltip:GetPoint(1)
	FGL.db.tooltippoints.point = point
	FGL.db.tooltippoints.relativeTo = relativeTo
	FGL.db.tooltippoints.relativePoint = relativePoint
	FGL.db.tooltippoints.xOffset = xOffset
	FGL.db.tooltippoints.yOffset = yOffset
	end
end)

_G[FGL.SPACE_NAME].GetFlags = function(flags)
	local q = FindGroupCharVars.usrflags
	if flags then q = tonumber(flags) end
	local nums = _G[FGL.SPACE_NAME].Flags
	local m_table = {}
	for i=1, #nums do
		if (q >= nums[#nums-i+1]) then
			tinsert(m_table, #nums-i+1)
			q = math.fmod(q, nums[#nums-i+1])
		end
	end
	return m_table
end
------------------------------------+______________________+||||||||||||||||||||||||||||||||
------------------------------------+______________________+||||||||||||||||||||||||||||||||

function FindGroup_Tooltip_msgonclick(i)

i = i + FindGroupFrameSlider:GetValue()

if FGL.db.mtooltipstatus == i then 
FindGroupTooltip:Hide();
FGL.db.mtooltipstatus = 0;
return
end
FGL.db.mtooltipstatus = i


if not FGL.db.lastmsg[i] then return end

GameTooltip:Hide()
FindGroupTooltip:Hide()

	local msg = "%s |cff%s[|Hplayer:%s:1|h|cff%s%s|h|cff%s]: %s"
	if FGL.db.lastmsg[i][9] then
		msg = "%s |cff%s[%s]:|cff%s%s"
		msg = string.format(msg, FGL.db.lastmsg[i][13], FGL.db.lastmsg[i][7], FGL.db.lastmsg[i][2], FGL.db.lastmsg[i][8], FGL.db.lastmsg[i][1])
	else
		msg = string.format(msg, FGL.db.lastmsg[i][13], FGL.db.lastmsg[i][8], FGL.db.lastmsg[i][2], FGL.db.lastmsg[i][7], FGL.db.lastmsg[i][2], FGL.db.lastmsg[i][8], FGL.db.lastmsg[i][1])
	end

FindGroupTooltip:SetWidth(FindGroupTooltip:GetParent():GetWidth()+63)
FindGroupTooltip:ClearAllPoints()
FindGroupTooltip:SetPoint("BOTTOMLEFT" , FindGroupFrameTitle , "TOPLEFT" , -8, 10)
FindGroupTooltip:SetHeight(500)

FindGroupTooltipText:SetWidth(FindGroupTooltipText:GetParent():GetWidth()-35)
FindGroupTooltipText:SetText(msg)

FindGroupTooltip:SetHeight(FindGroupTooltipText:GetHeight()+18)

FindGroupTooltipSMF:SetWidth(FindGroupTooltipSMF:GetParent():GetWidth()-35)
FindGroupTooltipSMF:SetHeight(FindGroupTooltipText:GetHeight())
FindGroupTooltipSMF:SetIndentedWordWrap(false)
FindGroupTooltipSMF:AddMessage(msg)

FindGroupTooltip:Show()

end

function FindGroup_Tooltip_msgonhide(this) 
this:Hide()
FGL.db.mtooltipstatus = 0
end


------------------------------------+______________________+||||||||||||||||||||||||||||||||
------------------------------------+______________________+||||||||||||||||||||||||||||||||






