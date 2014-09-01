local GeekRate, GR = ...;

GR.d=60*60*24
GR.m=GR.d*30.4368499
GR.y=12*GR.m

GR.now_day = floor(time() / GR.d)

GR.global_char_table = nil
GR.global_char_name_honor = nil
GR.global_char_name = nil
GR.realm = nil
GR.faction_filter = UnitFactionGroup("player")
GR.filter = ""


function GetStatisticId(CategoryTitle, StatisticTitle)
	local str = ""
	for _, CategoryId in pairs(GetStatisticsCategoryList()) do
		local Title, ParentCategoryId, Something
		Title, ParentCategoryId, Something = GetCategoryInfo(CategoryId)
		if Title == CategoryTitle then
			local i
			local statisticCount = GetCategoryNumAchievements(CategoryId)
			for i = 1, statisticCount do
				local IDNumber, Name, Points, Completed, Month, Day, Year, Description, Flags, Image, RewardText
				IDNumber, Name, Points, Completed, Month, Day, Year, Description, Flags, Image, RewardText = GetAchievementInfo(CategoryId, i)
				if Name == StatisticTitle then
					return IDNumber
				end
			end
		end
	end
	return -1
end

GR.profs = {
	{name = "Алхимия", 			abb="A", 	find="Изучено алхимических рецептов"},
	{name = "Кузнечное дело", 	abb="Ку", 	find="Изучено чертежей кузнечного дела"},
	{name = "Кожевничество", 	abb="Ко",	find="Изучено кожевенных выкроек"},
	{name = "Наложение чар", 	abb="Нал", 	find="Изучено формул наложения чар"},
	{name = "Начертание", 		abb="Нач", 	find="Изучено начертаний"},
	{name = "Портняжное дело", 	abb="П", 	find="Изучено портняжных выкроек"},
	{name = "Ювелирное дело", 	abb="Ю", 	find="Изучено эскизов ювелирных изделий"},
	{name = "Горное дело", 		abb="Г", 	find="Изучено рецептов выплавки металлов"},
	{name = "Снятие шкур", 		abb="(С)", 	find="Наивысший уровень навыка в снятии шкур"},
	{name = "Травничество", 	abb="(Т)", 	find="Наивысший уровень навыка в травничестве"},
}

