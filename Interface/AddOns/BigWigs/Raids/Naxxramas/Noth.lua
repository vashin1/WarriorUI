
----------------------------------
--      Module Declaration      --
----------------------------------

local module, L = BigWigs:ModuleDeclaration("Noth the Plaguebringer", "Naxxramas")


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Noth",

	blink_cmd = "blink",
	blink_name = "Blink Alert",
	blink_desc = "Warn for blink",

	teleport_cmd = "teleport",
	teleport_name = "Teleport Alert",
	teleport_desc = "Warn for teleport",

	curse_cmd = "curse",
	curse_name = "Curse Alert",
	curse_desc = "Warn for curse",

	wave_cmd = "wave",
	wave_name = "Wave Alert",
	wave_desc = "Warn for waves",

	starttrigger1 = "Die, trespasser!",
	starttrigger2 = "Glory to the master!",
	starttrigger3 = "Your life is forfeit!",
	startwarn = "Noth the Plaguebringer engaged! 90 seconds till teleport",

	addtrigger = "Rise, my soldiers! Rise and fight once more!",

	blinktrigger = "Noth the Plaguebringer gains Blink.",
	blinkwarn = "Blink!",
	blinkwarn5 = "Blink in ~5 seconds!",
	blinkwarn10 = "Blink in ~10 seconds!",
	blinkbar = "Possible Blink",

	teleportwarn = "Teleport! He's on the balcony!",
	teleportwarn10 = "Teleport in 10 seconds!",
	teleportwarn30 = "Teleport in 30 seconds!",

	teleportbar = "Teleport!",
	backbar = "Back in room!",

	backwarn = "He's back in the room for %d seconds!",
	backwarn10 = "10 seconds until he's back in the room!",
	backwarn30 = "30 seconds until he's back in the room!",

	cursetrigger = "afflicted by Curse of the Plaguebringer",
	cursewarn = "Curse! next in ~28 seconds",
	curse10secwarn = "Curse in ~10 seconds",

	cursebar = "Next Curse",

	wave1bar = "Wave 1",
	wave2bar = "Wave 2",
	wave2_message = "Wave 2 in 10sec",
	wave2s_message = "Wave 2 Spawning!",
	roomaddsbar = "Adds ",
} end )


---------------------------------
--      	Variables 		   --
---------------------------------

-- module variables
module.revision = 20012 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"blink", "teleport", "curse", "wave", "bosskill"}


-- locals
local timer = {
	firstBlink = {30,45},
	regularBlink = {30,45},

	blinkAfterTeleport = {5,10},

	firstRoom = 90,
	secondRoom = 110,
	thirdRoom = 180,
	room = 0, -- will be changed during the encounter

	firstBalcony = 70,
	secondBalcony = 95,
	thirdBalcony = 120,
	balcony = 0, -- will be changed during the encounter

	firstCurse = {10,15},
	curseAfterTeleport = {5,10},
	curse = {50,60},

	balcony1wave1 = {11, 12},
	balcony1wave2 = {41, 42},
	
	balcony2wave1 = {10,16},
	balcony2wave2 = {55,59},
	
	balcony3wave1 = {6, 10}, --need info
	balcony3wave2 = {66, 70}, --need info
	
	balconywave1 = {0, 0},
	balconywave2 = {0, 0},
	
	room1wave1 = {16, 17},
	room1wave2 = {50, 51},
	room1wave3 = {82, 83},
	
	room2wave1 = {12,15},
	room2wave2 = {42,48},
	room2wave3 = {75,83},
	room2wave4 = {108,116},
	
	room3wave1 = {12,13},
	room3wave2 = {43,47},
	room3wave3 = {76, 80}, --need info
	room3wave4 = {107, 110}, --need info
	room3wave5 = {141, 145}, --need info
	room3wave6 = {172, 175}, --need info
	
}
local icon = {
	balcony = "Spell_Magic_LesserInvisibilty",
	blink = "Spell_Arcane_Blink",
	wave = "Spell_ChargePositive",
	curse = "Spell_Shadow_AnimateDead",
	roomadds = "Spell_Shadow_RaiseDead",
}
local syncName = {
	blink = "NothBlink"..module.revision,
	curse = "NothCurse"..module.revision,
}

