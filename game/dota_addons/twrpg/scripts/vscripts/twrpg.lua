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

function TWRPGGameMode:InitGameMode()
	print( "Template addon is loaded." )
end

GameMode = nil

function TWRPGGameMode:new( o )
	print ( '[twrpg] TWRPGGameMode:new' )
	o = o or {}
	setmetatable( o, TWRPGGameMode )
	return o
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
		GameRules:SetHeroMinimapIconSize( 300 )
		--print( '[BAREBONES] Beginning Think' )
		--GameMode:SetContextThink("BarebonesThink", Dynamic_Wrap( TWRPGGameMode, 'Think' ), 0.1 )
		--GameRules:GetGameModeEntity():SetThink( "Think", self, "GlobalThink", 2 )
	end
end