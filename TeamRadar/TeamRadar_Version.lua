local AddonName, _ = ...;
local TR = _G[AddonName];

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
	