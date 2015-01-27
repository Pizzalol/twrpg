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
	PrecacheUnitByNameSync('elementalist_fire_elemental', context)
	PrecacheUnitByNameSync('elementalist_water_elemental', context)
	PrecacheUnitByNameSync('elementalist_lightning_elemental', context)
	PrecacheUnitByNameSync('elementalist_earth_elemental', context)
	PrecacheUnitByNameSync('elementalist_shadow_elemental', context)
	PrecacheResource("particle_folder", "particles/twrpg_gameplay", context)
end
-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = TWRPGGameMode()
	GameRules.AddonTemplate:InitGameMode()
	--GameRules.AddonTemplate:CaptureGameMode()
end


