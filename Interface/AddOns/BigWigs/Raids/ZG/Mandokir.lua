
----------------------------------
--      Module Declaration      --
----------------------------------

local module, L = BigWigs:ModuleDeclaration("Bloodlord Mandokir", "Zul'Gurub")


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	ohgan = "Ohgan",
	cmd = "Mandokir",

	engage_trigger = "feed your souls to Hakkar himself",
	watch_trigger = "(.+)! I'm watching you!",
	charge_trigger = "Bloodlord Mandokir's Charge",
	charge_bar = "Next Charge",
	gaze_trigger = "Bloodlord Mandokir begins to cast Threatening Gaze.",
	gazeafflictyou = "You are afflicted by Threatening Gaze.",
	gazeafflictother = "(.+) is afflicted by Threatening Gaze.",
	gazeendyou = "Threatening Gaze fades from you.",
	gazeendother = "Threatening Gaze fades from (.+).",
	gazecast = "Incoming Threatening Gaze!",
	gazewatchedbar = "Threatening Gaze: %s",
	gaze_onme = "Gaze on ",
	enragegain = "Bloodlord Mandokir gains Enrage.",
	enragefade = "Enrage fades from Bloodlord Mandokir.",
	enragebar = "Enrage",
	wwgain = "Bloodlord Mandokir gains Whirlwind.",
	wwloss = "Whirlwind fades from Bloodlord Mandokir.",
	ww = "Whirlwind",
	deathyou = "You die.",
	deathother = "(.+) dies.",
	you = "you",

	watched_warning = "You are being watched! Stop everything!",
	watched_warning_tell = "You are being watched! Stop everything!",
	watched_warning_other = "%s is being watched!",
	enraged_message = "Ohgan down! Mandokir enraged!",

	announce_cmd = "whispers",
	announce_name = "Whisper watched players",
	announce_desc = "Warn when boss uses Threatening Gaze.\n\n(Requires assistant or higher)",

	puticon_cmd = "puticon",
	puticon_name = "Raid icon on watched players",
	puticon_desc = "Place a raid icon on the watched person.\n\n(Requires assistant or higher)",

	gaze_cmd = "gaze",
	gaze_name = "Threatening Gaze alert",
	gaze_desc = "Shows bars for Threatening Gaze",

	whirlwind_cmd = "whirlwind",
	whirlwind_name = "Whirlwind Alert",
	whirlwind_desc = "Shows Whirlwind bars",

	enraged_cmd = "enraged",
	enraged_name = "Enrage alert",
	enraged_desc = "Announces the boss' Enrage",

	["Possible Gaze"] = true,
} end )

