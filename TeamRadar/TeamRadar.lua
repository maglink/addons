local AddonName, TR = ...;

TR = {}
TR.Main = {}

TR.Main.OnLoadEvent = CreateFrame("Frame")
TR.Main.OnLoadEvent:RegisterEvent("ADDON_LOADED")
TR.Main.OnLoadEvent:SetScript("OnEvent", function(self, event, name)
	if name == AddonName then
		self:UnregisterEvent(event);
		TR.Main.OnLoad()
	end
end)

TR.Main.LoadEventHandlers = function()

	TR.Main.CommunicateEvent = CreateFrame("Frame")
	TR.Main.CommunicateEvent:RegisterEvent("CHAT_MSG_ADDON")
	TR.Main.CommunicateEvent:SetScript("OnEvent", function(self, event, prefix, msg, brType, sender)
		if TR.Shield.IsBanPlayer(sender) then
			return
		end
		if prefix == AddonName then
			TR.Main.InsideMessage(msg, brType, sender)
		end
	end)

	TR.Main.InfoIvent = CreateFrame("Frame")
	TR.Main.InfoIvent:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	TR.Main.InfoIvent:RegisterEvent("PLAYER_TARGET_CHANGED")
	TR.Main.InfoIvent:RegisterEvent("PLAYER_FOCUS_CHANGED")
	TR.Main.InfoIvent:SetScript("OnEvent", function(self, event)
		if not UnitInBattleground("player") then
			return
		end
		local unitId = ""
		if event == "PLAYER_TARGET_CHANGED" then
			unitId = "target"
		elseif event == "PLAYER_FOCUS_CHANGED" then
			unitId = "focus"
		elseif event == "UPDATE_MOUSEOVER_UNIT" then 
			unitId = "mouseover"
		end

		TR.Main.SendUnitInfo(unitId)
		
	end)

	-- TR.Main.HassleEvent = CreateFrame("Frame")
	-- TR.Main.HassleEvent:RegisterEvent("PLAYER_CONTROL_LOST")
	-- TR.Main.HassleEvent:RegisterEvent("PLAYER_REGEN_DISABLED")
	-- TR.Main.HassleEvent:SetScript("OnEvent", function(self, event)
		-- if not UnitInBattleground("player") then
			-- return
		-- end

		-- TR.SendInfo.SendHassleEvent(event)
		-- UnitInRaid("unit") 
		
	-- end)
	
end
	
TR.Main.OnLoad = function()

	-- RegisterAddonMessagePrefix(AddonName)
	
	TR.CheckTable("TeamRadarDB")
	TR.CheckTable("TeamRadarDB#Version")
	TR.CheckTable("TeamRadarDB#Version#NewVersion")
	TR.CheckTable("TeamRadarDB#Version#OldVersion")

	TR.Notice:Init()
	TR.Version:Init(1000)
	TR.Nearest:Init()
	TR.SendInfo:Init()
	TR.Shield:Init()
	TR.Map:Init()
	-- TR.Test:Init()

	TR.Main.LoadEventHandlers()

end

TR.Split = function(str, delim, maxNb)
    -- Eliminate bad cases...
    if string.find(str, delim) == nil then
        return { str }
    end
    if maxNb == nil or maxNb < 1 then
        maxNb = 0    -- No limit
    end
    local result = {}
    local pat = "(.-)" .. delim .. "()"
    local nb = 0
    local lastPos
    for part, pos in string.gmatch(str, pat) do
        nb = nb + 1
        result[nb] = part
        lastPos = pos
        if nb == maxNb then break end
    end
    -- Handle the last field
    if nb ~= maxNb then
        result[nb + 1] = string.sub(str, lastPos)
    end
    return result
end

TR.Main.InsideMessage = function(msg, brType, sender)
	
	local arrMsg = TR.Split(msg, "#", 3)
	local TRVersion = tonumber(arrMsg[1] or "0")
	local typeMsg = arrMsg[2]
	local newmsg = arrMsg[3]
	
	
	if brType == "BATTLEGROUND" and typeMsg == "EPI" then
		local arrEnemies = TR.Split(newmsg, "#")
		for i = 1, #arrEnemies do
			local arrInfo = TR.Split(arrEnemies[i], ",")
			local EnemyName = arrInfo[1]
			TR.Map.EnemyTable[EnemyName] = {
				senderInfo = sender,
				lastUpdate = time(),
				class = arrInfo[2],
				health = tonumber(arrInfo[3]),
				healthMax = tonumber(arrInfo[4]),
				posX = TR.Map.GetRandomDeviation(tonumber(arrInfo[5])),
				posY = TR.Map.GetRandomDeviation(tonumber(arrInfo[6])),
			}
			TR.Shield.AddInfo(sender, EnemyName)
		end
		TR.Map.Update()
	end

	TR.Version.Check(TRVersion, sender)