local berserkannounced = nil
local roomPhase = 1
------------------------------
--      Initialization      --
------------------------------

module:RegisterYellEngage(L["starttrigger1"])
module:RegisterYellEngage(L["starttrigger2"])
module:RegisterYellEngage(L["starttrigger3"])

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", "CheckForBlink")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "CheckForCurse")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "CheckForCurse")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "CheckForCurse")

	self:ThrottleSync(5, syncName.blink)
	self:ThrottleSync(5, syncName.curse)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	roomPhase = 1
	timer.room = timer.firstRoom
	timer.balcony = timer.firstBalcony
	timer.balconywave1 = timer.balcony1wave1
	timer.balconywave2 = timer.balcony1wave2
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.teleport then
		self:Message(L["startwarn"], "Important")
		self:Bar(L["teleportbar"], timer.room, icon.balcony)
	end
	if self.db.profile.blink then
		self:IntervalBar(L["blinkbar"], timer.firstBlink[1], timer.firstBlink[2], icon.blink)
	end
	if self.db.profile.curse then
		self:IntervalBar(L["cursebar"], timer.firstCurse[1], timer.firstCurse[2], icon.curse)
	end
	if self.db.profile.wave then
		self:RoomAdds(roomPhase)
	end
	self:ScheduleEvent("bwnothtobalcony", self.TeleportToBalcony, timer.room, self)
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end

------------------------------
--      Initialization      --
------------------------------

function module:CheckForCurse(msg)
	if string.find(msg, L["cursetrigger"]) then
		self:Sync(syncName.curse)
	end
end

function module:CheckForBlink(msg)
	if msg == L["blinktrigger"] then
		self:Sync(syncName.blink)
	end
end

function module:TeleportToBalcony()
	self:CancelScheduledEvent("bwnothtobalcony")
	if timer.room == timer.firstRoom then
		timer.room = timer.secondRoom
	elseif timer.room == timer.secondRoom then
		timer.room = timer.thirdRoom
	end

	self:RemoveBar(L["blinkbar"])
	self:RemoveBar(L["cursebar"])

	if self.db.profile.teleport then
		self:Message(L["teleportwarn"], "Important")
		self:Bar(L["backbar"], timer.balcony, icon.balcony)
	end
	if self.db.profile.wave then
		self:IntervalBar(L["wave1bar"], timer.balconywave1[1], timer.balconywave1[2], icon.wave)
		self:IntervalBar(L["wave2bar"], timer.balconywave2[1], timer.balconywave2[2], icon.wave)
	end
	self:ScheduleEvent("bwnothtoroom", self.TeleportToRoom, timer.balcony, self)
end

function module:TeleportToRoom()
	self:CancelScheduledEvent("bwnothtoroom")
	if timer.balcony == timer.firstBalcony then
		timer.balcony = timer.secondBalcony
		timer.balconywave1 = timer.balcony2wave1
		timer.balconywave2 = timer.balcony2wave2
	elseif timer.balcony == timer.secondBalcony then
		timer.balcony = timer.thirdBalcony
		timer.balconywave1 = timer.balcony3wave1
		timer.balconywave2 = timer.balcony3wave2
	end
	if self.db.profile.wave then
		roomPhase = roomPhase + 1
		self:RoomAdds(roomPhase)
	end
	if self.db.profile.teleport then
		self:Message(string.format(L["backwarn"], timer.room), "Important")
		self:IntervalBar(L["blinkbar"], timer.blinkAfterTeleport[1], timer.blinkAfterTeleport[2], icon.blink)
		self:Bar(L["teleportbar"], timer.room, icon.balcony)
	end
	if self.db.profile.curse then
		self:IntervalBar(L["cursebar"], timer.curseAfterTeleport[1], timer.curseAfterTeleport[2], icon.curse)
	end

	self:ScheduleEvent("bwnothtobalcony", self.TeleportToBalcony, timer.room, self)

	self:KTM_Reset()
end