GR.Event = CreateFrame("Frame")
GR.Event:RegisterEvent("ADDON_LOADED")
GR.Event:SetScript("OnEvent", function(self, event)
	if event == "ADDON_LOADED" then
		self:UnregisterEvent("ADDON_LOADED")
		self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
		self:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
		self:RegisterEvent("INSPECT_HONOR_UPDATE")
		GR.OnLoad()
	end
	if event == "UPDATE_MOUSEOVER_UNIT" then
		ClearAchievementComparisonUnit()
		local unit = "mouseover"
		if not UnitIsPlayer(unit) then return end
		local name = UnitName(unit)
		local realm = GR.realm
		if not name then return end
		if type(GeekRateDB.db[realm]) ~= 'table' then
			GeekRateDB.db[realm] = {}
		end
		local flag = false
		if type(GeekRateDB.db[realm][name]) ~= 'table' then
			GeekRateDB.db[realm][name] = {}
			flag = true
		end
		local char_table = GeekRateDB.db[realm][name]
		if type(char_table.achieves) ~= 'table' then
			char_table.achieves = {}
		end
		if type(char_table.profs) ~= 'table' then
			char_table.profs = {}
		end
	
		char_table.class = select(2,UnitClass(unit))
		char_table.faction = UnitFactionGroup(unit)
				
		if CanInspect(unit) then
			NotifyInspect(unit)
			GR.global_char_name_honor = name
			RequestInspectHonorData()
		end
		GR.global_char_name = name
		SetAchievementComparisonUnit(unit)
		
		if flag then
			GR.AddToToolTip_print("please mouseover again",1,1,1)
		else
			GR.AddToToolTip(char_table)
		end
	end
	if event == "INSPECT_ACHIEVEMENT_READY" then
		if not GR.global_char_name then return end
		local name = GR.global_char_name
		GR.global_char_name = nil
		if name ~= UnitName("mouseover") then return end
		local char_table = GeekRateDB.db[GR.realm][name]
		
		char_table.profs = {}
		for i=1, #GR.profs do
			local value = GetComparisonStatistic(GetStatisticId("Профессии", GR.profs[i].find))
			value = tonumber(value:sub(1,3))
			if type(value) == 'number' then
				if value > 0 then
					tinsert(char_table.profs, GR.profs[i].abb)
				end
			end
		end
		
		local old_achi_point = char_table.AchievePoints
		char_table.AchievePoints = GetComparisonAchievementPoints()
		if old_achi_point ~= nil then
			if char_table.AchievePoints <= old_achi_point then 
				char_table.AchievePoints = old_achi_point
				return
			end
		end
		
		for i=1, #GeekRateDB.Achieves do
			local achievementID = GeekRateDB.Achieves[i]
			local flag = true
			if char_table.achieves[achievementID] then
				flag = false
			end
			if flag then
				local completed, month, day, year = GetAchievementComparisonInfo(achievementID)
				if completed then
					local sum = GR.d*day
					sum = sum + GR.m*(month-1)
					sum = sum + GR.y*(2000+year-1970)
					char_table.achieves[achievementID] = floor(sum/GR.d)
				end
			end
		end


		
		
		--[[]
		if type(char_table.achieveshrono) ~= 'table' then
			char_table.achieveshrono = {}
		end
		local list = GetCategoryList()
		for i=1, #list do
			for j=1, GetCategoryNumAchievements(list[i]) do
				local achievementID, _ = GetAchievementInfo(list[i], j)
				local completed, month, day, year = GetAchievementComparisonInfo(achievementID)
				if completed then
					local sum = GR.d*day
					sum = sum + GR.m*(month-1)
					sum = sum + GR.y*(2000+year-1970)
					local lastdays = floor(sum/GR.d)
					if not char_table.achieveshrono[lastdays] then
						char_table.achieveshrono[lastdays] = 0
					end
					char_table.achieveshrono[lastdays] = char_table.achieveshrono[lastdays] + 1
				end
			end
		end
]]
		ClearAchievementComparisonUnit()
	end
	if event == "INSPECT_HONOR_UPDATE" then
		if not GR.global_char_name_honor then return end
		local name = GR.global_char_name_honor
		GR.global_char_name_honor = nil
		if name ~= UnitName("mouseover") then return end
		local char_table = GeekRateDB.db[GR.realm][name]
		local _, _, _, _, lifetimeHK, _ = GetInspectHonorData()
		char_table.lifetimeHK = lifetimeHK
		ClearInspectPlayer()
	end
end)

GR.AddToToolTip_print = function(text, r, g , b)
	GameTooltip:AddLine(text, r, g, b, true)
	GameTooltip:SetHeight(GameTooltip:GetHeight()+13)
end

GR.AddToToolTip = function(char_table)
	
	GR.AddToToolTip_print("====GeekRate====",1,1,1)
	
	if char_table.lifetimeHK and GeekRateDB.HonorKills == 1 then
		local red = char_table.lifetimeHK/15000
		if red > 1 then red = 1 end
		GR.AddToToolTip_print("|cffffffffKills:|r "..char_table.lifetimeHK ,red,(1-(math.sqrt(red*(red-0.5)))),(1-red))
	end
	if char_table.AchievePoints and GeekRateDB.AchievePoints == 1 then
		local red = char_table.AchievePoints/7000
		if red > 1 then red = 1 end
		GR.AddToToolTip_print("|cffffffffAchievePoints:|r "..char_table.AchievePoints ,red,(1-(math.sqrt(red*(red-0.5)))),(1-red))
	end

	local firstachieve = 1
	
	local texts = {
		"%s incomplete",
		"%s %d days (%s years)",
		"%s %d days",
	}
	for i=1, #GeekRateDB.Achieves do
		local achievementID = GeekRateDB.Achieves[i]	
		if char_table.achieves[achievementID] then
			local text = ""
			local red = 0
			local link = GetAchievementLink(achievementID)
			if not char_table.achieves[achievementID] then
				text = string.format(texts[1], link)
			else
				local days = GR.now_day - char_table.achieves[achievementID]
				local years = floor((days*10)/355.5)
				red = days/650
				if days > 355.5 then
					text = string.format(texts[2], link, days, tostring(years/10))
				else
					text = string.format(texts[3], link, days)
				end
			end
			if red > 1 then red = 1 end
			if firstachieve then
				GR.AddToToolTip_print("Achieves:",1,1,1)
				firstachieve = nil
			end
			GR.AddToToolTip_print(text,red,(1-(math.sqrt(red*(red-0.5)))),(1-red))
		end
	end
	
	if GeekRateDB.Profs == 1 then
		
		local text = "--"
		for i=1, #char_table.profs do
			if i == 1 then
				text = char_table.profs[i]
			else
				text = text..char_table.profs[i]
			end
		end
		
		local red = #char_table.profs/4
		if red > 1 then red = 1 end
		GR.AddToToolTip_print("|cffffffffProfessions:|r "..text ,red,(1-(math.sqrt(red*(red-0.5)))),(1-red))
	end
	GR.AddToToolTip_print("===============",1,1,1)
