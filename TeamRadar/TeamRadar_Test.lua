local AddonName, _ = ...;
local TR = _G[AddonName];

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