end

TR.CheckTable = function(strT)

	local T = TR.Split(strT, "#")

	if not type(T) == "table" or T == nil or #T == 0 then
		return
	end	
	
	local thisT = {}
	
	for i=1, #T do
		local Tname = T[i]
		if i==1 then
			if not type(_G[Tname]) == "table" or _G[Tname] == nil then
				_G[Tname] = {}
			end	
			thisT = _G[Tname]
		else
			if not type(thisT[Tname]) == "table" or thisT[Tname] == nil then
				thisT[Tname] = {}
			end	
			thisT = thisT[Tname]
		end
	end

end

TR.Main.SendUnitInfo = function(unitId)
	if UnitIsPlayer(unitId) and UnitIsEnemy("player",unitId) then
		local playerName = UnitName(unitId)
		local localizedClass, englishClass, classIndex = UnitClass(unitId);
		local health, healthmax = UnitHealth(unitId), UnitHealthMax(unitId);
		
		TR.SendInfo.UpdateEnemyPlayer(playerName, englishClass, health, healthmax)
	end
end

--------------------------------------------------------------------------
TR.Time = {}
TR.Time.Tick = 0.2
TR.Time.Timer = function(self)
	local timer = CreateFrame("Frame")
	timer.tick = self.Tick
	timer.func = function()	end
	timer.Start = function(self)
		self.elapsed = 0
		self:SetScript("OnUpdate", function(this, elapsed)
			this.elapsed = this.elapsed + elapsed
			if this.elapsed > this.tick then
				this.elapsed = 0
				this.func()
			end
		end)
	end
	timer.Stop = function(self)	
		self:SetScript("OnUpdate", nil)
	end
	return timer
end

-------------------------------------------------------------------

TR.Notice = {}
TR.Notice.Init = function(self)
	
	local AddonNoticePrefix = string.format("|cffffaa00[|cff22ff22%s|cffffaa00]|r", AddonName)
	
	local TypeColors = {
		normal = "|cff22ff22",
		warning = "|cffffaa00",
		critical_error = "|cffff0000",
	}
	
	self.Send = function(msg, mtype)
		local msgColor = TypeColors[mtype or "normal"] or ""
		print(AddonNoticePrefix..msgColor..msg)
	end
	
end;

-------------------------------------------------------------------

TR.Version = {}
TR.Version.Init = function(self, number)
	
	local maxCountOfVersion = 3
	
	self.Number = number
	
	local function tablelength(T)
	  local count = 0
	  for _ in pairs(T) do count = count + 1 end
	  return count
	end
	
	self.Check = function(ver, sender)
		if self.IsOldVersion() then return end
		if type(ver) == "number" then
			if ver > self.Number then
			
				TR.CheckTable("TeamRadarDB#Version#NewVersion#"..ver)
				local thisVerTable = TeamRadarDB.Version.NewVersion[ver]
				
				thisVerTable[sender] = 1
				
				if tablelength(thisVerTable) >= maxCountOfVersion then
					TeamRadarDB.Version.OldVersion[self.Number] = 1
					self.OldVersionNotice()
				end
				
			end
		end
	end

	self.IsOldVersion = function()
		if TeamRadarDB.Version.OldVersion[self.Number] then
			return 1
		end	
	end
	
	self.OldVersionNotice = function()
		TR.Notice.Send("Clients were found with later versions of this addon. Your version of the addon is outdated.", "warning")
	end
	
	if self.IsOldVersion() then
		self.OldVersionNotice()
	end	

end;
	
------------------------------------------------------------

