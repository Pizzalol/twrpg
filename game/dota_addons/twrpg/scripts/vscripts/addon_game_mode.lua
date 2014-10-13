-- Generated from template
--require('util')
--require('physics')
--require('multiteam')
require('twrpg')
require('timers')
require("hero")
require("custom_abilities")
--[[if ReflexGameMode == nil then
print ( '[REFLEX] creating reflex game mode' )
ReflexGameMode = class({})
end]]
function Precache( context )
--[[
Precache things we know we'll use. Possible file types include (but not limited to):
PrecacheResource( "model", "*.vmdl", context )
PrecacheResource( "soundfile", "*.vsndevts", context )
PrecacheResource( "particle", "*.vpcf", context )
PrecacheResource( "particle_folder", "particles/folder", context )
]]
	PrecacheUnitByNameSync('npc_dota_hero_treant', context)
	PrecacheUnitByNameSync('npc_dota_hero_phoenix', context)
	PrecacheUnitByNameSync("npc_dota_hero_razor", context)
	PrecacheUnitByNameSync("npc_dota_hero_wisp", context)
	PrecacheUnitByNameSync("npc_dota_hero_enigma", context)
	PrecacheUnitByNameSync("npc_dota_hero_morphling", context)
	PrecacheUnitByNameSync("npc_dota_hero_magnataur", context)   
	PrecacheResource( "soundfile", "*.vsndevts", context )
	PrecacheResource( "particle_folder", "particles/frostivus_gameplay", context )
	PrecacheUnitByNameSync('npc_precache_everything', context)
	--Testing precaching
	PrecacheResource("particle_folder", "particles/units/heroes/hero_morphling/", context)
	PrecacheResource("model_folder", "models/heroes/morphling/", context)
	PrecacheResource("particle_folder", "particles/twrpg_gameplay", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_treant", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_sandking", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_zuus", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_enigma", context)
end
-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = TWRPGGameMode()
	GameRules.AddonTemplate:InitGameMode()
	--GameRules.AddonTemplate:CaptureGameMode()
end


