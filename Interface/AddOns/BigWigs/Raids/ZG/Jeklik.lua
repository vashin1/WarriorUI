
----------------------------------
--      Module Declaration      --
----------------------------------

local module, L = BigWigs:ModuleDeclaration("High Priestess Jeklik", "Zul'Gurub")


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	combat_trigger = "grant me wings of v",
	swarmbat_name = "Bloodseeker Bat",
	bombbat_name = "Frenzied Bloodseeker Bat",
	swarm_trigger = "Bloodseeker Bat gains Hover\.",
	bomb_trigger = "Frenzied Bloodseeker Bat gains Hover\.",
	fearrep_trigger1 = "afflicted by Terrifying Screech",
	fearrep_trigger2 = "s Terrifying Screech was resisted",
	fearrep_trigger3 = "Terrifying Screech fail(.+) immune",
	fearrep_trigger4 = "afflicted by Psychic Scream",
	fearrep_trigger5 = "s Psychic Scream was resisted",
	fearrep_trigger6 = "Psychic Scream fail(.+) immune",
	attack_trigger1 = "High Priestess Jeklik attacks",
	attack_trigger2 = "High Priestess Jeklik misses",
	attack_trigger3 = "High Priestess Jeklik hits",
	attack_trigger4 = "High Priestess Jeklik crits",
	liquidfire_trigger = "Liquid Fire",
	liquidfirehitsyou_trigger = "Throw Liquid Fire hits you for",
	liquidfirehitsother_trigger = "Liquid Fire 's Blaze hits (.+) for",
	liquidfireabsorbyou_trigger = "You absorb Liquid Fire 's Blaze\.",
	liquidfireabsorb_trigger = "Liquid Fire 's Blaze is absorbed by (.+)\.",
	liquidfireresistyou_trigger = "Liquid Fire 's Blaze was resisted\.",
	liquidfireresist_trigger = "Liquid Fire 's Blaze was resisted by (.+)\.",
	liquidfireimmuneyou_trigger = "Liquid Fire 's Blaze failed. You are immune\.",
	liquidfireimmune_trigger = "Liquid Fire 's Blaze fails. (.+) is immune\.",
	mindflayyou_trigger = "You are afflicted by Mind Flay\.",
	mindflayother_trigger = "(.+) is afflicted by Mind Flay\.",
	mindflayendyou_trigger = "Mind Flay fades from you\.",
	mindflayend_trigger = "Mind Flay fades from (.+)\.",
	phasetwo_trigger = "Hover fades from High Priestess Jeklik\.",
	heal_trigger = "High Priestess Jeklik begins to cast Great Heal\.",
	swarm_message = "Incoming bat swarm! Kill them!",
	bomb_message = "A bomb bat joins the fight! Watch where you stand!",
	fearinitext = "Fear",
	fearreptext = "Possible Fear",
	mindflaybar = "Mind Flay",
	greathealbar = "Heal",
	greathealtext = "Heal! Interrupt it!",
	phaseone_message = "Bat Phase",
	phasetwo_message = "Troll Phase",
	firewarn = "Move away from fire!",
	firewarnyou = "Move away from fire!",
	you = "you",
	HighPriestessJeklik = "High Priestess Jeklik",

	cmd = "Jeklik",

	phase_cmd = "phase",
	phase_name = "Phase Notification",
	phase_desc = "Announces the boss' phase transition",

	heal_cmd = "heal",
	heal_name = "Heal Alert",
	heal_desc = "Warn for healing",

	flay_cmd = "flay",
	flay_name = "Mind Flay Alert",
	flay_desc = "Warn for casting Mind Flay",

	fear_cmd = "fear",
	fear_name = "Fear Alert",
	fear_desc = "Warn for boss' fear\n\n(Disclaimer: timers vary a lot, usually fear will happen within 10s after the fear bar ends)",

	bomb_cmd = "bomb",
	bomb_name = "Bomb Bat Alert",
	bomb_desc = "Warn for Bomb Bats",

	swarm_cmd = "swarm",
	swarm_name = "Bat Swarm Alert",
	swarm_desc = "Warn for Bat swarms",
	swarm_bartext = "Bat Swarm",

	announce_cmd = "whispers",
	announce_name = "Whisper to burning people",
	announce_desc = "Sends a whisper to players that stand in fire\n\n(Requires assistant or higher)\n\n(Disclaimer: to avoid spamming whispers, it will only whisper people that take damage from fire that is on the ground - aka not the Bat's throw itself)",
} end )

