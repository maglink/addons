local AddonName, _ = ...;
_G[AddonName] = {};
local TR = _G[AddonName];

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

		TR.SendInfo.Unit(unitId)
		
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
	TR.UnitName = UnitName("player")
	
	TR.CheckTable("TeamRadarDB")
	TR.CheckTable("TeamRadarDB#Version")
	TR.CheckTable("TeamRadarDB#Version#NewVersion")
	TR.CheckTable("TeamRadarDB#Version#OldVersion")

	TR.Notice:Init()
	TR.Version:Init(1009)
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

TR.CheckTable = function(strT, gT)

	local T = TR.Split(strT, "#")
	if not type(T) == "table" or T == nil or #T == 0 then
		return
	end
	
	local gTable = _G
	if type(gT) == 'table' then
		gTable = gT
	end
	
	local thisT = {}
	for i=1, #T do
		local Tname = T[i]
		if i==1 then
			if not type(gTable[Tname]) == "table" or gTable[Tname] == nil then
				gTable[Tname] = {}
			end	
			thisT = gTable[Tname]
		else
			if not type(thisT[Tname]) == "table" or thisT[Tname] == nil then
				thisT[Tname] = {}
			end	
			thisT = thisT[Tname]
		end
	end

end

TR.Main.InsideMessage = function(msg, brType, sender)
	
	local arrMsg = TR.Split(msg, "#", 3)
	local TRVersion = tonumber(arrMsg[1] or "0")
	local typeMsg = arrMsg[2]
	local newmsg = arrMsg[3]
	
	if sender == TR.UnitName then
		TR.SendInfo.msgack = true
	end
	
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
			
			if TR.Map.EnemyTable[EnemyName].health == 0 then
				TR.Map.EnemyTable[EnemyName].lastUpdate = time() - 10000
			end
			
			TR.Shield.AddInfo(sender, EnemyName)
		end
		TR.Map.Update()
	end

	TR.Version.Check(TRVersion, sender)

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
	
	local AddonNoticePrefix = string.format("|cffffaa00[|cff22ff22%s|cffffaa00]|r ", AddonName)
	
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


