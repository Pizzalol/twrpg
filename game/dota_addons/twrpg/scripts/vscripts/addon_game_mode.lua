-- Generated from template
--require('util')
--require('physics')
--require('multiteam')
require('twrpg')
require('timers')
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
	PrecacheResource( "soundfile", "*.vsndevts", context )
	PrecacheResource( "particle_folder", "particles/frostivus_gameplay", context )
	PrecacheUnitByNameSync('npc_precache_everything', context)
end
-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = TWRPGGameMode()
	GameRules.AddonTemplate:InitGameMode()
	GameRules.AddonTemplate:CaptureGameMode()
end


