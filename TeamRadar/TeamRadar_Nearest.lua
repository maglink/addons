local AddonName, _ = ...;
local TR = _G[AddonName];

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