TR.Map = {}
TR.Map.Timer = TR.Time:Timer()
TR.Map.Init = function(self)

	local DeleteTime = 20

	self.EnemyTable = {}
	self.PointCount = 0
	
	self.Timer.tick = 1
	self.Timer.func = function()
		for key, value in pairs(self.EnemyTable) do
			local lastUpdate = self.EnemyTable[key].lastUpdate
			if time() - lastUpdate > DeleteTime then
				self.EnemyTable[key] = nil
				self.Update()
			end
		end
	end
	self.Timer:Start()
	
	local TRShowMapToolTip = function(frame)
	
		local centerX, centerY = frame:GetParent():GetCenter()
		local x, y = frame:GetCenter()
		local Anchor1 = "TOP"
		local Anchor2 = "LEFT"
		if x < centerX then	Anchor2 = "RIGHT" end
		if y > centerY then	Anchor1 = "BOTTOM" end

		WorldMapTooltip:SetOwner(frame, "ANCHOR_"..Anchor1..Anchor2)
		
		local tooltipText = ""
		local newLineString = "";
		local enemyCount = 0
		
		for k = 1, self.PointCount do
			local pointFrame = _G["TeamRadar_EnemyPoint_"..k]
			if pointFrame:IsVisible() and pointFrame:IsMouseOver(2, -2, -2, 2) then
			
				enemyCount = enemyCount + 1
				
				local class = _G.RAID_CLASS_COLORS[pointFrame.arrInfo.class] or {r=0.63,g=0.63,b=0.63}
				local classColor = string.format("%02x%02x%02x",class.r*255,class.g*255,class.b*255)
				
				local hPercent = floor((pointFrame.arrInfo.health/pointFrame.arrInfo.healthMax)*100)
				local hPercentColor = string.format("%02x%02x%02x",((100-hPercent)/100)*255,(hPercent/100)*255,0.1*255)
				
				tooltipText = string.format("%s%s|cff%s%s|r [|cff%s%s%%|rHP]", 
				tooltipText, 
				newLineString,
				classColor,
				pointFrame.aboutName,	
				hPercentColor,			
				hPercent)
				newLineString = "\n";
			end
		end		
		
		tooltipText = string.format("%s\n\n|rTotal enemies: %s", tooltipText, enemyCount)

		WorldMapTooltip:SetText(tooltipText);
		WorldMapTooltip:Show()
		
	end
		
	self.CreateEnemyPointFrame = function(i)

		local myframe = CreateFrame("Frame", "TeamRadar_EnemyPoint_"..i, WorldMapButton)
		myframe:SetSize(16, 16)
		myframe:SetFrameLevel(myframe:GetFrameLevel()+1);
		myframe:EnableMouse(true)

		myframe.texture = myframe:CreateTexture()
		myframe.texture:SetTexture("Interface\\RAIDFRAME\\UI-RaidFrame-Threat");
		myframe.texture:SetBlendMode("BLEND")
		myframe.texture:SetAllPoints()
		
		myframe.pingTexture = myframe:CreateTexture()
		myframe.pingTexture:SetTexture("Interface\\BUTTONS\\IconBorder-GlowRing");
		myframe.pingTexture:SetBlendMode("ADD")
		myframe.pingTexture:SetPoint("CENTER", myframe, "CENTER", 0,0)		
		myframe.pingTexture:SetVertexColor(1.0, 0, 0, 1.0)
		myframe.pingTexture:Hide()
		
		myframe.ping = {}
		
		myframe.ping.AnimTimer = TR.Time:Timer()
		myframe.ping.AnimTimer.tick = 0.05
		myframe.ping.AnimTimer.func = function()
			local width = myframe.pingTexture:GetWidth()
			if width > 10 then
				myframe.pingTexture:SetSize(width*0.75, width*0.75)
			else
				myframe.ping.AnimTimer:Stop()
				myframe.pingTexture:Hide()
			end
		end
		
		myframe.ping.timerWait = TR.Time:Timer()
		myframe.ping.timerWait.func = function()
			myframe.ping.timerWait:Stop()
			
			myframe.pingTexture:SetSize(1500, 1500)
			myframe.pingTexture:Show()
			myframe.ping.AnimTimer:Start()
		end
		
		myframe.ping.StartWithRandomWait = function()
			myframe.ping.timerWait.tick = math.random() * 0.5
			myframe.ping.timerWait:Start()
		end

	end
	
	self.StylizeEnemyPointFrame = function(pointFrame, arrInfo, aboutName)
		
		local posX = WorldMapDetailFrame:GetWidth() * arrInfo.posX
		local posY = WorldMapDetailFrame:GetHeight() * arrInfo.posY * -1

		pointFrame:SetPoint("CENTER", "WorldMapDetailFrame", "TOPLEFT", posX, posY)

		local classColor = RAID_CLASS_COLORS[arrInfo.class] or {r=0.63,g=0.63,b=0.63}
		pointFrame.texture:SetVertexColor(classColor.r, classColor.g, classColor.b, 1.0)	
		
		
		pointFrame.arrInfo=arrInfo
		pointFrame.aboutName=aboutName
		
		pointFrame:SetScript("OnEnter", function(frame) 
			WorldMapPOIFrame.allowBlobTooltip = false;
			TRShowMapToolTip(frame) 
		end)

		pointFrame:SetScript("OnLeave", function() 
			WorldMapPOIFrame.allowBlobTooltip = true;
			WorldMapTooltip:Hide()
		end)
		
	end
	
	self.Update = function()
		local i = 1
		for key, value in pairs(self.EnemyTable) do
			if i > self.PointCount then
				self.CreateEnemyPointFrame(i)
				self.PointCount = i
			end
			
			local pointFrame = _G["TeamRadar_EnemyPoint_"..i]
			self.StylizeEnemyPointFrame(pointFrame, self.EnemyTable[key], key)
			
			pointFrame:Show()
			
			i = i + 1
		end
		if i <= self.PointCount then
			for k = i, self.PointCount do
				local pointFrame = _G["TeamRadar_EnemyPoint_"..k]
				pointFrame:Hide()
			end
		end
	end

	hooksecurefunc("WorldMapFrame_PingPlayerPosition", function()
		for k = 1, self.PointCount do
			local pointFrame = _G["TeamRadar_EnemyPoint_"..k]
			if pointFrame:IsVisible() then
				pointFrame.ping.StartWithRandomWait()
			end
		end		
	end)
	
	self.GetRandomDeviation = function(number)
		local devAmplitude = 0.005
		return number + (-devAmplitude + math.random() * (devAmplitude*2))
	end
	
