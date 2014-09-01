---------------------------**-**-**-----------------
----------------------**-------------**----------------------------------------------------------------
--------------------**-----------------**---------------------------------------------------------------------------------Options Frame---------------------
---------------------***------------***-----------------
-------------------------**-**-****----


function FindGroup_OButton(this)
	for i=1, #FGL.db.wigets.optionframes do
	if getglobal("FindGroupOptionsFrameButton"..FGL.db.wigets.optionframes[i]):GetName() == this:GetName() then
	for j=1, #FGL.db.wigets.optionframes do
	getglobal("FindGroupOptions"..FGL.db.wigets.optionframes[j].."Frame"):Hide()
	getglobal("FindGroupOptionsFrameButton"..FGL.db.wigets.optionframes[j]):SetHighlightTexture("Interface\\Buttons\\UI-Listbox-Highlight2")
	getglobal("FindGroupOptionsFrameButton"..FGL.db.wigets.optionframes[j]):UnlockHighlight()
	end
	getglobal("FindGroupOptionsFrameButton"..FGL.db.wigets.optionframes[i]):SetHighlightTexture("Interface\\Buttons\\UI-Listbox-Highlight")
	getglobal("FindGroupOptionsFrameButton"..FGL.db.wigets.optionframes[i]):LockHighlight()
	getglobal("FindGroupOptions"..FGL.db.wigets.optionframes[i].."Frame"):Show()
	FindGroupCharVars.CONFIGINDEX = i
	return
	end
	end
end

function FindGroup_ShowOptions()
	if FindGroupOptionsFrame:IsVisible() then FindGroup_HideOptions(); return end
	FindGroup_SetCBFindText()
	FindGroup_Patches_SetText()
	FindGroup_CPatches_SetText()
	FindGroup_APatches_SetText()
	FindGroup_FInstNames_SetText()
	FindGroup_CInstNames_SetText()
	FindGroup_CSpecNames_SetText()
	FindGroupOptionsAlarmFrameComboBox2Text:SetText(FindGroup_GetSoundS(FGL.db.alarmsound))
	FindGroupOptionsViewFindFrameComboBox2Text:SetText(FindGroup_GetBackS(FGL.db.defbackground))
	FindGroupOptionsFindFrameCheckButtonCloseFind:SetChecked(falsetonil(FGL.db.closefindstatus))
	FindGroupOptionsFindFrameCheckButtonFilter:SetChecked(falsetonil(FGL.db.channelfilterstatus))
	FindGroupOptionsViewFindFrameCheckButtonRaidFind:SetChecked(falsetonil(FGL.db.raidfindstatus))
	FindGroupOptionsViewFindFrameCheckButtonClassFind:SetChecked(falsetonil(FGL.db.classfindstatus))
	FindGroupOptionsViewFindFrameCheckButton1:SetChecked(falsetonil(FGL.db.iconstatus))
	FindGroupOptionsViewFindFrameCheckButton2:SetChecked(falsetonil(FGL.db.changebackdrop))
	FindGroupOptionsViewFindFrameCheckButton3:SetChecked(falsetonil(FGL.db.raidcdstatus))
	FindGroupOptionsFindFrameCheckButton2:SetChecked(falsetonil(FGL.db.channelguildstatus))
	FindGroupOptionsFindFrameCheckButton3:SetChecked(falsetonil(FGL.db.channelyellstatus))
	FindGroupOptionsInterfaceFrameCheckButton1:SetChecked(falsetonil(FGL.db.tooltipsstatus))
	FindGroupOptionsAlarmFrameCheckButton1:SetChecked(falsetonil(FGL.db.alarmstatus))
	FindGroupOptionsAlarmFrameCheckButtonAlarmCD:SetChecked(falsetonil(FGL.db.alarmcd))
	FindGroupOptionsCreateRuleFrameCheckButtonLider:SetChecked(falsetonil(FGL.db.FGC.checklider))
	FindGroupOptionsCreateRuleFrameCheckButtonFull:SetChecked(falsetonil(FGL.db.FGC.checkfull))
	FindGroupOptionsCreateRuleFrameCheckButtonId:SetChecked(falsetonil(FGL.db.FGC.checkid))
	FindGroupOptionsMinimapIconFrameCheckButtonShow:SetChecked(falsetonil(FGL.db.minimapiconshow))
	FindGroupOptionsMinimapIconFrameCheckButtonFree:SetChecked(falsetonil(FGL.db.minimapiconfree))
	FindGroupOptionsViewFindFrameCheckButtonShowIVK:SetChecked(falsetonil(FGL.db.showivk))
	FindGroupOptionsCreateViewFrameCheckButtonShowIVK:SetChecked(falsetonil(FGL.db.FGC.showivk))
	FindGroupOptionsFrame:Show()
	FindGroupFrame:Show()
	PlaySound("igCharacterInfoOpen")