L:RegisterTranslations("deDE", function() return {
	ohgan = "Ohgan",
	cmd = "Mandokir",

	engage_trigger = "feed your souls to Hakkar himself",
	watch_trigger = "(.+)! I'm watching you!",
	gaze_trigger = "Bloodlord Mandokir beginnt Bedrohlicher Blick zu wirken.",
	gazeafflictyou = "Ihr seid von Bedrohlicher Blick betroffen.",
	gazeafflictother = "(.+) ist von Bedrohlicher Blick betroffen.",
	gazeendyou = "'Bedrohlicher Blick' schwindet von Euch.",
	gazeendother = "Bedrohlicher Blick schwindet von (.+).",
	gazecast = "Bedrohlicher Blick kommt!",
	gazewatchedbar = "Bedrohlicher Blick: %s",
	enragegain = "Bloodlord Mandokir bekommt 'Wutanfall'.",
	enragefade = "Wutanfall schwindet von Bloodlord Mandokir.",
	enragebar = "Wutanfall",
	wwgain = "Bloodlord Mandokir bekommt 'Wirbelwind'.",
	wwloss = "Wirbelwind schwindet von Bloodlord Mandokir\.",
	ww = "Wirbelwind",
	deathyou = "Du stirbst.",
	deathother = "(.+) stirbt.",
	you = "Euch",

	watched_warning = "Du wirst beobachtet! Stoppen Sie alles!",
	watched_warning_tell = "You are being watched! Stop everything!",
	watched_warning_other = "%s wird beobachtet!",
	enraged_message = "Ohgan ist tot! Mandokir wütend!",

	announce_cmd = "whispers",
	announce_name = "Warnung, wenn Spieler beobachtet werden",
	announce_desc = "Warnen, wenn Bloodlord Mandokir wirft Bedrohlicher Blick\n\n(Benötigt Schlachtzugleiter oder Assistent)",

	puticon_cmd = "puticon",
	puticon_name = "Schlachtzugsymbol auf die beobachtet Spieler",
	puticon_desc = "Versetzt eine Schlachtzugsymbol auf der beobachteten Spieler.\n\n(Benötigt Schlachtzugleiter oder Assistent)",

	gaze_cmd = "gaze",
	gaze_name = "Alarm für Bedrohlicher Blick",
	gaze_desc = "Zeigt Balken für Bedrohlicher Blick",

	whirlwind_cmd = "whirlwind",
	whirlwind_name = "Alarm für Wirbelwind",
	whirlwind_desc = "Zeigt Balken für Wirbelwind",

	enraged_cmd = "enraged",
	enraged_name = "Verkündet Boss' Raserei",
	enraged_desc = "Lässt dich wissen, wenn Boss härter zuschlägt",

	["Possible Gaze"] = "Mögliches Starren"
} end )


---------------------------------
--      	Variables 		   --
---------------------------------

