--[[
by Dorann
Reduces farclip (terrain distance) to a minimum in naxxramas to avoid screen freezes
--]]


assert( BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------
local L = AceLibrary("AceLocale-2.2"):new("BigWigsFarclip")
local minFarclip = 177
----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["Farclip"] = true,
	["farclip"] = true,
	["Adjusts your Terrain Distance and Spell Detail Level inside Naxxramas to prevent freezes, fps drops and invisible textures for certain boss abilities."] = true,
	["Activate Farclip"] = true,
	["Allow BigWigs to modify your terrain distance inside Naxxramas."] = true,
	["Default Farclip Value"] = true,
	["Set the default Farclip value."] = true,
	["Activate SpellDetail"] = true,
	["Allow BigWigs to modify your spell detail level inside Naxxramas."] = true,
	["Default Spell Detail Level"] = true,
	["Set the default Spell Detail Level."] = true,
} end)

--[[L:RegisterTranslations("deDE", function() return {

} end)
]]
----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsFarclip = BigWigs:NewModule(L["Farclip"])
BigWigsFarclip.revision = 20012
BigWigsFarclip.defaultDB = {
	active = true,
	active2 = true,
	defaultFarclip = 777,
	defaultSpellEffectLevel = 2,
}
BigWigsFarclip.consoleCmd = L["farclip"]

BigWigsFarclip.consoleOptions = {
	type = "group",
	name = L["Farclip"],
	desc = L["Adjusts your Terrain Distance and Spell Detail Level inside Naxxramas to prevent freezes, fps drops and invisible textures for certain boss abilities."],
	args   = {
		active = {
			type = "toggle",
			name = L["Activate Farclip"],
			desc = L["Allow BigWigs to modify your terrain distance inside Naxxramas."],
			order = 1,
			get = function() return BigWigsFarclip.db.profile.active end,
			set = function(v) BigWigsFarclip.db.profile.active = v end,
		--passValue = "reverse",
		},
		default = {
			type = "range",
			name = L["Default Farclip Value"],
			desc = L["Set the default Farclip value."],
			order = 2,
			min = 177,
			max = 777,
			step = 60,
			get = function() return BigWigsFarclip.db.profile.defaultFarclip end,
			set = function(v) 
				BigWigsFarclip.db.profile.defaultFarclip = v 
				SetCVar("farclip", v)
			end,
		},
		active2 = {
			type = "toggle",
			name = L["Activate SpellDetail"],
			desc = L["Allow BigWigs to modify your spell detail level inside Naxxramas."],
			order = 3,
			get = function() return BigWigsFarclip.db.profile.active2 end,
			set = function(v) BigWigsFarclip.db.profile.active2 = v end,
		},
		spelleffect = {
			type = "range",
			name = L["Default Spell Detail Level"],
			desc = L["Set the default Spell Detail Level."],
			order = 4,
			min = 0,
			max = 2,
			step = 1,
			get = function() return BigWigsFarclip.db.profile.defaultSpellEffectLevel end,
			set = function(v)
				BigWigsFarclip.db.profile.defaultSpellEffectLevel = v
				SetCVar("spellEffectLevel", v)
			end,
		},
	}
}

------------------------------
--      Initialization      --
------------------------------

function BigWigsFarclip:OnEnable()
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("MINIMAP_ZONE_CHANGED")
end

function BigWigsFarclip:ZONE_CHANGED_NEW_AREA()
	self:DebugMessage(1)
	if self.db.profile.active then
		self:DebugMessage(2)
		if AceLibrary("Babble-Zone-2.2")["Naxxramas"] == GetRealZoneText() then
			--self.db.profile.defaultFarclip = GetCVar("farclip")
			SetCVar("farclip", minFarclip) -- http://wowwiki.wikia.com/wiki/CVar_farclip
		else
			self:DebugMessage(3)
			if tonumber(GetCVar("farclip")) == minFarclip then
				self:DebugMessage(4)
				SetCVar("farclip", self.db.profile.defaultFarclip)
			end
		end
	end
end

function BigWigsFarclip:MINIMAP_ZONE_CHANGED(msg)
	if self.db.profile.active2 then
		if GetMinimapZoneText() == "Sapphiron's Lair" then
			SetCVar("spellEffectLevel", 1) --Sapphiron
		elseif GetMinimapZoneText() == "Kel'Thuzad Chamber" then
			SetCVar("spellEffectLevel", 2) --KT
		elseif GetCVar("spellEffectLevel") ~= self.db.profile.defaultSpellEffectLevel then
			SetCVar("spellEffectLevel", self.db.profile.defaultSpellEffectLevel)
		end
	end
end