end





function GeekRate_Faction_Get()
	return GR.faction_filter
end

function GeekRate_Faction_Set(name)
	GR.faction_filter = name
	GR.ShowList()
end

function GeekRate_Filter_Set(frase)
	GR.filter = frase
	GR.ShowList()
end


local sort_variants = 
{
	{
		function(a, b) return string.lower(a.name) < string.lower(b.name) end, 
		function(a, b) return string.lower(a.name) > string.lower(b.name) end,
	},
	{
		function(a, b) 
			if not a.char_table.lifetimeHK then if not b.char_table.lifetimeHK then return 0 > 0 else return 0 > 1 end end
			if not b.char_table.lifetimeHK then if not a.char_table.lifetimeHK then return 0 > 0 else return 1 > 0 end end
			return a.char_table.lifetimeHK > b.char_table.lifetimeHK
		end,
		function(a, b) 
			if not a.char_table.lifetimeHK then if not b.char_table.lifetimeHK then return 0 < 0 else return 0 < 1 end end
			if not b.char_table.lifetimeHK then if not a.char_table.lifetimeHK then return 0 < 0 else return 1 < 0 end end
			return a.char_table.lifetimeHK < b.char_table.lifetimeHK 
		end,
	},
	{
		function(a, b) 
			if not a.char_table.AchievePoints then if not b.char_table.AchievePoints then return 0 > 0 else return 0 > 1 end end
			if not b.char_table.AchievePoints then if not a.char_table.AchievePoints then return 0 > 0 else return 1 > 0 end end
			return a.char_table.AchievePoints > b.char_table.AchievePoints 
		end,
		function(a, b) 
			if not a.char_table.AchievePoints then if not b.char_table.AchievePoints then return 0 < 0 else return 0 < 1 end end
			if not b.char_table.AchievePoints then if not a.char_table.AchievePoints then return 0 < 0 else return 1 < 0 end end
			return a.char_table.AchievePoints < b.char_table.AchievePoints 
		end,
	},
	{
		function(a, b)
			local a_points, b_points = 0, 0
			if a.char_table.achieves[13] then
				a_points=GR.now_day-a.char_table.achieves[13]
			end
			if b.char_table.achieves[13] then
				b_points=GR.now_day-b.char_table.achieves[13]
			end
			return a_points > b_points
		end,
		function(a, b)
			local a_points, b_points = 0, 0
			if a.char_table.achieves[13] then
				a_points=GR.now_day-a.char_table.achieves[13]
			end
			if b.char_table.achieves[13] then
				b_points=GR.now_day-b.char_table.achieves[13]
			end
			return a_points < b_points
		end,
	},	
}

function GeekRate_SortCriteria(i)
	if not(GeekRateDB.sortvar) then
		GeekRateDB.sortvar = {i,1}
		return
	end
	if GeekRateDB.sortvar[1] == i then
		if GeekRateDB.sortvar[2] == 1 then
			GeekRateDB.sortvar[2] = 2
		else
			GeekRateDB.sortvar[2] = 1
		end
	else
		GeekRateDB.sortvar = {i,1}	
	end
	GR.ShowList()
end

function GeekRate_Sort(sorting_table, sort_var)
	local button_table={
		"GeekRateListFrameSort_L",
		"GeekRateListFrameSort_C",
		"GeekRateListFrameSort_C2",
		"GeekRateListFrameSort_R",
	}
	
	for i=1 , #button_table do
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
	end
	
	local s_table = {}
	for name, char_table in pairs(sorting_table) do
		if GR.faction_filter == char_table.faction or GR.faction_filter == "Both" then
			if string.lower(name):find(GR.filter) then
				tinsert(s_table, {name=name, char_table=char_table})
			end
		end
	end
	table.sort(s_table, sort_variants[sort_var[1]][sort_var[2]])
	return s_table
end




GR.MaxFrames = 0

