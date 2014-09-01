--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
local updateframe = CreateFrame("Frame")
updateframe:SetScript("OnUpdate", function(self, elapsed)
--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_

FindGroupCharVars.usingtime=FindGroupCharVars.usingtime+elapsed

for i=1, FGL.db.nummsgsmax do
	local timeleftnow2 = 0 
	local timeleftnow = 100
	if FGL.db.lastmsg[i] then
		if not (FGL.db.lastmsg[i][3] == nil) then
			if tonumber(date("%M")) < tonumber(FGL.db.lastmsg[i][3]) then
				timeleftnow2 = (60 + tonumber(date("%M")) - tonumber(FGL.db.lastmsg[i][3])) * 60
			else
				timeleftnow2 = (tonumber(date("%M")) - tonumber(FGL.db.lastmsg[i][3])) * 60
			end
			if timeleftnow2 == 0 then
				timeleftnow2 = tonumber(date("%S")) - tonumber(FGL.db.lastmsg[i][4])
			else
				if tonumber(date("%S")) > tonumber(FGL.db.lastmsg[i][4]) then
					timeleftnow2 = timeleftnow2 + tonumber(date("%S")) - tonumber(FGL.db.lastmsg[i][4])
				else
					timeleftnow2 = timeleftnow2 - tonumber(FGL.db.lastmsg[i][4]) + tonumber(date("%S"))
				end
			end
			FGL.db.lastmsg[i][12] = FGL.db.lastmsg[i][12] + elapsed
			timeleftnow = FGL.db.lastmsg[i][12]
		end
	
		if (FGL.db.linefadesec >= FGL.db.timeleft - timeleftnow) and ((FGL.db.timeleft - timeleftnow)/FGL.db.linefadesec) > 0 then
				local k
				k = i - FindGroupFrameSlider:GetValue()
				for u = 1, #FGL.db.wigets.stringwigets do
					if getglobal(FGL.db.wigets.stringwigets[u]..k) then getglobal(FGL.db.wigets.stringwigets[u]..k):SetAlpha((FGL.db.timeleft - timeleftnow)/FGL.db.linefadesec) end
				end
		end
	
		if (timeleftnow > FGL.db.timeleft ) then
			FindGroup_ClearText(i)
				local k
				k = i - FindGroupFrameSlider:GetValue()
				for u = 1, #FGL.db.wigets.stringwigets do
					if getglobal(FGL.db.wigets.stringwigets[u]..k) then getglobal(FGL.db.wigets.stringwigets[u]..k):SetAlpha(1)  end
				end
		end
	
	end
end

	if FGL.db.configstatus == 1 and  FGL.db.framemove == 1 then
		FindGroup_ShowConfigPanel()
	end

--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
end)
--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_

