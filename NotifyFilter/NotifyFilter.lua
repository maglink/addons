local NotifyFilter, NF = ...;



NF.Event = CreateFrame("Frame")
NF.Event:RegisterEvent("ADDON_LOADED")
NF.Event:SetScript("OnEvent", function(self, event, msg)
	if event == "ADDON_LOADED" then
		self:UnregisterEvent("ADDON_LOADED")
		self:RegisterEvent("CHAT_MSG_SYSTEM")
		NF.OnLoad()
	end
	if event == "CHAT_MSG_SYSTEM" then
		if NotifyFilterDB.Status == 1 then
			if string.find(msg, "[Анонс Арены]:", nil, true) then
				local x, y = msg:find(" -- ")
				if x then
					local teamname = string.sub(msg,38,x-3)
					local mode = string.sub(msg,y+1,string.len(msg))
					if mode:find("Присоед") then
						tinsert(NF.tbl, 0, {name=teamname, lasttime=time()})
					else
						for i=1, #NF.tbl do
							if NF.tbl[i].name == teamname then
								tremove(NF.tbl, i)
								break
							end
						end
						
					end
					if NotifyFilterListFrame:IsShown() then
						NF.ShowList()
					end
				else
					return
				end
			end
		end
	end
end)

NF.tbl = {}

NF.MaxFrames = 0

NF.AddItem = function(i, parent)
	local height = 16
	NF.MaxFrames = NF.MaxFrames + 1
	local f = CreateFrame("Button", parent:GetName().."Line"..i, parent, parent:GetName().."TextButtonTemplate")
	if i>1 then
		f:SetPoint("TOPLEFT", getglobal(parent:GetName().."Line"..(i-1)), "BOTTOMLEFT", 0, 0)
		f:SetPoint("BOTTOMRIGHT", getglobal(parent:GetName().."Line"..(i-1)), "BOTTOMRIGHT", 0, -height)
	else
		f:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -height*(i-1))
		f:SetPoint("BOTTOMRIGHT", parent, "TOPRIGHT", 0, -height*(i-1)-height)
	end	
end

NF.ShowList = function()
	NotifyFilterListFrame:Show()

	local tmplt = "NotifyFilterListFrameScrollFrameScrollChildTextButtonTemplate"
	local parent = NotifyFilterListFrameScrollFrameScrollChild
	local listframe = NotifyFilterListFrame
	
	for i=1, NF.MaxFrames do
		getglobal(parent:GetName().."Line"..i):Hide()
	end
	
	local s_table = NF.tbl
	local max= 50
	if max > #s_table then 
		max = #s_table
	end
	for i=1, max do
		
		
	
		if i > NF.MaxFrames then
			NF.AddItem(i, parent)
		end
		if i == 50 then
			getglobal(parent:GetName().."Line"..i.."L"):SetText("<and more>")
			getglobal(parent:GetName().."Line"..i.."R"):SetText("...")
		else
			local name = s_table[i].name
			local seconds = time() - s_table[i].lasttime
			local min = floor(seconds/60)
			local sec = seconds - min*60
			local timetext = string.format("%dm %ds",min,sec)
			
			getglobal(parent:GetName().."Line"..i.."L"):SetText(name)
			getglobal(parent:GetName().."Line"..i.."R"):SetText(timetext)
		end
		getglobal(parent:GetName().."Line"..i):Show()
	end
end

NotifyFilter_HideList = function()
	NotifyFilterListFrame:Hide()
	NotifyFilterDB.WindowStatus = false
end

NF.myChatFilter = function(self, event, msg, author, ...)
	if NotifyFilterDB.Status == 1 then
		if string.find(msg, "[Анонс Арены]:", nil, true) then
			return true
		end
	end	
end

function print_progress(percent, add_text)
	local max = 19
	local min = 0
	local now = max*percent
	local str_print = "["
	for i=min, max do
		if i<now then
			str_print = str_print .. "/"
		else
			str_print = str_print .. "_"
		end
	end
	str_print = str_print.."]"
	print(add_text..str_print)
end

NF.OnLoad = function()

	if type(NotifyFilterDB) ~= 'table' then
		NotifyFilterDB = {}
	end
	
	if NotifyFilterDB.Status == nil then
		NotifyFilterDB.Status = 1
	end
	
	if NotifyFilterDB.WindowStatus == nil then
		NotifyFilterDB.WindowStatus = true
	end

		-- slash command
	SLASH_NotifyFilter1 = "/NotifyFilter";
	SLASH_NotifyFilter2 = "/nf";
	SlashCmdList["NotifyFilter"] = function (msg)
		local color = "|cff66ff66"
		if msg:find("toggle") then
			NotifyFilterDB.Status = NotifyFilterDB.Status * -1
			if NotifyFilterDB.Status == 1 then
				print(color.."NotifyFilter Arena: enabled")
			else
				NF.tbl = {}
				print(color.."NotifyFilter Arena: disabled")
			end
		elseif msg:find("list") then
			NF.ShowList()
			NotifyFilterDB.WindowStatus = true
		elseif msg:find("print") then
			print("-------")
			for name, tbl in pairs(NotifyFilterDB.newtbl_5) do
				print(name, tbl[1], tbl[2])
			end
		else
			print(color.."incorrect syntax")
			print(color.."/nf list")
			print(color.."/nf toggle")
		end
	end
	NotifyFilterListFrameScrollFrameScrollChild:SetWidth(NotifyFilterListFrame:GetWidth()-55)
	
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", NF.myChatFilter)
	
	if NotifyFilterDB.WindowStatus then
		NF.ShowList()
	end
	
end
