
local function FuncMenu_Find()
	FindGroup_ShowWindow()
	if FGL.db.createstatus == 1 then
		FindGroup_CreateButton()
	end
end

local function FuncMenu_Create()
	FindGroup_ShowWindow()
	if not(FGL.db.createstatus == 1) then
		FindGroup_CreateButton()
	end
end


-----------------------------------------

local function toggleMenu(parent)
    if(FindGroupFrame:IsVisible()) then
        FindGroup_HideWindow()
    else
        FindGroup_ShowWindow()
    end
end


local function getFreePoints(x, y)
    local scale = _G.UIParent:GetEffectiveScale();
    local width = _G.UIParent:GetWidth()*scale;
    local height = _G.UIParent:GetHeight()*scale;
    local point;
    
    -- set limits to cursor position. We want to stay on the screen.
    x = math.min(width, math.max(x, 0));
    y = math.min(height, math.max(y, 0));
    
    --determine TOP or BOTTOM
    if(y > height/2) then
        point = "TOP";
        y = y - height;
    else
        point = "BOTTOM";
    end
    
    --determine LEFT or RIGHT
    if(x < width/2) then
        point = point.."LEFT";
    else
        point = point.."RIGHT";
        x = x - width;
    end
    
    return point, x, y;
end

function FindGroup_CreateMinimapIcon()
    local icon = CreateFrame('Button', 'FindGroupFrameMinimapButton');
    icon.Load = function(self)
        self:SetFrameStrata('TOOLTIP');
	self:SetWidth(31); self:SetHeight(31);
	self:SetFrameLevel(8);
       	self:SetMovable(true);
	self:RegisterForClicks('LeftButtonUp', "RightButtonUp");
	self:SetHighlightTexture('Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight');

	local overlay = self:CreateTexture(nil, 'OVERLAY');
	overlay:SetWidth(53); overlay:SetHeight(53);
	overlay:SetTexture('Interface\\Minimap\\MiniMap-TrackingBorder');
	overlay:SetPoint('TOPLEFT');

	local bg = self:CreateTexture(nil, 'BACKGROUND');
	bg:SetWidth(20); bg:SetHeight(20);
	bg:SetTexture('Interface\\CharacterFrame\\TempPortraitAlphaMask');
	bg:SetPoint("TOPLEFT", 6, -6)
	self.backGround = bg;

	local text = self:CreateFontString(nil, "BACKGROUND");
	text:SetFont("Fonts\\SKURRI.ttf", 16);
	text:SetAllPoints(bg);
	text:SetText("");
	self.text = text;

	local ticon = self:CreateTexture(nil, 'BORDER');
	ticon:SetWidth(20); ticon:SetHeight(20);
	ticon:SetTexture('Interface\\Icons\\spell_shadow_demonicempathy');
	ticon:SetTexCoord(0.05, 0.95, 0.05, 0.95);
	ticon:SetPoint("TOPLEFT", 6, -5)
	self.icon = ticon;

	local flash = CreateFrame("Frame", "FindGroupFrameMinimapButtonFlash", self);
	flash:SetFrameStrata('MEDIUM');
	flash:SetParent(self);
	flash:SetAllPoints(self);
	flash:Show();
	flash.texture = flash:CreateTexture(nil, "BORDER");
	flash.texture:SetTexture('Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight');
	flash.OnUpdate = function(self, elapsed)

				local minimap = self:GetParent();
				minimap.text:Hide();
				minimap.icon:Show();
				minimap.backGround:SetGradient("VERTICAL", 0.1, 0.1, 0.1, 0.1, 0.1, 0.1);
				flash:Hide();
			end

	flash:SetScript("OnUpdate", flash.OnUpdate);
       	icon.flash = flash;
	self:SetScript('OnEnter', self.OnEnter);
	self:SetScript('OnLeave', self.OnLeave);
	self:SetScript('OnClick', self.OnClick);
	self:SetScript('OnDragStart', self.OnDragStart);
	self:SetScript('OnDragStop', self.OnDragStop);
	self:SetScript('OnMouseDown', self.OnMouseDown);
	self:SetScript('OnMouseUp', self.OnMouseUp);
    end
    icon.SetText = function(self, text)
	text = text or "";
	local font, _, _ = icon.text:GetFont();
	if(string.len(text) == 1) then
	    icon.text:SetFont(font, 16);
	elseif(string.len(text) == 2) then
	    icon.text:SetFont(font, 14);
	else
	    icon.text:SetFont(font, 12);
	end
	icon.text:SetText(text);
    end
    icon.OnClick = function(self, button)
        if(button == "LeftButton") then
            toggleMenu(self);
        elseif(button == "RightButton") then
self:OnDragStop()
if self.FGL_MAP_MENU:IsVisible() then
	self.FGL_MAP_MENU:Hide()
else
	self.FGL_MAP_MENU:Show()