GR.AddItem = function(i, parent)
	local height = 16
	GR.MaxFrames = GR.MaxFrames + 1
	local f = CreateFrame("Button", parent:GetName().."Line"..i, parent, parent:GetName().."TextButtonTemplate")
	if i>1 then
		f:SetPoint("TOPLEFT", getglobal(parent:GetName().."Line"..(i-1)), "BOTTOMLEFT", 0, 0)
		f:SetPoint("BOTTOMRIGHT", getglobal(parent:GetName().."Line"..(i-1)), "BOTTOMRIGHT", 0, -height)
	else
		f:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -height*(i-1))
		f:SetPoint("BOTTOMRIGHT", parent, "TOPRIGHT", 0, -height*(i-1)-height)
	end	
end

function GeekRate_funcgetcolor(class)
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

function GeekRate_ShowTooltip(self, name)

	local char_table = GeekRateDB.db[GR.realm][name]
	
	if not char_table then return end
	if not char_table.achieves then return end
	if not char_table.achieves[13] then return end
	if not char_table.achieveshrono then return end
	
	local s_start, s_end = char_table.achieves[13], GR.now_day
	local countdays = s_end - s_start
	local plus = 0
	if countdays > 400 then
		plus = 10
	end
	GR.tooltipframe = CreateFrame("Frame", "GeekRateTooltipFrame", UIParent, "GameTooltipTemplate")
	GR.tooltipframe:SetFrameStrata("TOOLTIP")
	GR.tooltipframe:SetSize(320, 53+plus)
	GR.tooltipframe:SetPoint("BOTTOMLEFT",self,"TOPLEFT",0,0)
	GR.tooltipframe:Show()
	
	local pos_start, pos_len, pos_height, pos_top = 10, 300, 20, -10-plus
	local weight = pos_len/countdays
	
	for lastdays, count  in pairs(char_table.achieveshrono) do
		local cur = lastdays - s_start
		local pos = weight * cur
		local texture = GR.tooltipframe:CreateTexture()
		local alpha = 0.3*count
		if alpha > 1 then 
			alpha =1 
		end
		texture:SetTexture(0, 1, 0, alpha)
		texture:SetBlendMode("ADD")
		texture:SetPoint("TOPLEFT", GR.tooltipframe, "TOPLEFT", pos_start+pos, pos_top)
		texture:SetPoint("BOTTOMRIGHT", GR.tooltipframe, "TOPLEFT", pos_start+weight+pos, pos_top-pos_height)
		texture:Show()
	end
	
	for i=1, 2 do
		local pos = pos_len
		
		if i == 1 then
			pos = 0
		end
		local weight = 3
		local texture = GR.tooltipframe:CreateTexture()
		texture:SetTexture(1, 0, 0, 1)
		texture:SetBlendMode("DISABLE")
		texture:SetPoint("TOPLEFT", GR.tooltipframe, "TOPLEFT", pos_start+pos, pos_top-(pos_height/2))
		texture:SetPoint("BOTTOMRIGHT", GR.tooltipframe, "TOPLEFT", pos_start+weight+pos, pos_top-pos_height)
		texture:Show()
		
		local my_str = GR.tooltipframe:CreateFontString("GeekRateTooltipString"..i, "ARTWORK", "GameFontNormal")
		my_str:SetTextColor(1, 1, 1, 1)
		if i == 1 then
			my_str:SetText(countdays.." (days ago)")
			my_str:SetPoint("TOPLEFT", texture, "BOTTOMLEFT", 0, -4)
		else
			my_str:SetText("now")
			my_str:SetPoint("TOPRIGHT", texture, "BOTTOMRIGHT", 0, -4)
		end
	end
	if countdays > 400 then
		local cur = countdays - 365
		local pos = weight * cur
		local weight = 3
		local texture = GR.tooltipframe:CreateTexture()
		texture:SetTexture(1, 0, 0, 1)
		texture:SetBlendMode("DISABLE")
		texture:SetPoint("TOPLEFT", GR.tooltipframe, "TOPLEFT", pos_start+pos, pos_top)
		texture:SetPoint("BOTTOMRIGHT", GR.tooltipframe, "TOPLEFT", pos_start+weight+pos, pos_top-pos_height+(pos_height/2))
		texture:Show()
		local my_str = GR.tooltipframe:CreateFontString("GeekRateTooltipString".."1y", "ARTWORK", "GameFontNormal")
		my_str:SetTextColor(1, 1, 1, 1)
		my_str:SetPoint("CENTER", texture, "CENTER", 0, 16)
		my_str:SetText("year ago")
	end