end


function FindGroup_UpdateOptions()
	local updateivk = FGL.db.showivk
	FGL.db.closefindstatus = niltofalse(FindGroupOptionsFindFrameCheckButtonCloseFind:GetChecked())
	FGL.db.channelfilterstatus = niltofalse(FindGroupOptionsFindFrameCheckButtonFilter:GetChecked())
	FGL.db.raidfindstatus = niltofalse(FindGroupOptionsViewFindFrameCheckButtonRaidFind:GetChecked())
	FGL.db.classfindstatus = niltofalse(FindGroupOptionsViewFindFrameCheckButtonClassFind:GetChecked())
	FGL.db.channelguildstatus = niltofalse(FindGroupOptionsFindFrameCheckButton2:GetChecked())
	FGL.db.channelyellstatus = niltofalse(FindGroupOptionsFindFrameCheckButton3:GetChecked())
	FGL.db.tooltipsstatus = niltofalse(FindGroupOptionsInterfaceFrameCheckButton1:GetChecked())
	FGL.db.alarmstatus = niltofalse(FindGroupOptionsAlarmFrameCheckButton1:GetChecked())
	FGL.db.alarmcd = niltofalse(FindGroupOptionsAlarmFrameCheckButtonAlarmCD:GetChecked())
	FGL.db.iconstatus = niltofalse(FindGroupOptionsViewFindFrameCheckButton1:GetChecked())
	FGL.db.changebackdrop = niltofalse(FindGroupOptionsViewFindFrameCheckButton2:GetChecked())
	FGL.db.raidcdstatus = niltofalse(FindGroupOptionsViewFindFrameCheckButton3:GetChecked())
	FGL.db.FGC.checklider = niltofalse(FindGroupOptionsCreateRuleFrameCheckButtonLider:GetChecked())
	FGL.db.FGC.checkfull = niltofalse(FindGroupOptionsCreateRuleFrameCheckButtonFull:GetChecked())
	FGL.db.FGC.checkid = niltofalse(FindGroupOptionsCreateRuleFrameCheckButtonId:GetChecked())
	FGL.db.minimapiconshow = niltofalse(FindGroupOptionsMinimapIconFrameCheckButtonShow:GetChecked())
	FGL.db.minimapiconfree = niltofalse(FindGroupOptionsMinimapIconFrameCheckButtonFree:GetChecked())
	FindGroupOptionsViewFindFrameCheckButton1:SetChecked(falsetonil(FGL.db.iconstatus))
	FGL.db.showivk = niltofalse(FindGroupOptionsViewFindFrameCheckButtonShowIVK:GetChecked())
	FGL.db.FGC.showivk = niltofalse(FindGroupOptionsCreateViewFrameCheckButtonShowIVK:GetChecked())
	if not(updateivk == FGL.db.showivk) then
		FindGroup_AllReWrite()
	end
end


