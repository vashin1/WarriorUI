
----------------------------------
--      Module Declaration      --
----------------------------------

local module, L = BigWigs:ModuleDeclaration("Anubisath Warder", "Ahn'Qiraj")


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Warder",

	fear_cmd = "fear",
	fear_name = "Fear timer",
	fear_desc = "Shows fear cd",

	silence_cmd = "silence",
	silence_name = "Silence timer",
	silence_desc = "Shows Silence cd",

	roots_cmd = "roots",
	roots_name = "Roots timer",
	roots_desc = "Shows Roots cd",

	dust_cmd = "dust",
	dust_name = "Dust Cloud timer",
	dust_desc = "Shows Dust Cloud cd",

	warnings_cmd = "warnings",
	warnings_name = "Warning messages ",
	warnings_desc = "Warning messages showing which 2 abilities current mob has",

	fearTrigger = "Anubisath Warder begins to cast Fear.",
	fearBar = "Fear!",
	fearBar_next = "Possible Fear",

	silenceTrigger = "Anubisath Warder begins to cast Silence.",
	silenceBar = "Silence!",
	silenceBar_next = "Possible Silence",

	rootsTrigger = "Anubisath Warder begins to cast Entangling Roots.",
	rootsBar = "Roots!",
	rootsBar_next = "Possible Roots",

	dustTrigger = "Anubisath Warder begins to perform Dust Cloud.",
	dustBar = "Dust Cloud!",
	dustBar_next = "Possible Dust Cloud",

	dustWarn = "Dust Cloud",
	dustWarn2 = "(Roots or Fear)", --dust cloud/roots, dust cloud/fear confirmed

	fearWarn = "Fear",
	fearWarn2 = "(Silence or Dust Cloud)", --fear/dust cloud confirmed

	rootsWarn = "Roots",
	rootsWarn2 = "(Silence or Dust Cloud)", --roots/silence, roots/dust cloud confirmed

	silenceWarn = "Silence",
	silenceWarn2 = "(Roots or Fear)", --silence/roots confirmed

} end )

---------------------------------
--      	Variables 		   --
---------------------------------

-- module variables
module.revision = 20002 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"fear", "silence", "roots", "dust", "warnings"--[[, "bosskill"]]}

-- locals
local timer = {
	earliestFear = 14,
	latestFear = 19,
	fearCast = 1.5,
	earliestSilence = 14,
	latestSilence = 19,
	silenceCast = 1.5,
	earliestRoots = 7,
	latestRoots = 14,
	rootsCast = 1.5,
	earliestDust = 14,
	latestDust = 19,
	dustCast = 1.5,
}
local icon = {
	fear = "Spell_Shadow_Possession",
	silence = "Spell_Holy_Silence",
	roots = "Spell_Nature_StrangleVines",
	dust = "Ability_Hibernation",
}
local syncName = {
	fear = "WarderFear"..module.revision,
	silence = "WarderSilence"..module.revision,
	roots = "WarderRoots"..module.revision,
	dust = "WarderDust"..module.revision,
}

local pull = nil
------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Event")

	if not warnings then
		warnings = {
			["dust"] = {L["dustWarn"], L["dustWarn2"]},
			["roots"] = {L["rootsWarn"], L["rootsWarn2"]},
			["fear"] = {L["fearWarn"], L["fearWarn2"]},
			["silence"] = {L["silenceWarn"], L["silenceWarn2"]},
		}
	end

	self:ThrottleSync(6, syncName.fear)
	self:ThrottleSync(6, syncName.silence)
	self:ThrottleSync(3, syncName.roots)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
end

-- called after boss is engaged
function module:OnEngage()
	self.ability1 = nil
	self.ability2 = nil
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------

function module:Event(msg)
	if string.find(msg, L["fearTrigger"]) then
		self:Sync(syncName.fear)
	elseif string.find(msg, L["silenceTrigger"]) then
		self:Sync(syncName.silence)
	elseif string.find(msg, L["rootsTrigger"]) then
		self:Sync(syncName.roots)
	elseif string.find(msg, L["dustTrigger"]) then
		self:Sync(syncName.dust)
	end
end

------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync( sync, rest, nick )
	if sync == syncName.fear then
		if self.db.profile.fear then
			self:RemoveBar(L["fearBar_next"])
			self:Bar(L["fearBar"], timer.fearCast, icon.fear, true, "Red")
			self:DelayedIntervalBar(timer.fearCast, L["fearBar_next"], timer.earliestFear-timer.fearCast, timer.latestFear-timer.fearCast, icon.fear, true, "White")
		end
		self:AbilityWarn("fear")
	elseif sync == syncName.silence then
		if self.db.profile.silence then
			self:RemoveBar(L["silenceBar_next"])
			self:Bar(L["silenceBar"], timer.silenceCast, icon.silence, true, "Gray")
			self:DelayedIntervalBar(timer.silenceCast, L["silenceBar_next"], timer.earliestSilence-timer.silenceCast, timer.latestSilence-timer.silenceCast, icon.silence, true, "Gray")
		end
		self:AbilityWarn("silence")
	elseif sync == syncName.roots then
		if self.db.profile.roots then
			self:RemoveBar(L["rootsBar_next"])
			self:Bar(L["rootsBar"], timer.rootsCast, icon.roots, true, "Green")
			self:DelayedIntervalBar(timer.rootsCast, L["rootsBar_next"], timer.earliestRoots-timer.rootsCast, timer.latestRoots-timer.rootsCast, icon.roots, true, "Green")
		end
		self:AbilityWarn("roots")
	elseif sync == syncName.dust then
		if self.db.profile.dust then
			self:RemoveBar(L["dustBar_next"])
			self:Bar(L["dustBar"], timer.dustCast, icon.dust, true, "Yellow")
			self:DelayedIntervalBar(timer.dustCast, L["dustBar_next"], timer.earliestDust-timer.dustCast, timer.latestDust-timer.dustCast, icon.dust, true, "Yellow")
		end
		self:AbilityWarn("dust")
	end
end

function module:AbilityWarn( ability )
	if self.db.profile.warnings then
		if not self.ability1 then
			self.ability1 = ability
			self:Message(string.format("%s + %s",warnings[self.ability1][1], warnings[self.ability1][2]), "Core", nil, "Long")
		elseif not self.ability2 and ability ~= self.ability1 then
			self.ability2 = ability
			self:Message(string.format("%s + %s",warnings[self.ability1][1], warnings[self.ability2][1]), "Core", nil, "Long")
		end
	end
end
