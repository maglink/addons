local AddonName, _ = ...;
local TR = _G[AddonName];

TR.Map = {}
TR.Map.Timer = TR.Time:Timer()
TR.Map.Init = function(self)

	local DeleteTime = 20

	self.EnemyTable = {}
	self.PointCount = 0
	
	self.Timer.tick = 1
	self.Timer.func = function()
		if not UnitInBattleground("player") then
			self.EnemyTable = {}
			for k = 1, self.PointCount do
				local pointFrame = _G["TeamRadar_EnemyPoint_"..k]
				pointFrame:Hide()
			end	
			return
		end
		for key, enemyInfo in pairs(self.EnemyTable) do
			local lastUpdate = enemyInfo.lastUpdate
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
		for key, enemyInfo in pairs(self.EnemyTable) do
			if i > self.PointCount then
				self.CreateEnemyPointFrame(i)
				self.PointCount = i
			end
			
			local pointFrame = _G["TeamRadar_EnemyPoint_"..i]
			self.StylizeEnemyPointFrame(pointFrame, enemyInfo, key)
			
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