L:RegisterTranslations("deDE", function() return {
	combat_trigger = "grant me wings of v",
	swarmbat_name = "Bloodseeker Bat",
	bombbat_name = "Frenzied Bloodseeker Bat",
	swarm_trigger = "Bloodseeker Bat bekommt \'Schweben\'\.",
	bomb_trigger = "Frenzied Bloodseeker Bat bekommt \'Schweben\'\.",
	fearrep_trigger1 = "von Schreckliches Kreischen betroffen",
	fearrep_trigger2 = "Schreckliches Kreischen(.+) widerstanden",
	fearrep_trigger3 = "Schreckliches Kreischen(.+) immun",
	fearrep_trigger4 = "von Psychischer Schrei betroffen",
	fearrep_trigger5 = "Psychischer Schrei(.+) widerstanden",
	fearrep_trigger6 = "Psychischer Schrei(.+) immun",
	attack_trigger1 = "High Priestess Jeklik greift an",
	attack_trigger2 = "High Priestess Jeklik verfehlt",
	attack_trigger3 = "High Priestess Jeklik trifft",
	attack_trigger4 = "High Priestess Jeklik trifft (.+) kritisch",
	liquidfire_trigger = "Liquid Fire",
	liquidfirehitsyou_trigger = "Liquid Fire trifft Euch mit \'Feuermeer'",
	liquidfirehitsother_trigger = "Liquid Fires Feuermeer trifft (.+) f",
	liquidfireabsorbyou_trigger = "Ihr absorbiert Liquid Fires Feuermeer",
	liquidfireabsorb_trigger = "Feuermeer von Liquid Fire wird absorbiert von\: (.+)\.",
	liquidfireresistyou_trigger = "Liquid Fire versucht es mit Feuermeer\.\.\. widerstanden\.",
	liquidfireresist_trigger = "Liquid Fires Feuermeer wurde von (.+) widerstanden\.",
	liquidfireimmuneyou_trigger = "Liquid Fire versucht es mit Feuermeer\.\.\. ein Fehlschlag. Ihr seid immun\.",
	liquidfireimmune_trigger = "Liquid Fire versucht es mit Feuermeer. Ein Fehlschlag, denn (.+) ist immun\.",
	mindflayyou_trigger = "Ihr seid von Gedankenschinden betroffen.",
	mindflayother_trigger = "(.+) ist von Gedankenschinden betroffen.",
	mindflayendyou_trigger = "\'Gedankenschinden\' schwindet von Euch\.",
	mindflayend_trigger = "Gedankenschinden schwindet von (.+)\.",
	phasetwo_trigger = "Schweben schwindet von High Priestess Jeklik\.",
	heal_trigger = "High Priestess Jeklik beginnt Gro\195\159e Heilung zu wirken\.",
	swarm_message = "Fledermausschwarm jetzt! T\195\182te sie!",
	bomb_message = "Eine Bomber-Fledermaus erscheint zum Kampf! Pass auf, wo du stehst!",
	fearinitext = "Furcht",
	fearreptext = "M\195\182gliche Furcht",
	mindflaybar = "Gedankenschinden",
	greathealbar = "Heilung",
	greathealtext = "Heilung! Unterbreche sie!",
	phaseone_message = "Fledermaus-Phase",
	phasetwo_message = "Troll-Phase",
	firewarn = "Move from fire!",
	firewarnyou = "Beweg\' dich aus dem Feuer!",
	you = "Euch",
	HighPriestessJeklik = "High Priestess Jeklik",

	cmd = "Jeklik",

	phase_cmd = "phase",
	phase_name = "Phasen-Benachrichtigung",
	phase_desc = "Verk\195\188ndet den Phasenwechsel des Bosses",

	heal_cmd = "heal",
	heal_name = "Alarm f\195\188r Heilung",
	heal_desc = "Warnen, wenn Jeklik versucht sich zu heilen",

	flay_cmd = "flay",
	flay_name = "Alarm f\195\188r Gedankenschindent",
	flay_desc = "Warnen, wenn Gedankenschinden gewirkt wird",

	fear_cmd = "fear",
	fear_name = "Alarm f\195\188r Furcht",
	fear_desc = "Warnen, wenn Boss Furcht wirkt.\n\n(Dementi: Timers variieren sehr, normalerweise wird Furcht innerhalb 10 Sekunden passieren, nachdem der Furcht-Balken endet)",

	bomb_cmd = "bomb",
	bomb_name = "Alarm f\195\188r Bomber-Flederm\195\164use",
	bomb_desc = "Warnen vor Bomber-Flederm\195\164use.",

	swarm_cmd = "swarm",
	swarm_name = "Alarm f\195\188r Fledermausschw\195\164rme",
	swarm_desc = "Warnen vor Fledermausschw\195\164rme.",
	swarm_bartext = "Fledermausschwarm",

	announce_cmd = "whispers",
	announce_name = "Brennenden Personen fl\195\188stern",
	announce_desc = "Fl\195\188ster der Person, die im Feuer steht\n\n(Ben\195\182tigt Schlachtzugleiter oder Assistent)\n\n(Dementi: to avoid spamming whispers, it will only whisper people that take damage from fire that is on the ground - aka not the Bat's throw itself)",
} end )


