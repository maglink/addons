local AddonName, _ = ...;
local TR = _G[AddonName];

TR.SendInfo = {}
TR.SendInfo.Timer = TR.Time:Timer()
TR.SendInfo.Init = function(self)
	
	local Stack = {}
	
	self.msgack = false
	local timeout = 30
	local timeoutleft = timeout
	
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

	self.Unit = function(unitId)
	
		if not UnitInBattleground("player") then
			return
		end
		
		if UnitIsPlayer(unitId) and UnitIsEnemy("player",unitId) then
			local playerName = UnitName(unitId)
			local localizedClass, englishClass, classIndex = UnitClass(unitId);
			local health, healthmax = UnitHealth(unitId), UnitHealthMax(unitId);

			self.UpdateEnemyPlayer(playerName, englishClass, health, healthmax)
		end
	end
	
	self.Timer.tick = 2
	self.Timer.func = function()
		if not UnitInBattleground("player") then
			Stack = {}
			return
		end

		if not self.msgack then
			timeoutleft = timeoutleft - self.Timer.tick
			if timeoutleft <= 0 then
				self.msgack = true
			end
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
			self.msgack = false
			timeoutleft = timeout
			SendAddonMessage(AddonName, msg, "BATTLEGROUND")
			Stack = {}
		else
			self.Unit("focus")
			self.Unit("target")
		end
		
	end
	self.Timer:Start()
	
end;
