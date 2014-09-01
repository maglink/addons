local RollTracker, RTL = ...;

if not RTL.locales then RTL.locales = {} end

RTL.locales.__index = {
		["Roll(s) and FakeRoll(s)"] = "%d Roll(s)      %d FakeRoll(s)",
		["Roll(s)"] = "%d Roll(s)",
		["No Item"] = "No Item",
		["ReportText_Player"] = "%s - report on the rally %s, which was declared the player %s at %s",
		["ReportText_NoItem"] = "%s - report on the rally %s, was started at %s",
		["ReportText"] = "%s - report on the rally %s",
		["Report"] = "Report",
		["Lines"] = "Lines",
		["Clear"] = "Clear",
		["Roll"] = "Roll",
		["Channel"] = "Channel",
		["Whisper"] = "Whisper",
		["Whisper Target"] = "Whisper Target",
		["Say"] = "Say",
		["Raid"] = "Raid",
		["Party"] = "Party",
		["Guild"] = "Guild",
		["Officer"] = "Officer",
		["Self"] = "Self",
		["ROLLTRACKER_CONFIRM_CLEAR_ROLLS"] = "Do you really want everything clean?",
	}
