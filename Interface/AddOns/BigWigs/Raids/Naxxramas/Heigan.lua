
----------------------------------
--      Module Declaration      --
----------------------------------

local module, L = BigWigs:ModuleDeclaration("Heigan the Unclean", "Naxxramas")


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Heigan",

	teleport_cmd = "teleport",
	teleport_name = "Teleport Alert",
	teleport_desc = "Warn for Teleports.",

	engage_cmd = "engage",
	engage_name = "Engage Alert",
	engage_desc = "Warn when Heigan is engaged.",

	disease_cmd = "disease",
	disease_name = "Decrepit Fever Alert",
	disease_desc = "Warn for Decrepit Fever",

	erruption_cmd = "erruption",
	erruption_name = "Erruption Alert",
	erruption_desc = "Warn for Erruption",
	
	manaburn_cmd = "manaburn",
	manaburn_name = "Mana Burn Alert",
	manaburn_desc = "Warn for Mana Burn",

	-- [[ Triggers ]]--
	starttrigger = "You are mine now!",
	starttrigger2 = "You...are next!",
	starttrigger3 = "I see you!",
	toPlatform_trigger1 = "teleports and begins to channel a spell!",
	toPlatform_trigger2 = "The end is upon you.",
	toFloor_trigger = "rushes to attack once more!",
	die_trigger = "takes his last breath.",
	dtrigger = "afflicted by Decrepit Fever.",
	manaburn_trigger = "Heigan the Unclean's Mana Burn",

	-- [[ Warnings ]]--
	engage_message = "Heigan the Unclean engaged!",

	dwarn = "Decrepit Fever",

	on_platform_message = "Teleport! Dancing for %d sec!",

	to_floor_30sec_message = "Back in 30 sec",
	to_floor_10sec_message = "Back in 10 sec!",
	on_floor_message = "Back on the floor! 90 sec to next teleport!",

	-- [[ Bars ]]--
	toPlatform_bar = "Teleport!",
	toFloor_bar = "Back on the floor!",
	dbar = "Decrepit Fever",
	erruptionbar = "Eruption",
	dancingshoes = "Put on your dancing shoes!",
	manaburn_bar = "Mana Burn",

	-- [[ Dream Room Mobs ]] --
	["Eye Stalk"] = true,
	["Rotting Maggot"] = true,
} end )


---------------------------------
--      	Variables 		   --
---------------------------------

-- module variables
module.revision = 20012 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["Eye Stalk"], L["Rotting Maggot"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"engage", "teleport", "disease", "erruption", "manaburn", "bosskill"}


-- locals
local timer = {
	firstDisease = 10,
	firstDiseaseAfterDance = 10,
	disease = 25,
	toFloor = 45,
	toPlatform = 90, --dance
	firstErruption = 15,
	firstErruptionAfterDance = 11,
	firstDanceErruption = 3,
	erruption = 0, -- will be changed during the encounter
	erruptionSlow = 10,
	erruptionFast = 3,
	firstManaburn = 15,
	firstManaburnAfterDance = 5,
	manaburnInterval = 10,
}
local icon = {
	disease = "Ability_Creature_Disease_03",
	toFloor = "Spell_Magic_LesserInvisibilty",
	toPlatform = "Spell_Arcane_Blink",
	erruption = "spell_fire_selfdestruct",
	dancing = "INV_Gizmo_RocketBoot_01",
	manaburn = "Spell_Frost_ManaBurn",
}
local syncName = {
	toPlatform = "HeiganToPlatform"..module.revision,
	toFloor = "HeiganToFloor"..module.revision,
	disease = "HeiganDisease"..module.revision,
}


------------------------------
--      Initialization      --
------------------------------

module:RegisterYellEngage(L["starttrigger"])
module:RegisterYellEngage(L["starttrigger2"])
module:RegisterYellEngage(L["starttrigger3"])

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE", "Teleport")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL", "Teleport")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "CheckForDisease")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "CheckForDisease")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "CheckForDisease")

	self:ThrottleSync(10, syncName.toPlatform)
	self:ThrottleSync(10, syncName.toFloor)
	self:ThrottleSync(5, syncName.disease)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.teleport then
		self:Bar(L["toPlatform_bar"], timer.toPlatform, icon.toPlatform)
	end
	if self.db.profile.disease then
		self:Bar(L["dbar"], timer.firstDisease, icon.disease)
	end
	if self.db.profile.manaburn then
		self:Bar(L["manaburn_bar"], timer.firstManaburn, icon.manaburn, true, "Blue")
		self:ScheduleEvent("heiganmanaburn", self.Manaburn, timer.firstManaburn, self)
	end
	if self.db.profile.erruption then
		timer.erruption = timer.erruptionSlow
		self:Bar(L["erruptionbar"], timer.firstErruption, icon.erruption)
		self:ScheduleEvent("HeiganErruption", self.Erruption, timer.firstErruption, self)
	end
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------