end

GR.ShowList = function()
	GeekRateListFrame:Show()
	local tmplt = "GeekRateListFrameScrollFrameScrollChildTextButtonTemplate"
	local parent = GeekRateListFrameScrollFrameScrollChild
	local listframe = GeekRateListFrame
	
	for i=1, GR.MaxFrames do
		getglobal(parent:GetName().."Line"..i):Hide()
	end
	
	
	local s_table = GeekRate_Sort(GeekRateDB.db[GR.realm], GeekRateDB.sortvar)
	local i = 0
	local max= 50
	if max > #s_table then 
		max = #s_table
	end
	for j=1, max do 

		local name = s_table[j].name
		local char_table = s_table[j].char_table
		i = i + 1
		if i > GR.MaxFrames then
			GR.AddItem(i, parent)
		end
		getglobal(parent:GetName().."Line"..i.."F"):SetText("")	
		if char_table.faction then
			getglobal(parent:GetName().."Line"..i.."F"):SetText("\("..string.sub(char_table.faction,1,1).."\)")
		end
		getglobal(parent:GetName().."Line"..i.."C"):SetText("")		
		if char_table.lifetimeHK then
			local red = char_table.lifetimeHK/15000
			if red > 1 then red = 1 end
			local color = string.format("|cff%02x%02x%02x",red*255,(1-(math.sqrt(red*(red-0.5))))*255,(1-red)*255)
			local text = color..char_table.lifetimeHK
			getglobal(parent:GetName().."Line"..i.."C"):SetText(text)
		end
		
		getglobal(parent:GetName().."Line"..i.."C2"):SetText("")
		if char_table.AchievePoints then
			local red = char_table.AchievePoints/7000
			if red > 1 then red = 1 end
			local color = string.format("|cff%02x%02x%02x",red*255,(1-(math.sqrt(red*(red-0.5))))*255,(1-red)*255)
			local text = color..char_table.AchievePoints
			getglobal(parent:GetName().."Line"..i.."C2"):SetText(text)
		end
	
	
		getglobal(parent:GetName().."Line"..i.."R"):SetText("")
		if char_table.achieves[13] then
				local days = GR.now_day - char_table.achieves[13]
				
				local years = floor((days*10)/355.5)
				local lastdays = floor(days - years*355.5)
				local red = days/650
				if red > 1 then red = 1 end
				local color = string.format("|cff%02x%02x%02x",red*255,(1-(math.sqrt(red*(red-0.5))))*255,(1-red)*255)
				local text = color.."%s days"
				if days > 355.5 then
					text = color.."%s days (%s years)"
					text = string.format(text,tostring(days), tostring(years/10))
				else
					text = string.format(text,tostring(days))
				end
				
				getglobal(parent:GetName().."Line"..i.."R"):SetText(text)
		end
		
		local color = "|cff"..GeekRate_funcgetcolor(char_table.class)
		getglobal(parent:GetName().."Line"..i.."L"):SetText(color..name)
		
		getglobal(parent:GetName().."Line"..i):SetScript("OnEnter", function(this)
			GeekRate_ShowTooltip(this, name)
		end)
		getglobal(parent:GetName().."Line"..i):SetScript("OnLeave", function(this)
			if GR.tooltipframe then
				GR.tooltipframe:Hide()
				GR.tooltipframe=nil
				GeekRateTooltipFrame=nil
			end
		end)		
		
		getglobal(parent:GetName().."Line"..i):Show()
	end
end

GeekRate_HideList = function()
	GeekRateListFrame:Hide()
end

function GeekRate_NEWSort(sorting_table)
	local s_table = {}
	for class, count in pairs(sorting_table) do
		tinsert(s_table, {class=class, count=count})
	end
	table.sort(s_table, function(a, b) return a.count > b.count end)
	return s_table
end