end;

--------------------------------------------------------------------------


TR.Nearest = {}
TR.Nearest.Timer = TR.Time:Timer()
TR.Nearest.Init = function(self)

	local ClassReference = {}		
	local ColorToString = function (r,g,b) return "C"..math.floor((100*r) + 0.5)..math.floor((100*g) + 0.5)..math.floor((100*b) + 0.5) end
	for classname, color in pairs(RAID_CLASS_COLORS) do 
		ClassReference[ColorToString(color.r, color.g, color.b)] = classname end	

	local function GetUnitReaction(red, green, blue)
		if red < .01 and blue < .01 and green > .99 then return "FRIENDLY", "NPC" 
		elseif red < .01 and blue > .99 and green < .01 then return "FRIENDLY", "PLAYER"
		elseif red > .99 and blue < .01 and green > .99 then return "NEUTRAL", "NPC"
		elseif red > .99 and blue < .01 and green < .01 then return "HOSTILE", "NPC"
		else return "HOSTILE", "PLAYER" end
	end
		
	local function PlateUpdate(plate)
		self.List[plate] = true

		plate.unit = {}
		local unit = plate.unit
		
		unit.regions, unit.bars, unit.visual = {}, {}, {}
		local regions = unit.regions
		local bars = unit.bars
	
		bars.health, bars.cast = plate:GetChildren()
		regions.threatglow, regions.healthborder, regions.castborder, regions.castnostop,
		regions.spellicon, regions.highlight, regions.name, regions.level,
		regions.dangerskull, regions.raidicon, regions.eliteicon = plate:GetRegions()
		
		
		unit.red, unit.green, unit.blue = bars.health:GetStatusBarColor()
		unit.reaction, unit.type = GetUnitReaction(unit.red, unit.green, unit.blue)
		unit.class = ClassReference[ColorToString(unit.red, unit.green, unit.blue)] or "UNKNOWN"
		unit.health = bars.health:GetValue() or 0
		_, unit.healthmax = bars.health:GetMinMaxValues()
		
		if unit.reaction == "HOSTILE" and unit.type == "PLAYER" then
			local playerName = regions.name:GetText()
			TR.SendInfo.UpdateEnemyPlayer(playerName, unit.class, unit.health, unit.healthmax)
		end
		
	end
		
	local function GeneratePlate(plate)
		self.Plates[plate] = true
		self.List[plate] = true
		PlateUpdate(plate)
		plate:HookScript("OnShow", function() PlateUpdate(plate) end)
		plate:HookScript("OnHide", function() 
			self.List[plate] = nil
		end)
		plate:SetFrameStrata("TOOLTIP")
	end
	
	local function IsFrameNameplate(frame)
		local region = frame:GetRegions()
		return region and region:GetObjectType() == "Texture" and region:GetTexture() == "Interface\\TargetingFrame\\UI-TargetingFrame-Flash" 
	end
	
	local function OnWorldFrameChange()
		for key, plate in pairs({WorldFrame:GetChildren()}) do
			if not self.Plates[plate] and IsFrameNameplate(plate) then
				GeneratePlate(plate)
			end
		end
	end

	self.count = -1
	self.Plates = {}
	self.List = {}
	self.Target = nil
	
	self.Timer.tick = 0.5
	self.Timer.func = function()
		if not UnitInBattleground("player") then
			return
		end
		curCount = WorldFrame:GetNumChildren()
		if (curCount ~= self.count) then
			self.count = curCount
			OnWorldFrameChange() 
		end
	end
	self.Timer:Start()