end
 GameTooltip:Hide()
        end
    end
    icon.OnMouseDown = function(self)
        self.icon:SetTexCoord(0, 1, 0, 1);
self.FGL_MAP_MENU:Hide()
    end
    icon.OnMouseUp = function(self)
        self.icon:SetTexCoord(0.05, 0.95, 0.05, 0.95);
    end
    icon.OnEnter = function(self)
        FindGroup_Tooltip_All(this)
    end
    icon.OnLeave = function(self)
        GameTooltip:Hide()
    end
    icon.OnDragStart = function(self)
        self.dragging = true;
	self:LockHighlight();
	self.icon:SetTexCoord(0, 1, 0, 1);
        self:SetScript('OnUpdate', self.OnUpdate);
	_G.GameTooltip:Hide();
    end
    icon.OnDragStop = function(self)
        self.dragging = nil;
	self:SetScript('OnUpdate', nil);
	self.icon:SetTexCoord(0.05, 0.95, 0.05, 0.95);
	self:UnlockHighlight();
        self.registeredForDrag = nil;
        self:RegisterForDrag();
    end
    icon.OnUpdate = function(self, elapsed)
		if self.dragging then
			local mx, my = _G.Minimap:GetCenter();
			local px, py = _G.GetCursorPosition();
			local scale = _G.Minimap:GetEffectiveScale();

			if falsetonil(FGL.db.minimapiconfree) then
				local free = FindGroupCharVars.minimapposition_free;
				free.point, free.x, free.y = getFreePoints(px, py);
			else
				px, py = px / scale, py / scale;
				FindGroupCharVars.minimapposition = math.deg(math.atan2(py - my, px - mx)) % 360;
			end
			self:UpdatePosition();
		end
    end
    icon.UpdatePosition = function(self)
        if falsetonil(FGL.db.minimapiconfree) then
            local free = FindGroupCharVars.minimapposition_free;
            self:SetFrameStrata("TOOLTIP");
            self:SetParent(_G.UIParent);
            self:ClearAllPoints();
            local scale = _G.UIParent:GetEffectiveScale();
            self:SetPoint("CENTER", _G.UIParent, free.point, free.x/scale, free.y/scale)
        else
            self:SetFrameStrata("LOW");
            self:SetParent(_G.Minimap);
            self:SetFrameLevel(100);
	if not FindGroupCharVars.minimapposition then FindGroupCharVars.minimapposition = random(0, 360) end
            local angle = math.rad(FindGroupCharVars.minimapposition)
            local cos = math.cos(angle);
            local sin = math.sin(angle);
			local minimapShape = nil
			if _G.GetMinimapShape then
			local bool=nil
			bool, minimapShape = pcall (_G.GetMinimapShape)
			end
            local minimapShape = minimapShape or 'ROUND';

            local round = false;
            if minimapShape == 'ROUND' then
		round = true;
            elseif minimapShape == 'SQUARE' then
            	round = false;
            elseif minimapShape == 'CORNER-TOPRIGHT' then
		round = not(cos < 0 or sin < 0);
            elseif minimapShape == 'CORNER-TOPLEFT' then
		round = not(cos > 0 or sin < 0);
            elseif minimapShape == 'CORNER-BOTTOMRIGHT' then
		round = not(cos < 0 or sin > 0);
            elseif minimapShape == 'CORNER-BOTTOMLEFT' then
		round = not(cos > 0 or sin > 0);
            elseif minimapShape == 'SIDE-LEFT' then
		round = cos <= 0;
            elseif minimapShape == 'SIDE-RIGHT' then
		round = cos >= 0;
            elseif minimapShape == 'SIDE-TOP' then
		round = sin <= 0;
            elseif minimapShape == 'SIDE-BOTTOM' then
		round = sin >= 0;
            elseif minimapShape == 'TRICORNER-TOPRIGHT' then
		round = not(cos < 0 and sin > 0);
            elseif minimapShape == 'TRICORNER-TOPLEFT' then
		round = not(cos > 0 and sin > 0);
            elseif minimapShape == 'TRICORNER-BOTTOMRIGHT' then
		round = not(cos < 0 and sin < 0);
            elseif minimapShape == 'TRICORNER-BOTTOMLEFT' then
		round = not(cos > 0 and sin < 0);
            end

            local x, y;
            if round then
            	x = cos*80;
            	y = sin*80;
            else
            	x = math.max(-82, math.min(110*cos, 84));
            	y = math.max(-86, math.min(110*sin, 82));
            end

            self:ClearAllPoints();
            self:SetPoint('CENTER', x, y);
            local scale = self:GetEffectiveScale();
	if not FindGroupCharVars.minimapposition_free then FindGroupCharVars.minimapposition_free = {} end
            FindGroupCharVars.minimapposition_free.point, FindGroupCharVars.minimapposition_free.x, FindGroupCharVars.minimapposition_free.y = getFreePoints((self:GetLeft() + self:GetWidth()/2)*scale, (self:GetTop() - self:GetHeight()/2)*scale);
      end
    end
    icon:Load();
    
    local helperFrame = _G.CreateFrame("Frame");
    helperFrame:SetScript("OnUpdate", function(self, elapsed)
	if falsetonil(FGL.db.minimapiconshow) then
		if not icon:IsVisible() then
			icon:Show()
		end
		self.timeElapsed = (self.timeElapsed or 0) + elapsed;
		if GetMouseFocus() then
			if GetMouseFocus() == icon then
				self.timeElapsed = 0;
			end
		end
		while(self.timeElapsed > 1) do
			if GetMouseFocus() then
				if not(GetMouseFocus() == icon) and not(GetMouseFocus() == icon.FGL_MAP_MENU or GetMouseFocus():GetParent() == icon.FGL_MAP_MENU ) and icon.FGL_MAP_MENU:IsVisible() then
					icon.FGL_MAP_MENU:Hide()
				end
			end
			self.timeElapsed = 0;
		end
	else
		if icon:IsVisible() then
			icon:Hide()
		end
	end
	icon:UpdatePosition();
           if(not(icon.dragging) and not(icon.registeredForDrag) and GetMouseFocus() == icon) then
                icon.registeredForDrag = true;
                icon:RegisterForDrag('RightButton');
            end
        end);
    
    return icon;
