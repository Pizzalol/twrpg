print ('[twrpg] twrpg.lua' )

DEBUG=true
USE_LOBBY=false
THINK_TIME = 0.1

STARTING_GOLD = 500--650
MAX_LEVEL = 410

-- Fill this table up with the required XP per level if you want to change it
XP_PER_LEVEL_TABLE = {}
for i=1,MAX_LEVEL do
	XP_PER_LEVEL_TABLE[i] = i * 100
end

-- Generated from template
if TWRPGGameMode == nil then
	print ( '[twrpg] creating twrpg game mode' )
	--TWRPGGameMode = {}
	--TWRPGGameMode.szEntityClassName = "twrpg"
	--TWRPGGameMode.szNativeClassName = "dota_base_game_mode"
	--TWRPGGameMode.__index = TWRPGGameMode
	TWRPGGameMode = class({})
end

--[[function TWRPGGameMode:InitGameMode()
	print( "Template addon is loaded." )
end]]

GameMode = nil

function TWRPGGameMode:new( o )
	print ( '[twrpg] TWRPGGameMode:new' )
	o = o or {}
	setmetatable( o, TWRPGGameMode )
	return o
end

--[[function TWRPGGameMode:OnEntityHurt(keys)
	print("[BAREBONES] Entity Hurt")
	DeepPrintTable(keys)
	local entCause = EntIndexToHScript(keys.entindex_attacker)
	local entVictim = EntIndexToHScript(keys.entindex_killed)
end]]

function TWRPGGameMode:OnPlayerPicked( keys )
	local spawnedUnit = keys.hero
	local spawnedUnitIndex = EntIndexToHScript(keys.heroindex)

	if spawnedUnitIndex:GetClassname() == "npc_dota_hero_enchantress" then
		spawnedUnitIndex:GetAbilityByIndex(3):SetLevel(1)
	end
end

function TWRPGGameMode:OnPlayerLeveledUp( keys )
	local player = keys.player - 1
	if PlayerResource:IsValidPlayer(player) then
		local hero = PlayerResource:GetSelectedHeroEntity(player) 
		local level = hero:GetLevel()
		print(level)
		if level % 40 == 0 and level <= 320 then
			local abilityLevel = (level/40) + 1
			hero:GetAbilityByIndex(3):SetLevel(abilityLevel)
		end
	else
		print("Invalid player!")
	end
end

function TWRPGGameMode:InitGameMode()
	TWRPGGameMode = self
	print('[twrpg] Starting to load twrpg gamemode...')
	-- Setup rules
	GameRules:SetHeroRespawnEnabled( true )
	GameRules:SetUseUniversalShopMode( true )
	GameRules:SetSameHeroSelectionEnabled( false )
	GameRules:SetHeroSelectionTime( 180.0 )
	GameRules:SetPreGameTime( 120.0)
	GameRules:SetPostGameTime( 60.0 )
	GameRules:SetTreeRegrowTime( 60.0 )
	GameRules:SetUseCustomHeroXPValues ( true )
	GameRules:SetGoldPerTick(0)

	--ListenToGameEvent('entity_hurt', Dynamic_Wrap(TWRPGGameMode, 'OnEntityHurt'), self)
	--ListenToGameEvent( "npc_spawned", Dynamic_Wrap( TWRPGGameMode, "OnNPCSpawned" ), self )
	ListenToGameEvent( "dota_player_pick_hero", Dynamic_Wrap( TWRPGGameMode, "OnPlayerPicked" ), self )
	--ListenToGameEvent( "player_reconnected", Dynamic_Wrap( TWRPGGameMode, 'OnPlayerReconnected' ), self )
	--ListenToGameEvent( "entity_killed", Dynamic_Wrap( TWRPGGameMode, 'OnEntityKilled' ), self )
	--ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( TWRPGGameMode, "OnGameRulesStateChange" ), self )
	--ListenToGameEvent( "player_stats_updated", Dynamic_Wrap(TWRPGGameMode, 'OnPlayerStatsUpdated'), self)
	--ListenToGameEvent( "dota_player_learned_ability", Dynamic_Wrap(TWRPGGameMode, 'OnPlayerLearnedAbility'), self)
	ListenToGameEvent( "dota_player_gained_level", Dynamic_Wrap(TWRPGGameMode, 'OnPlayerLeveledUp'), self)
	--ListenToGameEvent( "dota_inventory_changed", Dynamic_Wrap(TWRPGGameMode, 'OnInventoryChanged'), self)
	--ListenToGameEvent( "dota_item_purchased", Dynamic_Wrap(TWRPGGameMode, 'OnItemPurchased'), self)
	--ListenToGameEvent( "dota_player_used_ability", Dynamic_Wrap(TWRPGGameMode, 'OnAbilityCast'), self)
	--ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap(TWRPGGameMode, 'OnItemPickedUp'), self)

	print('[twrpg] Rules set')
end

--[[function TWRPGGameMode:CaptureGameMode()
	if GameMode == nil then
		-- Set GameMode parameters
		GameMode = GameRules:GetGameModeEntity()
		-- Disables recommended items...though I don't think it works
		GameMode:SetRecommendedItemsDisabled( true )
		-- Override the normal camera distance. Usual is 1134
		GameMode:SetCameraDistanceOverride( 1504.0 )
		-- Set Buyback options
		GameMode:SetCustomBuybackCostEnabled( true )
		GameMode:SetCustomBuybackCooldownEnabled( true )
		GameMode:SetBuybackEnabled( false )
		-- Override the top bar values to show your own settings instead of total deaths
		GameMode:SetTopBarTeamValuesOverride ( true )
		-- Use custom hero level maximum and your own XP per level
		GameMode:SetUseCustomHeroLevels ( true )
		GameMode:SetCustomHeroMaxLevel ( MAX_LEVEL )
		GameMode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )
		-- Chage the minimap icon size
		GameRules:SetHeroMinimapIconSize( 300 )
	end
end]]--

function TWRPGGameMode:CaptureGameMode()
	if GameMode == nil then
		-- Set GameMode parameters
		GameMode = GameRules:GetGameModeEntity()
		-- Disables recommended items...though I don't think it works
		GameMode:SetRecommendedItemsDisabled( true )
		-- Override the normal camera distance. Usual is 1134
		GameMode:SetCameraDistanceOverride( 1504.0 )
		-- Set Buyback options
		GameMode:SetCustomBuybackCostEnabled( true )
		GameMode:SetCustomBuybackCooldownEnabled( true )
		GameMode:SetBuybackEnabled( false )
		-- Override the top bar values to show your own settings instead of total deaths
		GameMode:SetTopBarTeamValuesOverride ( true )
		-- Use custom hero level maximum and your own XP per level
		GameMode:SetUseCustomHeroLevels ( true )
		GameMode:SetCustomHeroMaxLevel ( MAX_LEVEL )
		--GameMode:SetCustomHeroMaxLevel( 410 )
		GameMode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )
		-- Chage the minimap icon size
		GameRules:SetHeroMinimapIconScale( 2 )
		--print( '[BAREBONES] Beginning Think' )
		--GameMode:SetContextThink("BarebonesThink", Dynamic_Wrap( TWRPGGameMode, 'Think' ), 0.1 )
		--GameRules:GetGameModeEntity():SetThink( "Think", self, "GlobalThink", 2 )
	end
end