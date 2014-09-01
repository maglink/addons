local FlashStealth, FS = ...;
local LOWHEALTH_MIN_ALPHA, LOWHEALTH_MAX_ALPHA = 0.6, 1

FS.Event = CreateFrame("Frame")
FS.Event:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
FS.Event:SetScript("OnEvent", function(frame, mevent, timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellID, spellName)
	local playerGUID = UnitGUID("player")
	if not(destGUID == playerGUID) then return end
	if not(sourceGUID == playerGUID) then return end
	if not(spellName == "Незаметность") then return end
	if event == "SPELL_AURA_APPLIED" then
		local c = FlashStealthDB.color
		FlashStealthFrame.texture:SetVertexColor(c.r, c.g, c.b, c.a)
		FS.StartFlashing(2, 2, 1);
	elseif event == "SPELL_AURA_REMOVED" then
		FS.StopFlashing();
	end
end)

FS.Enter = CreateFrame("Frame")
FS.Enter:RegisterEvent("PLAYER_ENTERING_WORLD")
FS.Enter:SetScript("OnEvent", function(frame, event)
	if UnitBuff("player", "Незаметность") then
		local c = FlashStealthDB.color
		FlashStealthFrame.texture:SetVertexColor(c.r, c.g, c.b, c.a)
		FS.StartFlashing(2, 2, 1);
	end
end)

FS.OnLoad = function()
	if not(FlashStealthDB) or not(type(FlashStealthDB) == 'table') then
		FlashStealthDB = {}
	end
	if not(FlashStealthDB.color) then
		FlashStealthDB.color = {
			r=1,
			g=1,
			b=1,	
			a=0.5
		}
	end
end

FS.OnLoad()

-- /run FlashStealthDB.color={r=1,g=1,b=1,a=0.5}

FS.StartFlashing = function(fadeInTime, fadeOutTime, flashStart, flashDuration, flashInHoldTime, flashOutHoldTime)
 	-- Time it takes to fade in a flashing frame
 	FlashStealthFrame.fadeInTime = fadeInTime;
 	-- Time it takes to fade out a flashing frame
 	FlashStealthFrame.fadeOutTime = fadeOutTime;
 	-- How long to keep the frame flashing
 	FlashStealthFrame.flashDuration = flashDuration;
 	-- How long to hold the faded in state
 	FlashStealthFrame.flashInHoldTime = flashInHoldTime;
 	-- How long to hold the faded out state
 	FlashStealthFrame.flashOutHoldTime = flashOutHoldTime;
 	FlashStealthFrame.flashStart = flashStart;
	
 	FlashStealthFrame.flashMode = "IN_START";
 	FlashStealthFrame.flashTimer = 0;				-- timer for the current flash mode
 	FlashStealthFrame.flashDurationTimer = 0;		-- timer for the entire flash
 
 	FlashStealthFrame:SetAlpha(LOWHEALTH_MIN_ALPHA);
 	FlashStealthFrame:Show();
 
 	FlashStealthFrame:SetScript("OnUpdate", FS.OnUpdate);
 end
 
 FS.OnUpdate = function(self, elapsed)
 	self.flashDurationTimer = self.flashDurationTimer + elapsed;
 	-- If flashDuration is exceeded
 	if ( self.flashDuration and (self.flashDurationTimer > self.flashDuration) ) then
 		FlashStealthFrame_StopFlashing();
 	else
 		if ( self.flashMode == "IN" ) then
 			local alpha = LOWHEALTH_MIN_ALPHA + (LOWHEALTH_MAX_ALPHA - LOWHEALTH_MIN_ALPHA) * (self.flashTimer / self.fadeOutTime);
 			self:SetAlpha(alpha);
 
 			if ( self.flashTimer >= self.fadeInTime ) then
 				if ( self.flashInHoldTime and self.flashInHoldTime > 0 ) then
 					self.flashMode = "IN_HOLD";
 				else
 					self.flashMode = "OUT";
 				end
 				self.flashTimer = 0;
 			else
 				self.flashTimer = self.flashTimer + elapsed;
 			end
 		elseif ( self.flashMode == "IN_HOLD" ) then
 			self:SetAlpha(LOWHEALTH_MAX_ALPHA);
 
 			if ( self.flashTimer >= self.flashInHoldTime ) then
 				self.flashMode = "OUT";
 				self.flashTimer = 0;
 			else
 				self.flashTimer = self.flashTimer + elapsed;
 			end
 		elseif ( self.flashMode == "IN_START" ) then
 			self:SetAlpha(self.flashTimer/self.flashStart);
			
 			if ( self.flashTimer >= self.flashStart) then
 				self.flashMode = "OUT";
 				self.flashTimer = 0;
 			else
 				self.flashTimer = self.flashTimer + elapsed;
 			end
 		elseif ( self.flashMode == "OUT" ) then
 			local alpha = LOWHEALTH_MAX_ALPHA + (LOWHEALTH_MIN_ALPHA - LOWHEALTH_MAX_ALPHA) * (self.flashTimer / self.fadeOutTime);
 			self:SetAlpha(alpha);
 
 			if ( self.flashTimer >= self.fadeOutTime ) then
 				if ( self.flashOutHoldTime and self.flashOutHoldTime > 0 ) then
 					self.flashMode = "OUT_HOLD";
 				else
 					self.flashMode = "IN";
 				end
 				self.flashTimer = 0;
 			else
 				self.flashTimer = self.flashTimer + elapsed;
 			end
 			self:SetAlpha(alpha);
 		elseif ( self.flashMode == "OUT_HOLD" ) then
 			self:SetAlpha(LOWHEALTH_MIN_ALPHA);
 
 			self.flashTimer = self.flashTimer + elapsed;
 			if ( self.flashTimer >= self.flashOutHoldTime ) then
 				self.flashMode = "IN";
 				self.flashTimer = 0;
 			else
 				self.flashTimer = self.flashTimer + elapsed;
 			end
 		end
 	end
 end
 
 FS.StopFlashing = function()
 	if ( FlashStealthFrame:IsShown() ) then
 		FlashStealthFrame:SetScript("OnUpdate", nil);
 		FlashStealthFrame:Hide();
 	end
 end