---------------------------------
--      	Variables 		   --
---------------------------------

-- module variables
module.revision = 20008 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"phase", "heal", "flay", "fear", "swarm", "bomb", "announce", "bosskill"}

-- Proximity Plugin
-- module.proximityCheck = function(unit) return CheckInteractDistance(unit, 2) end
-- module.proximitySilent = false


-- locals
local timer = {
	firstFear = 45,
	fear = 45,
	firstSilence = 8,
	healCast = 4,
	nextHeal = 20,
	fear2 = 45,
	fireBombs = 10,
	mindflay = 25,
	bats = 45,
}
local icon = {
	fear = "Spell_Shadow_SummonImp",
	fear2 = "Spell_Shadow_PsychicScream",
	silence = "Spell_Frost_Iceshock",
	fire = "Spell_Fire_Lavaspawn",
	bomb = "Spell_Fire_Fire",
	mindflay = "Spell_Shadow_SiphonMana",
	heal = "Spell_Holy_Heal",
	bats = "Spell_Fire_SelfDestruct",
}
local syncName = {
	fear = "JeklikFearRep"..module.revision,
	fear2 = "JeklikFearTwoRep"..module.revision,
	mindflay = "JeklikMindFlay"..module.revision,
	mindflayOver = "JeklikMindFlayEnd"..module.revision,
	heal = "JeklikHeal"..module.revision,
	healOver = "JeklikHealStop"..module.revision,
	bombBats = "JeklikBombBats"..module.revision,
	swarmBats = "JeklikSwarmBats"..module.revision,
}

local berserkannounced = nil


------------------------------
--      Initialization      --
------------------------------

