print("[twrpg] HeroClass loading")
if HeroClass == nil then
    HeroClass = {}
    HeroClass.__index = HeroClass
end

function HeroClass.create(playerId)
  local hero = {}
  setmetatable(hero,HeroClass)
  hero.playerId = playerId
  --hero.upgradePoints = 1
  hero.hasspawned = false
  --hero.abilityused = {}
  --hero.timesinceabilityused = {}
  --hero.timestouseability = {}
  hero.herounit = nil
  hero.death_time = 0
  hero.modelName = ""
  --hero.has_voted = false
  hero.pos_before_dc = nil
  hero.skill_damage = 0
  hero.has_max_level_timer = false
  --ENUMS
  return hero
end

function TWRPGGameMode:InitHero( spawnedUnit )
    print('Hero Spawned for the first time, id=' .. spawnedUnit:GetPlayerOwnerID())
    HeroArray[ spawnedUnit:GetPlayerOwnerID() ] = HeroClass.create( spawnedUnit:GetPlayerOwnerID() )
    --Add the unit for easy acces in other functions
    HeroArray[spawnedUnit:GetPlayerOwnerID()].herounit = spawnedUnit

    --Set starting gold to 0
    spawnedUnit:SetGold(5000, false)

    HeroArray[spawnedUnit:GetPlayerOwnerID()].hasspawned = true
    HeroArray[spawnedUnit:GetPlayerOwnerID()].pos_before_dc = spawnedUnit:GetAbsOrigin()
    --PudgeWarsMode:UpdateUpgradePoints(spawnedUnit)


    --[[PudgeWarsMode:CreateTimer(DoUniqueString("noabilitypoints"), {
	endTime = GameRules:GetGameTime() + 0.1,
	useGameTime = true,
	callback = function(reflex, args)
	    spawnedUnit:SetAbilityPoints(0)
	    return GameRules:GetGameTime()
	end
    })]]
end