function FindGroup_HideOptions()
	FGL.db.closefindstatus = FindGroupCharVars.CLOSEFINDSTATUS
	FGL.db.channelfilterstatus = FindGroupCharVars.CHANNELFILTERSTATUS
	FGL.db.channelguildstatus = FindGroupCharVars.CHANNELGUILDSTATUS
	FGL.db.channelyellstatus = FindGroupCharVars.CHANNELYELLSTATUS
	FGL.db.tooltipsstatus = FindGroupCharVars.TOOLTIPSSTATUS
	FGL.db.framealpha = FindGroupCharVars.FRAMEALPHA
	FGL.db.framealphaback = FindGroupCharVars.FRAMEALPHABACK
	FGL.db.framealphafon = FindGroupCharVars.FRAMEALPHAFON
	FGL.db.framescale = FindGroupCharVars.FRAMESCALE
	FGL.db.alarmsound = FindGroupCharVars.ALARMSOUND
	FGL.db.alarmstatus = FindGroupCharVars.ALARMSTATUS
	FGL.db.raidfindstatus = FindGroupCharVars.RAIDFINDSTATUS
	FGL.db.classfindstatus = FindGroupCharVars.CLASSFINDSTATUS
	FGL.db.defbackground = FindGroupCharVars.DEFBACKGROUND 
	FGL.db.linefadesec = FindGroupCharVars.LINEFADESEC
	FGL.db.showivk = FindGroupCharVars.SHOWIVK

	for i=1, #FindGroupCharVars.findlistvalues do
		FGL.db.findlistvalues[i] = FindGroupCharVars.findlistvalues[i]
	end
	for i=1, #FindGroupCharVars.findpatches do
		FGL.db.findpatches[i] = FindGroupCharVars.findpatches[i]
	end
	for i=1, #FindGroupCharVars.createpatches do
		FGL.db.createpatches[i] = FindGroupCharVars.createpatches[i]
	end
	for i=1, #FindGroupCharVars.alarmpatches do
		FGL.db.alarmpatches[i] = FindGroupCharVars.alarmpatches[i]
	end

		FGL.db.findTinstnamelist = {}
		for index,value in pairs(FindGroupCharVars.findTinstnamelist) do 
		     FGL.db.findTinstnamelist[index] = value
		end
		
		FGL.db.createTinstnamelist = {}
		for index,value in pairs(FindGroupCharVars.createTinstnamelist) do 
		     FGL.db.createTinstnamelist[index] = value
		end

			FGL.db.createspecnamelist={}
			for i=1, #FGL.db.iconclasses.dd do
				local class = string.upper(FGL.db.iconclasses.dd[i])
				FGL.db.createspecnamelist[class]={}
				for j=1, 3 do
					FGL.db.createspecnamelist[class][j] = FindGroupCharVars.createspecnamelist[class][j]
				end
			end
			
	FGL.db.iconstatus = FindGroupCharVars.ICONSTATUS
	FGL.db.changebackdrop = FindGroupCharVars.changebackdrop
	FGL.db.raidcdstatus = FindGroupCharVars.RAIDCDSTATUS
	FGL.db.instsplitestatus = FindGroupCharVars.instsplitestatus

	FGL.db.minimapiconshow = FindGroupCharVars.MINIMAPICONSHOW
	FGL.db.minimapiconfree = FindGroupCharVars.MINIMAPICONFREE

	FGL.db.alarmcd = FindGroupCharVars.ALARMCD

	FGL.db.FGC.checksplite = FindGroupCharVars.FGC.checksplite
	FGL.db.FGC.checklider = FindGroupCharVars.FGC.checklider
	FGL.db.FGC.checkfull = FindGroupCharVars.FGC.checkfull
	FGL.db.FGC.checkid = FindGroupCharVars.FGC.checkid
	FGL.db.FGC.showivk = FindGroupCharVars.FGC.showivk

	FindGroupOptionsInterfaceFrameSlider:SetValue(FGL.db.framealpha)
	FindGroupOptionsInterfaceFrameSliderBack:SetValue(FGL.db.framealphaback)
	FindGroupOptionsInterfaceFrameSliderFon:SetValue(FGL.db.framealphafon)
	FindGroupOptionsInterfaceFrameSliderScale:SetValue(FGL.db.framescale)
	FindGroupOptionsViewFindFrameSliderFade:SetValue(FGL.db.linefadesec)
	FindGroup_ScaleUpdate()
			if falsetonil(FGL.db.alarmstatus) == 1 then FGL.db.alarmstatus = 0  else FGL.db.alarmstatus =  1 end
			FindGroup_AlarmButton()
	FindGroupOptionsFrame:Hide()
	PlaySound("igCharacterInfoClose");
	FindGroup_SetBackGround()
	UIDropDownMenu_SetSelectedValue(FindGroupOptionsAlarmFrameComboBox2, FGL.db.alarmsound, 0)
	UIDropDownMenu_SetSelectedValue(FindGroupOptionsViewFindFrameComboBox2, FGL.db.defbackground, 0)
end