module:RegisterYellEngage(L["combat_trigger"])

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_HITS", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_MISSES", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_HITS", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_MISSES", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_HITS", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_MISSES", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_MISSES", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS", "Event")
	
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:ThrottleSync(10, syncName.fear)
	self:ThrottleSync(10, syncName.fear2)
	self:ThrottleSync(1.5, syncName.mindflay)
	self:ThrottleSync(1.5, syncName.mindflayOver)
	self:ThrottleSync(4, syncName.heal)
	self:ThrottleSync(4, syncName.healOver)
	self:ThrottleSync(5, syncName.bombBats)
	self:ThrottleSync(5, syncName.swarmBats)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self.phase          = 0
	self.lastHeal       = 0
	self.castingheal    = 0
end

-- called after boss is engaged
function module:OnEngage()
	self.phase = 1
	--[[if self.db.profile.fear then
		self:Bar(L["fearreptext"], timer.firstFear, icon.fear)
	end
	--]]
	if self.db.profile.phase then
		self:Message(L["phaseone_message"], "Attention")
	end
	self:Bar("First Silence", timer.firstSilence, icon.silence)

	-- bats
	if self.db.profile.swarm then
		self:Bar(L["swarm_bartext"], timer.bats, icon.bats);
	end
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Events              --
------------------------------

function module:CHAT_MSG_MONSTER_YELL(msg)
	if string.find(msg, L["phasetwo_trigger"]) then
		self:Sync("JeklikPhaseTwo")
	end
end

function module:Event(msg)
	local _,_,mindflayother,_ = string.find(msg, L["mindflayother_trigger"])
	local _,_,mindflayend,_ = string.find(msg, L["mindflayend_trigger"])
	local _,_,liquidfirehitsother,_ = string.find(msg, L["liquidfirehitsother_trigger"])
	local _,_,liquidfireresist,_ = string.find(msg, L["liquidfireresist_trigger"])
	local _,_,liquidfireabsorb,_ = string.find(msg, L["liquidfireabsorb_trigger"])
	local _,_,liquidfireimmune,_ = string.find(msg, L["liquidfireimmune_trigger"])
	if string.find(msg, "Your Flames hits you") then
		if self.db.profile.bomb then
			-- Your Flames hits you for %d Fire damage.
			self:WarningSign(icon.fire, 2)
			self:Message(L["firewarnyou"], "Attention", "Alarm")
		end
	elseif string.find(msg, L["heal_trigger"]) then
		self:Sync(syncName.heal)
	elseif string.find(msg, L["phasetwo_trigger"]) then
		self:Sync("JeklikPhaseTwo")
	elseif string.find(msg, L["mindflayyou_trigger"]) then
		self:Sync(syncName.mindflay)
	elseif mindflayother and (UnitIsInRaidByName(mindflayother) or UnitIsPetByName(mindflayother)) then
		self:Sync(syncName.mindflay)
	elseif string.find(msg, L["mindflayendyou_trigger"]) then
		self:Sync(syncName.mindflayOver)
	elseif mindflayend and (UnitIsInRaidByName(mindflayend) or UnitIsPetByName(mindflayend)) then
		self:Sync(syncName.mindflayOver)
	elseif string.find(msg, L["fearrep_trigger1"]) or string.find(msg, L["fearrep_trigger2"]) or string.find(msg, L["fearrep_trigger3"]) then
		self:Sync(syncName.fear)
	elseif string.find(msg, L["fearrep_trigger4"]) or string.find(msg, L["fearrep_trigger5"]) or string.find(msg, L["fearrep_trigger6"]) then
		self:Sync(syncName.fear2)
	elseif string.find(msg, L["attack_trigger1"]) or string.find(msg, L["attack_trigger2"]) or string.find(msg, L["attack_trigger3"]) or string.find(msg, L["attack_trigger4"]) then
		if self.castingheal == 1 then
			if (GetTime()-self.lastHeal) < timer.healCast then
				self:Sync(syncName.healOver)
			elseif (GetTime()-self.lastHeal) >= timer.healCast then
				self.castingheal = 0
			end
		end
	elseif msg == L["bomb_trigger"] then
		self:Sync(syncName.bombBats)
	elseif msg == L["swarm_trigger"] then
		self:Sync(syncName.swarmBats)
	elseif string.find(msg, L["liquidfire_trigger"]) then
		if self.db.profile.announce then
			if string.find(msg, L["liquidfirehitsyou_trigger"]) then
			-- do I still need this?
			--self:Message(L["firewarnyou"], "Attention", "Alarm")
			--self:WarningSign(icon.fire, 2)
			elseif msg == L["liquidfireresistyou_trigger"] or msg == L["liquidfireabsorbyou_trigger"] or msg == L["liquidfireimmuneyou_trigger"] then
				self:Message(L["firewarn"], "Attention", "Alarm")
			elseif liquidfirehitsother and liquidfirehitsother~=L["you"] then
				self:TriggerEvent("BigWigs_SendTell", liquidfirehitsother, L["firewarn"])
			elseif liquidfireresist then
				self:TriggerEvent("BigWigs_SendTell", liquidfireresist, L["firewarn"])
			elseif liquidfireabsorb then
				self:TriggerEvent("BigWigs_SendTell", liquidfireabsorb, L["firewarn"])
			elseif liquidfireimmune then
				self:TriggerEvent("BigWigs_SendTell", liquidfireimmune, L["firewarn"])
			end
		end
	end
