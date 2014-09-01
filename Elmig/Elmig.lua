local OnLoad = function()
	
	if type(ElmigDB) ~= 'table' then
		ElmigDB = {}
	end
	
	if ElmigDB.flag == nil then
		ElmigDB.flag = 1
	end
	
	-- slash command
	SLASH_Elmig1 = "/Elmig";
	SlashCmdList["Elmig"] = function (msg)
		local color = "|cff66ff66"
		if msg:find("sound") then
			ElmigDB.flag = ElmigDB.flag * -1
			if ElmigDB.flag == 1 then
				print(color.."Elmig Sound: enabled")
			else
				print(color.."Elmig Sound: disabled")
			end
		else
			print(color.."incorrect syntax")
			print(color.."/elmig sound")
		end
	end

end

local Event = CreateFrame("Frame")
Event:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
Event:SetScript("OnEvent", function(...)
local tbl = {}
tbl.self, tbl.fevent,  tbl.timestamp, tbl.event, tbl.sourceGUID, tbl.sourceName, tbl.sourceFlags, 
tbl.destGUID, tbl.destName, tbl.destFlags, tbl.spellID, tbl.spellName = ...;
	if "SPELL_AURA_APPLIED" == tbl.event then
		if 69369 == tbl.spellID then
			if tbl.destName == UnitName("player") then
				if ElmigDB.flag == 1 then PlaySoundFile("Sound\\Interface\\PlayerInviteA.wav") end
				RaidNotice_AddMessage(RaidWarningFrame, "Быстрота хищника", ChatTypeInfo["TRADESKILLS"], 8)
			end
		end
	end
	if "SPELL_AURA_REMOVED" == tbl.event then
		if 69369 == tbl.spellID then
			if tbl.destName == UnitName("player") then
				RaidNotice_AddMessage(RaidWarningFrame, "", ChatTypeInfo["TRADESKILLS"])
				RaidNotice_AddMessage(RaidWarningFrame, "", ChatTypeInfo["TRADESKILLS"])
			end
		end
	end	
end)

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function() OnLoad()	end)