function FindGroup_HideAndSaveOptions()
	FGL.db.closefindstatus = niltofalse(FindGroupOptionsFindFrameCheckButtonCloseFind:GetChecked())
	FGL.db.channelfilterstatus = niltofalse(FindGroupOptionsFindFrameCheckButtonFilter:GetChecked())
	FGL.db.raidfindstatus = niltofalse(FindGroupOptionsViewFindFrameCheckButtonRaidFind:GetChecked())
	FGL.db.classfindstatus = niltofalse(FindGroupOptionsViewFindFrameCheckButtonClassFind:GetChecked())
	FGL.db.channelguildstatus = niltofalse(FindGroupOptionsFindFrameCheckButton2:GetChecked())
	FGL.db.channelyellstatus = niltofalse(FindGroupOptionsFindFrameCheckButton3:GetChecked())
	FGL.db.tooltipsstatus = niltofalse(FindGroupOptionsInterfaceFrameCheckButton1:GetChecked())
	FGL.db.framealpha = FindGroupOptionsInterfaceFrameSlider:GetValue()
	FGL.db.framealphaback = FindGroupOptionsInterfaceFrameSliderBack:GetValue()
	FGL.db.framealphafon = FindGroupOptionsInterfaceFrameSliderFon:GetValue()
	FGL.db.framescale = FindGroupOptionsInterfaceFrameSliderScale:GetValue()
	FGL.db.alarmstatus = niltofalse(FindGroupOptionsAlarmFrameCheckButton1:GetChecked())
	FindGroupCharVars.CLOSEFINDSTATUS = FGL.db.closefindstatus
	FindGroupCharVars.CHANNELFILTERSTATUS = FGL.db.channelfilterstatus
	FindGroupCharVars.CHANNELGUILDSTATUS = FGL.db.channelguildstatus
	FindGroupCharVars.CHANNELYELLSTATUS = FGL.db.channelyellstatus
	FindGroupCharVars.TOOLTIPSSTATUS = FGL.db.tooltipsstatus
	FindGroupCharVars.FRAMEALPHA = FGL.db.framealpha
	FindGroupCharVars.FRAMEALPHABACK = FGL.db.framealphaback
	FindGroupCharVars.FRAMEALPHAFON = FGL.db.framealphafon
	FindGroupCharVars.FRAMESCALE = FGL.db.framescale
	FindGroupCharVars.ALARMSOUND = FGL.db.alarmsound
	FindGroupCharVars.ALARMSTATUS = FGL.db.alarmstatus
	FindGroupCharVars.DEFBACKGROUND = FGL.db.defbackground
	FindGroupCharVars.RAIDFINDSTATUS = FGL.db.raidfindstatus
	FindGroupCharVars.CLASSFINDSTATUS = FGL.db.classfindstatus
	FindGroupCharVars.ICONSTATUS = FGL.db.iconstatus
	FindGroupCharVars.changebackdrop = FGL.db.changebackdrop
	FindGroupCharVars.RAIDCDSTATUS = FGL.db.raidcdstatus
	FindGroupCharVars.instsplitestatus = FGL.db.instsplitestatus
	FindGroupCharVars.LINEFADESEC = FGL.db.linefadesec
	FindGroupCharVars.MINIMAPICONSHOW = FGL.db.minimapiconshow
	FindGroupCharVars.MINIMAPICONFREE = FGL.db.minimapiconfree
	FindGroupCharVars.ALARMCD = FGL.db.alarmcd
	FindGroupCharVars.SHOWIVK = FGL.db.showivk

	for i=1, #FGL.db.findlistvalues do
		FindGroupCharVars.findlistvalues[i] = FGL.db.findlistvalues[i]
	end
	for i=1, #FGL.db.findpatches do
		FindGroupCharVars.findpatches[i] = FGL.db.findpatches[i]
	end
	for i=1, #FGL.db.createpatches do
		FindGroupCharVars.createpatches[i] = FGL.db.createpatches[i]
	end
	for i=1, #FGL.db.alarmpatches do
		FindGroupCharVars.alarmpatches[i] = FGL.db.alarmpatches[i]
	end


		FindGroupCharVars.findTinstnamelist = {}
		for index,value in pairs(FGL.db.findTinstnamelist) do 
		     FindGroupCharVars.findTinstnamelist[index] = value
		end
	
		FindGroupCharVars.createTinstnamelist = {}
		for index,value in pairs(FGL.db.createTinstnamelist) do 
		     FindGroupCharVars.createTinstnamelist[index] = value
		end

	
			FindGroupCharVars.createspecnamelist={}
			for i=1, #FGL.db.iconclasses.dd do
				local class = string.upper(FGL.db.iconclasses.dd[i])
				FindGroupCharVars.createspecnamelist[class]={}
				for j=1, 3 do
					FindGroupCharVars.createspecnamelist[class][j] = FGL.db.createspecnamelist[class][j]
				end
			end
			
	FindGroupCharVars.FGC.checksplite = FGL.db.FGC.checksplite
	FindGroupCharVars.FGC.checklider = FGL.db.FGC.checklider
	FindGroupCharVars.FGC.checkfull = FGL.db.FGC.checkfull
	FindGroupCharVars.FGC.checkid = FGL.db.FGC.checkid
	FindGroupCharVars.FGC.showivk = FGL.db.FGC.showivk

			if falsetonil(FGL.db.alarmstatus) == 1 then FGL.db.alarmstatus = 0  else FGL.db.alarmstatus = 1 end
			FindGroup_AlarmButton()
	FindGroupOptionsFrame:Hide()
	PlaySound("igCharacterInfoClose");
	FindGroup_SetBackGround()
end