end

function module:UNIT_HEALTH(msg)
	if UnitName(msg) == self.translatedName then
		if UnitHealthMax(msg) == 100 then
			if self.phase < 2 and UnitHealth(msg) < 50 then
				self:Sync("JeklikPhaseTwo")
				self:UnregisterEvent("UNIT_HEALTH")
			end
		end
	end
end

------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == "JeklikPhaseTwo" and self.phase < 2 then
		self.phase = 2
		self:KTM_Reset()
		if self.db.profile.phase then
			self:Message(L["phasetwo_message"], "Attention")
		end
		if self.db.profile.fear then
			self:RemoveBar(L["fearreptext"])
			self:Bar(L["fearreptext"], timer.fear2, icon.fear2)
		end
		self:Bar("Fire Bombs", timer.fireBombs, icon.bomb)
	elseif sync == syncName.fear and self.db.profile.fear then
		self:Bar(L["fearreptext"], timer.fear, icon.fear)
	elseif sync == syncName.fear2 then
		if self.db.profile.fear then
			self:Bar(L["fearreptext"], timer.fear2, icon.fear2)
		end
		if self.db.profile.heal then
			self:RemoveBar(L["greathealbar"])
		end
	elseif sync == syncName.swarmBats and self.db.profile.swarm then
		self:Message(L["swarm_message"], "Urgent")
	elseif sync == syncName.bombBats and self.db.profile.bomb then
		self:Message(L["bomb_message"], "Urgent")
	elseif sync == syncName.mindflay then
		if self.db.profile.flay then
			self:RemoveBar(L["mindflaybar"])
			self:Bar(L["mindflaybar"], timer.mindflay, icon.mindflay)
		end
		if self.db.profile.heal then
			self:RemoveBar(L["greathealbar"])
		end
	elseif sync == syncName.mindflayOver and self.db.profile.flay then
		self:RemoveBar(L["mindflaybar"])
	elseif sync == syncName.heal then
		self.lastHeal = GetTime()
		self.castingheal = 1
		if self.db.profile.heal then
			self:RemoveBar("Next Heal")
			self:Message(L["greathealtext"], "Important", "Alarm")
			self:Bar(L["greathealbar"], timer.healCast, icon.heal)
		end
	elseif sync == syncName.healOver then
		self.castingheal = 0
		if self.db.profile.heal then
			self:RemoveBar(L["greathealbar"])
			if (self.lastHeal + timer.nextHeal) > GetTime() then
				self:Bar("Next Heal", (self.lastHeal + timer.nextHeal - GetTime()), icon.heal)
			end
		end
	end
end