------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.curse then
		self:Curse()
	elseif sync == syncName.blink then
		self:Blink()
	end
end

------------------------------
--      Utility	Functions   --
------------------------------

function module:Curse()
	if self.db.profile.curse then
		self:Message(L["cursewarn"], "Important", nil, "Alarm")
		self:IntervalBar(L["cursebar"], timer.curse[1], timer.curse[2], icon.curse)
	end
end

function module:Blink()
	if self.db.profile.blink then
		self:Message(L["blinkwarn"], "Important")
		self:IntervalBar(L["blinkbar"], timer.regularBlink[1], timer.regularBlink[2], icon.blink)
	end
	self:KTM_Reset()
end

function module:RoomAdds(phase)
	if phase == 1 then
		local wavecount = 1
		self:IntervalBar(L["roomaddsbar"]..wavecount, timer.room1wave1[1], timer.room1wave1[2], icon.roomadds)
		wavecount = wavecount + 1
		self:DelayedIntervalBar(timer.room1wave1[1], L["roomaddsbar"]..wavecount, timer.room1wave2[1]-timer.room1wave1[1], timer.room1wave2[2]-timer.room1wave1[1], icon.roomadds)
		wavecount = wavecount + 1
		self:DelayedIntervalBar(timer.room1wave2[1], L["roomaddsbar"]..wavecount, timer.room1wave3[1]-timer.room1wave2[1], timer.room1wave3[2]-timer.room1wave2[1], icon.roomadds)
	elseif phase == 2 then
		local wavecount = 1
		self:IntervalBar(L["roomaddsbar"]..wavecount, timer.room2wave1[1], timer.room2wave1[2], icon.roomadds)
		wavecount = wavecount + 1
		self:DelayedIntervalBar(timer.room2wave1[1], L["roomaddsbar"]..wavecount, timer.room2wave2[1]-timer.room2wave1[1], timer.room2wave2[2]-timer.room2wave1[1], icon.roomadds)
		wavecount = wavecount + 1
		self:DelayedIntervalBar(timer.room2wave2[1], L["roomaddsbar"]..wavecount, timer.room2wave3[1]-timer.room2wave2[1], timer.room2wave3[2]-timer.room2wave2[1], icon.roomadds)
		wavecount = wavecount + 1
		self:DelayedIntervalBar(timer.room2wave3[1], L["roomaddsbar"]..wavecount, timer.room2wave4[1]-timer.room2wave3[1], timer.room2wave4[2]-timer.room2wave3[1], icon.roomadds)
	elseif phase == 3 then
		local wavecount = 1
		self:IntervalBar(L["roomaddsbar"]..wavecount, timer.room3wave1[1], timer.room3wave1[2], icon.roomadds)
		wavecount = wavecount + 1
		self:DelayedIntervalBar(timer.room3wave1[1], L["roomaddsbar"]..wavecount, timer.room3wave2[1]-timer.room3wave1[1], timer.room3wave2[2]-timer.room3wave1[1], icon.roomadds)
		wavecount = wavecount + 1
		self:DelayedIntervalBar(timer.room3wave2[1], L["roomaddsbar"]..wavecount, timer.room3wave3[1]-timer.room3wave2[1], timer.room3wave3[2]-timer.room3wave2[1], icon.roomadds)
		wavecount = wavecount + 1
		self:DelayedIntervalBar(timer.room3wave3[1], L["roomaddsbar"]..wavecount, timer.room3wave4[1]-timer.room3wave3[1], timer.room3wave4[2]-timer.room3wave3[1], icon.roomadds)
		wavecount = wavecount + 1
		self:DelayedIntervalBar(timer.room3wave4[1], L["roomaddsbar"]..wavecount, timer.room3wave5[1]-timer.room3wave4[1], timer.room3wave5[2]-timer.room3wave4[1], icon.roomadds)
		wavecount = wavecount + 1
		self:DelayedIntervalBar(timer.room3wave5[1], L["roomaddsbar"]..wavecount, timer.room3wave6[1]-timer.room3wave5[1], timer.room3wave6[2]-timer.room3wave5[1], icon.roomadds)
	end
end