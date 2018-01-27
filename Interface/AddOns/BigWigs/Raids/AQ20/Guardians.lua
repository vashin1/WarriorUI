
----------------------------------
--      Module Declaration      --
----------------------------------

local module, L = BigWigs:ModuleDeclaration("Anubisath Guardian", "Ruins of Ahn'Qiraj")


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Guardian",

	summon_cmd = "summon",
	summon_name = "Summon Alert",
	summon_desc = "Warn for summoned adds",

	plagueyou_cmd = "plagueyou",
	plagueyou_name = "Plague on you alert",
	plagueyou_desc = "Warn for plague on you",

	plagueother_cmd = "plagueother",
	plagueother_name = "Plague on others alert",
	plagueother_desc = "Warn for plague on others",

	icon_cmd = "icon",
	icon_name = "Place icon",
	icon_desc = "Place raid icon on the last plagued person (requires promoted or higher)",

	explode_cmd = "explode",
	explode_name = "Explode Alert",
	explode_desc = "Warn for incoming explosion",

	enrage_cmd = "enrage",
	enrage_name = "Enrage Alert",
	enrage_desc = "Warn for enrage",
	
	meteor_cmd = "meteor",
	meteor_name = "Meteor Alert",
	meteor_desc = "Warn for meteor",
	
	meteortrigger = "Anubisath Guardian's Meteor",
	meteorbar = "Meteor CD",
	meteorwarn = "Meteor!",
	explodetrigger = "Anubisath Guardian gains Explode.",
	explodewarn = "Exploding!",
	enragetrigger = "Anubisath Guardian gains Enrage.",
	enragewarn = "Enraged!",
	summonguardtrigger = "Anubisath Guardian casts Summon Anubisath Swarmguard.",
	summonguardwarn = "Swarmguard Summoned",
	summonwarriortrigger = "Anubisath Guardian casts Summon Anubisath Warrior.",
	summonwarriorwarn = "Warrior Summoned",
	plaguetrigger = "^([^%s]+) ([^%s]+) afflicted by Plague%.$",
	plaguewarn = " has the Plague!",
	plaguewarnyou = "You have the Plague!",
	plagueyou = "You",
	plagueare = "are",
	plague_onme = "Plague on ",
} end )

L:RegisterTranslations("deDE", function() return {
	summon_name = "Beschw\195\182rung",
	summon_desc = "Warnung, wenn Besch\195\188tzer des Anubisath Schwarmwachen oder Krieger beschw\195\182rt.",

	plagueyou_name = "Du hast die Seuche",
	plagueyou_desc = "Warnung, wenn Du die Seuche hast.",

	plagueother_name = "X hat die Seuche",
	plagueother_desc = "Warnung, wenn andere Spieler die Seuche haben.",

	icon_name = "Symbol",
	icon_desc = "Platziert ein Symbol \195\188ber dem Spieler, der die Seuche hat. (Ben\195\182tigt Anf\195\188hrer oder Bef\195\182rdert Status.)",

	explode_name = "Explosion",
	explode_desc = "Warnung vor Explosion.",

	enrage_name = "Wutanfall",
	enrage_desc = "Warnung vor Wutanfall.",

	explodetrigger = "Besch\195\188tzer des Anubisath bekommt 'Explodieren'.",
	explodewarn = "Explosion!",
	enragetrigger = "Besch\195\188tzer des Anubisath bekommt 'Wutanfall'.",
	enragewarn = "Wutanfall!",
	summonguardtrigger = "Besch\195\188tzer des Anubisath wirkt Schwarmwache des Anubisath beschw\195\182ren.",
	summonguardwarn = "Schwarmwache beschworen!",
	summonwarriortrigger = "Besch\195\188tzer des Anubisath wirkt Krieger des Anubisath beschw\195\182ren.",
	summonwarriorwarn = "Krieger beschworen!",
	plaguetrigger = "^([^%s]+) ([^%s]+) von Seuche betroffen%.$",
	plaguewarn = " hat die Seuche!",
	plaguewarnyou = "Du hast die Seuche!",
	plagueyou = "Ihr",
	plagueare = "seid",
} end )


---------------------------------
--      	Variables 		   --
---------------------------------

-- module variables
module.revision = 20009 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
module.toggleoptions = {"summon", "meteor", "explode", "enrage", -1, "plagueyou", "plagueother", "icon"--[[, "bosskill"]]}

module.defaultDB = {
	bosskill = false,
}

-- locals
local timer = {
	meteor = {8,13},
}
local icon = {
	plague = "Spell_Shadow_CurseOfTounges",
	meteor = "Spell_Fire_Fireball02",
}
local syncName = {}


------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "CheckPlague")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "CheckPlague")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "CheckPlague")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "MeteorEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "MeteorEvent")
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self.started = false
	berserkannounced = false
end

-- called after boss is engaged
function module:OnEngage()
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------

function module:MeteorEvent(msg)
	if string.find(msg, L["meteortrigger"]) and self.db.profile.meteor then
		self:IntervalBar(L["meteorbar"], timer.meteor[1], timer.meteor[2], icon.meteor)
		self:Message(L["meteorwarn"], "Important")
	end
end

-- override to suppress victory message and sound
function module:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == string.format(UNITDIESOTHER, boss) then
		self.core:ToggleModuleActive(self, false)
	end
end

function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS( msg )
	if self.db.profile.explode and msg == L["explodetrigger"] then
		self:Message(L["explodewarn"], "Important")
	elseif self.db.profile.enrage and msg == L["enragetrigger"] then
		self:Message(L["enragewarn"], "Important")
	end
end

function module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF( msg )
	if self.db.profile.summon and msg == L["summonguardtrigger"] then
		self:Message(L["summonguardwarn"], "Attention")
	elseif self.db.profile.summon and msg == L["summonwarriortrigger"] then
		self:Message(L["summonwarriorwarn"], "Attention")
	end
end

function module:CheckPlague( msg )
	local _,_, player, type = string.find(msg, L["plaguetrigger"])
	if player and type then
		if self.db.profile.plagueyou and player == L["plagueyou"] and type == L["plagueare"] then
			self:SendSay(L["plague_onme"] .. UnitName("player") .. "!")
			self:Message(L["plaguewarnyou"], "Personal", true, "RunAway")
			self:Message(UnitName("player") .. L["plaguewarn"], "Attention", nil, nil, true )
			self:WarningSign(icon.plague, 5)
		elseif self.db.profile.plagueother then
			self:Message(player .. L["plaguewarn"], "Attention")
			self:TriggerEvent("BigWigs_SendTell", player, L["plaguewarnyou"])
		end

		if self.db.profile.icon then
			self:Icon(player)
		end
	end
end