GR.Calc = function()

	local c_table = {};
	
	local max = 0
	for name, char_table in pairs(GeekRateDB.db[GR.realm]) do
		local class = char_table.class
		if(class) then
			if not c_table[class] then
				c_table[class] = 0
			end
			c_table[class] = c_table[class] + 1
			max = max + 1
		end
	end
	
	c_table = GeekRate_NEWSort(c_table)
	
	local msg = "Распределение классов на выборке из "..max.." случайных игроков:"
	SendChatMessage(msg, "CHANNEL", nil, 6)
	--print(msg)
	
	local i=0
	local timer = CreateFrame("Frame")
	timer.elapsed = 0
	timer.tick = 0.5
	timer.func = function()
		local msg = (floor((c_table[i].count/max)*1000)/10).."% - для класса: "..c_table[i].class
		SendChatMessage(msg, "CHANNEL", nil, 6)
	end
	timer:SetScript("OnUpdate", function(this, elapsed)
		this.elapsed = this.elapsed + elapsed
		if this.elapsed > this.tick then
			this.elapsed = 0
			i=i+1
			this.func()
			if i == 10 then this:SetScript("OnUpdate", nil) end
		end
	end)

end;


GR.OnLoad = function()
	if type(GeekRateDB) ~= 'table' then
		GeekRateDB = {}
	end
	if type(GeekRateDB.db) ~= 'table' then
		GeekRateDB.db = {}
	end
	
	GR.realm = GetRealmName()
	
	if type(GeekRateDB.Achieves) ~= 'table' then
		GeekRateDB.Achieves = {13}
	end
	
	if not(GeekRateDB.HonorKills) then
		GeekRateDB.HonorKills = 1
	end	
	if not(GeekRateDB.AchievePoints) then
		GeekRateDB.AchievePoints = 1
	end	
	if not(GeekRateDB.Profs) then
		GeekRateDB.Profs = 1
	end		
	if not(GeekRateDB.sortvar) then
		GeekRateDB.sortvar = {1,1}
	end
	
		-- slash command
	SLASH_GeekRate1 = "/GeekRate";
	SLASH_GeekRate2 = "/gr";
	SlashCmdList["GeekRate"] = function (msg)
		local x, y = msg:find(" ")
		local arg1, arg2
		if x and y then
			arg1 = strsub(msg, 1, x-1)
			arg2 = strsub(msg, y+1, strlen(msg))
		else
			arg1 = msg
		end
		local color = "|cff66ff66"
		if msg:find("list_open") then
			GR.ShowList()
		elseif msg:find("achieve_add") then
			if arg2 then
				local _, id, GUID = strsplit(":", arg2)
				if id then
					id = tonumber(id)
					tinsert(GeekRateDB.Achieves, id)
					print(GetAchievementLink(id)..color.." was added")
				end
			end
		elseif msg:find("achieve_del") then
			if arg2 then
				local i = tonumber(arg2)
				print(GetAchievementLink(GeekRateDB.Achieves[i])..color.." was removed")
				tremove(GeekRateDB.Achieves, i)
			end
		elseif msg:find("achieve_list") then
			print(color.."GeekRate Achives:")
			for i=1, #GeekRateDB.Achieves do
				local achievementID = GeekRateDB.Achieves[i]	
				print(color..i..". "..GetAchievementLink(achievementID))
			end
		elseif msg:find("honorkills_toggle") then
			GeekRateDB.HonorKills = GeekRateDB.HonorKills * -1
			if GeekRateDB.HonorKills == 1 then
				print(color.."GeekRate HonorKills: enabled")
			else
				print(color.."GeekRate HonorKills: disabled")
			end
		elseif msg:find("achievepoints_toggle") then
			GeekRateDB.AchievePoints = GeekRateDB.AchievePoints * -1
			if GeekRateDB.AchievePoints == 1 then
				print(color.."GeekRate HonorKills: enabled")
			else
				print(color.."GeekRate HonorKills: disabled")
			end
		elseif msg:find("professions_toggle") then
			GeekRateDB.Profs = GeekRateDB.Profs * -1
			if GeekRateDB.Profs == 1 then
				print(color.."GeekRate Profs Num: enabled")
			else
				print(color.."GeekRate Profs Num: disabled")
			end
		elseif msg:find("calc_class") then
			GR.Calc_class()
		elseif msg:find("calc_3s") then
			GR.Calc_3s()
		elseif msg:find("database_clear") then
			GeekRateDB.db = {}
			ReloadUI()
		else
			print(color.."incorrect syntax")
			print(color.."/gr list_open")
			print(color.."/gr achieve_add %achievelink%")
			print(color.."/gr achieve_del %n%")
			print(color.."/gr achieve_list")
			print(color.."/gr honorkills_toggle")
			print(color.."/gr achievepoints_toggle")
			print(color.."/gr database_clear")
		end		
	end
	GeekRateListFrameScrollFrameScrollChild:SetWidth(GeekRateListFrame:GetWidth()-55)
end
