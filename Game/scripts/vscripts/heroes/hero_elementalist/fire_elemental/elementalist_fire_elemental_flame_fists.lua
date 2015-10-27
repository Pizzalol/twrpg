elementalist_fire_elemental_flame_fists = class({})
LinkLuaModifier( "modifier_elementalist_fire_elemental_flame_fists", "heroes/hero_elementalist/fire_elemental/modifiers/modifier_elementalist_fire_elemental_flame_fists.lua" , LUA_MODIFIER_MOTION_NONE )

--[[Author: Pizzalol
	Passive ability which deals aoe damage upon landing an attack]]
function elementalist_fire_elemental_flame_fists:GetIntrinsicModifierName()
	return "modifier_elementalist_fire_elemental_flame_fists"
end