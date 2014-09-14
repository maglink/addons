local AddonName, _ = ...;
local TR = _G[AddonName];

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
	
		TR.CheckTable(senderName, Players)
		
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