end;
	
-------------------------------------------------------------------
	
TR.SendInfo = {}
TR.SendInfo.Timer = TR.Time:Timer()
TR.SendInfo.Init = function(self)
	
	local Stack = {}
	
	local function round(num, idp)
		return tonumber(string.format("%." .. (idp or 0) .. "f", num))
	end
		
	self.UpdateEnemyPlayer = function(playerName, englishClass, health, healthmax)
		local posX, posY = GetPlayerMapPosition("player");
		posX = round(posX, 3)
		posY = round(posY, 3)
		health = round(health/1000, 1)
		healthmax = round(healthmax/1000, 1)
		local msg = string.format("%s,%s,%s,%s,%s", englishClass, health, healthmax, posX, posY)
		Stack[playerName] = msg
	end

	self.Timer.tick = 2
	self.Timer.func = function()
		if not UnitInBattleground("player") then
			return
		end

		local sendFlag = false
		local msg = TR.Version.Number.."#EPI"
		for name, info in pairs(Stack) do
			if strlen(string.format("%s#%s,%s", msg, name, info)) < 255 then
				msg=string.format("%s#%s,%s", msg, name, info)
				sendFlag = true
			else
				break
			end
		end
		
		if sendFlag then
			SendAddonMessage(AddonName, msg, "BATTLEGROUND")
			Stack = {}
		else
			TR.Main.SendUnitInfo("focus")
			TR.Main.SendUnitInfo("target")
		end
		
	end
	self.Timer:Start()
	
end;
	
------------------------------------------------------------
	
TR.Shield = {}
TR.Shield.Timer = TR.Time:Timer()
TR.Shield.Init = function(self)
	
	local Players = {}
	local BanList = {}
	
	local ResetTime = 20
	local MaxInfo = 100
	
	self.IsBanPlayer = function(playerName)
		return BanList[playerName] 
	end
	
	local function tablelength(T)
	  local count = 0
	  for _ in pairs(T) do count = count + 1 end
	  return count
	end
	
	self.AddInfo = function(senderName, aboutName)
	
		TR.CheckTable("Players#"..senderName)
		
		if Players[senderName] == nil or not type(Players[senderName]) == "table" then
			Players[senderName] = {}
		end
		
		Players[senderName][aboutName] = true
		
		if tablelength(Players[senderName]) > MaxInfo then
			BanList[senderName] = true
		end
		
	end
	
	self.Timer.tick = 60*ResetTime
	self.Timer.func = function()
		Players = {}
	end
	self.Timer:Start()
	
end;

-------------------------------------------------------------------

TR.Test = {}
TR.Test.Init = function(self)

	for i = 1, 3 do
		local testPosX = math.random()
		local testPosY = math.random()
		for classname, color in pairs(RAID_CLASS_COLORS) do 
			TR.Map.EnemyTable[classname..i] = {
				senderInfo = "SenderNick",
				lastUpdate = time()+10000,
				class = classname,
				health = math.random() * 20,
				healthMax = 20 + math.random()*15,
				posX = TR.Map.GetRandomDeviation(testPosX),
				posY = TR.Map.GetRandomDeviation(testPosY),
			}
		end	
	end	
	
	TR.Map.Update()
	
end;