-- module variables
module.revision = 20008 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
module.wipemobs = { L["ohgan"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"gaze", "announce", "puticon", "whirlwind", "enraged", "bosskill"}


-- locals
local timer = {
	firstCharge = 21,
	chargeInterval = 34,
	
	whirlwindCast = 2,
	earliestFirstWhirlwind = 14,
	latestFirstWhirlwind = 17,
	whirlwindInterval = 15,
	
	gazeDuration = 6,
	gazeCast = 2,
	firstGaze = 18,
	gaze = 20,
}
local icon = {
	charge = "Ability_Warrior_Charge",
	whirlwind = "Ability_Whirlwind",
	gaze = "Spell_Shadow_Charm",
	charge = "ability_warrior_charge"
}
local syncName = {
	whirlwind = "MandokirWWStart"..module.revision,
	whirlwindOver = "MandokirWWStop"..module.revision,
	enrage = "MandokirEnrageStart"..module.revision,
	enrageOver = "MandokirEnrageEnd"..module.revision,
	gazeCast = "MandokirGazeCast"..module.revision,
	gazeAfflicted = "MandokirGazeAfflict"..module.revision,
	gazeOver = "MandokirGazeEnd"..module.revision,
	charge = "MandokirCharge"..module.revision,
}

------------------------------
--      Initialization      --
------------------------------

module:RegisterYellEngage(L["engage_trigger"])

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Event")

	self:ThrottleSync(5, syncName.whirlwind)
	self:ThrottleSync(5, syncName.whirlwindOver)
	self:ThrottleSync(5, syncName.enrage)
	self:ThrottleSync(5, syncName.enrageOver)
	self:ThrottleSync(5, syncName.gazeCast)
	self:ThrottleSync(5, syncName.gazeAfflicted)
	self:ThrottleSync(5, syncName.gazeOver)
	self:ThrottleSync(5, syncName.charge)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
end

-- called after boss is engaged
function module:OnEngage()
	self:Bar("Charge", timer.firstCharge, icon.charge)
	self:IntervalBar("Next Whirlwind", timer.earliestFirstWhirlwind, timer.latestFirstWhirlwind, icon.whirlwind)
	self:Bar(L["Possible Gaze"], timer.firstGaze, icon.gaze)
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers	    --
------------------------------

function module:CHAT_MSG_MONSTER_YELL(msg)
	local gazetime
	local _,_,watchedplayer,_ = string.find(msg, L["watch_trigger"])
	if watchedplayer then
		if self.db.profile.announce then
			if watchedplayer == UnitName("player") then
				self:SendSay(L["gaze_onme"] .. UnitName("player") .. "!")
				self:Message(L["watched_warning"], "Personal", true, "Alarm")
			else
				self:Message(string.format(L["watched_warning_other"], watchedplayer), "Attention")
				self:TriggerEvent("BigWigs_SendTell", watchedplayer, L["watched_warning_tell"])
			end
		end
		if self.db.profile.puticon then
			self:Icon(watchedplayer)
		end
		if watchedplayer == UnitName("player") and self.db.profile.gaze then
			self:WarningSign(icon.gaze, 7)
		end
	end
end

function module:Event(msg)
	local _,_,gazedplayer,_ = string.find(msg, L["gazeafflictother"])
	local _,_,gazedplayerend,_ = string.find(msg, L["gazeendother"])
	--local _,_,gazeddeathend,_ = string.find(msg, L["deathother"])
	if msg == L["wwgain"] then
		self:Sync(syncName.whirlwind)
	elseif msg == L["wwloss"] then
		self:Sync(syncName.whirlwindOver)
	elseif msg == L["enragegain"] then
		self:Sync(syncName.enrage)
	elseif msg == L["enragefade"] then
		self:Sync(syncName.enrageOver)
	elseif msg == L["gaze_trigger"] then
		self:Sync(syncName.gazeCast)
	elseif msg == L["gazeafflictyou"] then
		gazetime = GetTime()
		self:Sync(syncName.gazeAfflicted .. " " .. UnitName("player"))
	elseif gazedplayer then
		gazetime = GetTime()
		self:Sync(syncName.gazeAfflicted .. " " .. gazedplayer)
	elseif msg == L["gazeendyou"] then
		self:Sync(syncName.gazeOver .. " " .. UnitName("player"))
	elseif gazedplayerend and gazedplayerend ~= L["you"] then
		self:Sync(syncName.gazeOver .. " " .. gazedplayerend)
		--elseif msg == L["deathyou"] then
		--	self:Sync("MandokirGazeEnd "..UnitName("player"))
		--elseif gazeddeathend then
		--	self:Sync("MandokirGazeEnd "..gazeddeathend)
	elseif string.find(msg, L["charge_trigger"]) then
		self:Sync(syncName.charge)
	end
end


------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.whirlwind and self.db.profile.whirlwind then
		self:Bar(L["ww"], timer.whirlwindCast, icon.whirlwind)
		--self:ScheduleEvent("BigWigs_StartBar", 2, self, "Next Whirlwind", 18, icon.whirlwind)
	elseif sync == syncName.whirlwindOver and self.db.profile.whirlwind then
		self:RemoveBar(L["ww"])
		self:Bar("Next Whirlwind", timer.whirlwindInterval, icon.whirlwind)
	elseif sync == syncName.enrage and self.db.profile.enraged then
		self:Message(L["enraged_message"], "Urgent")
		self:Bar(L["enragebar"], 90, "Spell_Shadow_UnholyFrenzy")
	elseif sync == syncName.enrageOver and self.db.profile.enraged then
		self:RemoveBar(L["enragebar"])
	elseif sync == syncName.gazeCast and self.db.profile.gaze then
		self:Bar(L["gazecast"], timer.gazeCast, icon.gaze)
		self:RemoveBar(L["Possible Gaze"])
	elseif sync == syncName.gazeAfflicted and self.db.profile.gaze then
		self:Bar(string.format(L["gazewatchedbar"], rest), timer.gazeDuration, icon.gaze, true, "Black")
	elseif sync == syncName.gazeOver then
		if self.db.profile.gaze then
			self:RemoveBar(string.format(L["gazewatchedbar"], rest))
		end
		if self.db.profile.puticon then
			self:RemoveIcon(rest)
		end
		self:Bar(L["Possible Gaze"], timer.gaze, icon.gaze)
	elseif sync == syncName.charge then
		self:Bar(L["charge_bar"], timer.chargeInterval, icon.charge)
	end
end
