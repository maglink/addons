local start_id=80
local parrent
local max_buttons = 0
local button_size = 36

function MoreButtons_CreateButton(i)
	local x, y = 6, -8
	max_buttons = max_buttons + 1
	local f = CreateFrame("CheckButton", parrent:GetName()..i, parrent, "MultiBar1ButtonTemplate")
	f:SetID(start_id+i)
	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", parrent, "TOPLEFT", ((i-1)*(button_size+x))+x*2, y-15)
	f:Show()
	ActionButton_OnLoad(f);
end

function MoreButtons_UpdateParentSize()
	parrent:SetSize(MoreButtonsDB.buttons*(button_size+6) + 35, button_size+8*2+15)
end

function MoreButtons_AddButton()
	if max_buttons > MoreButtonsDB.buttons then
		MoreButtonsDB.buttons = MoreButtonsDB.buttons + 1
		local f = getglobal(parrent:GetName()..MoreButtonsDB.buttons)
		f:Show()
		ActionButton_OnLoad(f);
		ActionButton_ShowGrid(f);
		ActionButton_UpdateState(f);
	else
		MoreButtonsDB.buttons = MoreButtonsDB.buttons + 1
		MoreButtons_CreateButton(max_buttons+1)
	end
	MoreButtons_UpdateParentSize()
end

function MoreButtons_DeleteButton()
	if MoreButtonsDB.buttons > 1 then
		local f = getglobal(parrent:GetName()..MoreButtonsDB.buttons)
		f:Hide()
		ActionButton_HideGrid(f)
		MoreButtonsDB.buttons = MoreButtonsDB.buttons - 1
		MoreButtons_UpdateParentSize()
	end
end

local maxtime = 1
local fulltime = 1
local elapstime = 0
local holdfulltime=0.5
local holdtime=0

function MoreButtons_OnUpdate(self, elapsed)
	if max_buttons > MoreButtonsDB.buttons then
		for i=MoreButtonsDB.buttons+1, max_buttons do
			local f = getglobal(parrent:GetName()..i)
			f:Hide()
		end
	end
	
	if GetMouseFocus() then
		if GetMouseFocus() == parrent or 
		GetMouseFocus() == parrent.add or 
		GetMouseFocus() == parrent.scale or 
		GetMouseFocus() == parrent.delete 
		then
			MoreButtonsDB.hide = true
			holdtime = holdtime + elapsed
			if holdfulltime < holdtime then
				elapstime = fulltime + maxtime
			end
		else
			holdtime = 0
		end
	else
		holdtime = 0
	end
	
	elapstime = elapstime - elapsed
	local alpha = 1
	if MoreButtonsDB.hide then
	if elapstime > 0 then 
		if elapstime > fulltime then
			alpha = 1
		else
			alpha = elapstime/fulltime
		end
	else
		alpha = 0
	end
	end
	
		self:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b, alpha);
		self:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b, alpha);
		parrent.delete:SetAlpha(alpha)
		parrent.scale:SetAlpha(alpha)
		parrent.scale.text:SetAlpha(alpha)
		parrent.add:SetAlpha(alpha)
		if alpha > 0 then 
			parrent.scale:Show()
			parrent.delete:Show()
			parrent.add:Show()
			parrent:SetMovable(true)
		else 
			parrent.scale:Hide()
			parrent.delete:Hide()
			parrent.add:Hide()
			parrent:SetMovable(false) 
		end
		MoreButtonsDB.scale = parrent:GetScale()
		MoreButtons_SaveAnchors()
		
			for i=1, MoreButtonsDB.buttons do
				ActionButton_UpdateCooldown(getglobal(parrent:GetName()..i));
			end
end

function MoreButtons_SaveAnchors()
	MoreButtonsDB.X = parrent:GetLeft()
	MoreButtonsDB.Y = parrent:GetTop()
end

function MoreButtons_SetAnchors()
	parrent:ClearAllPoints()
	parrent:SetPoint("TOPLEFT", parrent:GetParent(), "BOTTOMLEFT", MoreButtonsDB.X, MoreButtonsDB.Y)
end

function MoreButtons_OnLoad()
	parrent = MoreButtonsFrame
	parrent:Show()

	parrent:SetScript("OnUpdate", function(self,elapsed) MoreButtons_OnUpdate(self,elapsed) end)
	
	if not MoreButtonsDB then MoreButtonsDB = {} end
	if not MoreButtonsDB.X or not MoreButtonsDB.Y then
		parrent:SetPoint("CENTER")
		MoreButtons_SaveAnchors()
	else
		MoreButtons_SetAnchors()
	end

	if not MoreButtonsDB.scale then MoreButtonsDB.scale = 1 end
	parrent:SetScale(MoreButtonsDB.scale)
	parrent.scale:SetValue(MoreButtonsDB.scale*100)
	if not MoreButtonsDB.buttons then MoreButtonsDB.buttons = 1 end
	for i=1, MoreButtonsDB.buttons do MoreButtons_CreateButton(i) end
	MoreButtons_UpdateParentSize()
end