end


local icon


function FindGroup_LoadMinimapIcon()
 	icon = FindGroup_CreateMinimapIcon()
 	icon.registeredForDrag = nil
	icon:Show()
	icon:UpdatePosition();

--------------------------------------
--      Right Click Menu     --
--------------------------------------
local menu_func={
	{	name="Открыть окно поиска",			func=FuncMenu_Find,		},
	{	name="Выключить оповещение",			func=FindGroup_AlarmButton,	},
	{	name="separator"									},
	{	name="Открыть окно сбора",			func=FuncMenu_Create,		},
	{	name="Кд список",				func=FindGroupSaves_Toggle,	},
	{	name="separator"									},
	{	name="Hастройки",				func=FindGroup_ShowOptions,	},
}

icon.FGL_MAP_MENU = CreateFrame("Frame", icon:GetName().."Menu", UIParent, "GameTooltipTemplate")
icon.FGL_MAP_MENU:SetPoint("TOPRIGHT", icon, "BOTTOMLEFT")
icon.FGL_MAP_MENU:EnableMouse(true)
icon.FGL_MAP_MENU:SetSize(200, 50)
local height = 20
icon.FGL_MAP_MENU:SetHeight((#menu_func)*height+10)
icon.FGL_MAP_MENU:SetScript("OnShow", function(self) self:SetFrameStrata('TOOLTIP'); end)

for i=1, #menu_func do
	local f = CreateFrame("Button", icon.FGL_MAP_MENU:GetName()..i,  icon.FGL_MAP_MENU)
	f:SetPoint("TOPLEFT", icon.FGL_MAP_MENU, "TOPLEFT", 5, -5-height*(i-1))
	f:SetPoint("BOTTOMRIGHT", icon.FGL_MAP_MENU, "TOPRIGHT", -5, -5-height*(i-1)-height)
	f:Show()

	local g = f:CreateFontString(f:GetName().."Text",  "BACKGROUND", "GameFontNormal")
	g:SetPoint("TOPLEFT", f, "TOPLEFT", 5,-5)
	g:SetHeight(10)
	g:SetText("")
	g:SetTextColor(1, 1, 1, 1)
	g:Show()


	if not (menu_func[i].name == "separator") then
		f:SetHighlightTexture("Interface\\Buttons\\UI-Listbox-Highlight")
		f:SetScript("OnClick", function()
			menu_func[i].func()
			icon.FGL_MAP_MENU:Hide()
		end)

		if menu_func[i].func == FindGroup_AlarmButton then
			f:SetScript("OnShow", function()
				if FGL.db.alarmstatus == 1 then
					g:SetText("Выключить оповещение")
				else
					g:SetText("Включить оповещение")				
				end
			end)
		elseif menu_func[i].func == FindGroupSaves_Toggle then
			f:SetScript("OnShow", function()
				if FindGroupSaves_CheckMainButton() then
					f:Enable()
					g:SetTextColor(1, 1, 1, 1)
				else
					f:Disable()
					g:SetTextColor(0.63, 0.63, 0.63, 1)
				end
			end)
		end


		g:SetText(menu_func[i].name)
	end

 	if icon.FGL_MAP_MENU:GetWidth() < g:GetWidth() then icon.FGL_MAP_MENU:SetWidth(g:GetWidth()) end
end




end

function FindGroup_HideMinimapIcon()
	if icon then
		icon:UpdatePosition();
		icon:Hide()
	end
end

function FindGroup_ShowMinimapIcon()
	if icon then
		icon:UpdatePosition();
		icon:Show()
	end

end