function module:CHAT_MSG_MONSTER_EMOTE( msg )
	if string.find(msg, L["die_trigger"]) then
		self:SendBossDeathSync()
	end
end

function module:Teleport(msg)
	if string.find(msg, L["toPlatform_trigger1"]) or string.find(msg, L["toPlatform_trigger2"]) then
		self:Sync(syncName.toPlatform)
	elseif string.find(msg, L["toFloor_trigger"]) then
		self:Sync(syncName.toFloor)
	end
end

function module:CheckForDisease( msg )
	if string.find(msg, L["dtrigger"]) then
		if self.db.profile.disease then
			self:Sync(syncName.disease)
		end
	end
end

function module:Erruption()
	if self.db.profile.erruption then
		-- don't show bar before teleport
		local registered, time, elapsed = self:BarStatus(L["toPlatform_bar"])
		if registered and timer and elapsed then
			local remaining = time - elapsed
			if timer.erruption <= remaining then
				self:Bar(L["erruptionbar"], timer.erruption, icon.erruption)
				self:ScheduleEvent("HeiganErruption", self.Erruption, timer.erruption, self)
			else
				self:Sound("Beware")
				self:Bar(L["dancingshoes"], remaining, icon.dancing)
			end
		else
			self:Bar(L["erruptionbar"], timer.erruption, icon.erruption)
			self:ScheduleEvent("HeiganErruption", self.Erruption, timer.erruption, self)
		end

	end
end

function module:Manaburn()
	self:Bar(L["manaburn_bar"], timer.manaburnInterval, icon.manaburn, true, "Blue")
	self:ScheduleEvent("heiganmanaburn", self.Manaburn, timer.manaburnInterval, self)
end

------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.disease then
		self:Disease()
	elseif sync == syncName.toPlatform then
		self:ToPlatform()
	elseif sync == syncName.toFloor then
		self:ToFloor()
	end
end

------------------------------
--      Sync Handlers	    --
------------------------------

function module:Disease()
	if self.db.profile.disease then
		self:Message(L["dwarn"], "Important")

		-- don't show bar before teleport
		local registered, time, elapsed = self:BarStatus(L["toPlatform_bar"])
		if time and elapsed then
			local remaining = time - elapsed
			if timer.disease <= remaining then
				self:Bar(L["dbar"], timer.disease, icon.disease)
			end
		end
	end
end

function module:ToPlatform()
	self:CancelScheduledEvent("heiganmanaburn")
	if self.db.profile.teleport then
		self:Message(string.format(L["on_platform_message"], timer.toFloor), "Attention")
		self:Bar(L["toFloor_bar"], timer.toFloor, icon.toFloor)
	end
	if self.db.profile.erruption then
		self:CancelScheduledEvent("HeiganErruption")

		timer.erruption = timer.erruptionFast
		self:Bar(L["erruptionbar"], timer.firstDanceErruption, icon.erruption)
		self:ScheduleEvent("HeiganErruption", self.Erruption, timer.firstDanceErruption, self)
	end
	self:ScheduleEvent("bwHeiganToFloor",  self.ToFloor, timer.toFloor, self )
end

function module:ToFloor()
	self:CancelScheduledEvent("bwHeiganToFloor")
	if self.db.profile.teleport then
		self:Message(L["on_floor_message"], "Attention")
		self:Bar(L["toPlatform_bar"], timer.toPlatform, icon.toPlatform)
	end
	if self.db.profile.disease then
		self:Bar(L["dbar"], timer.firstDiseaseAfterDance, icon.disease)
	end
	if self.db.profile.manaburn then
		self:Bar(L["manaburn_bar"], timer.firstManaburnAfterDance, icon.manaburn, true, "Blue")
		self:ScheduleEvent("heiganmanaburn", self.Manaburn, timer.firstManaburnAfterDance, self)
	end
	if self.db.profile.erruption then
		self:CancelScheduledEvent("HeiganErruption")

		timer.erruption = timer.erruptionSlow
		self:Bar(L["erruptionbar"], timer.firstErruptionAfterDance, icon.erruption)
		self:ScheduleEvent("HeiganErruption", self.Erruption, timer.firstErruptionAfterDance, self)
	end
end