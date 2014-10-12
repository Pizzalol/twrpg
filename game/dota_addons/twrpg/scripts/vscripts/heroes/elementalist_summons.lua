require('heroes/elementalist')


function KillSummon( keys )
	local caster = keys.caster
	caster:ForceKill(true) --[[Returns:void
	Kill this unit immediately.
	]]
	print("ded summon")
end




-- Fire Elemental

function SummonFireElemental(keys)
	local caster = keys.caster
	local level = keys.ability:GetLevel()
	local player = caster:GetPlayerOwner()
	local team = caster:GetTeamNumber() 
	local heroloc = caster:GetAbsOrigin() 
	local target = keys.target_points[1]
	local modelScale = keys.ModelScale
	local HPScale = keys.HPScale
	local baseHP = keys.BaseHP
	local casterInt = caster:GetIntellect()
	local elemental
	print(modelScale)
	print(HPScale)

	-- Check if the elemental exists already
	elemental = CheckElemental(caster,fire)
	if elemental ~= nil then
		elemental:ForceKill(true)
	end

	local fireelemental = CreateUnitByName("elementalist_fire_elemental", target, true, caster, caster, team)
	fireelemental:SetControllableByPlayer(caster:GetPlayerID(), true) 
	fireelemental:CreatureLevelUp(level-1)
	fireelemental:SetModelScale(modelScale)
	fireelemental:SetMaxHealth(baseHP+HPScale*casterInt)
	fireelemental:SetHealth(fireelemental:GetMaxHealth())

	if caster:HasModifier("modifier_dreamgate") then
		local damagetable = {}
		damagetable.attacker = caster
		damagetable.damage = 200
		damagetable.damage_type = DAMAGE_TYPE_MAGICAL

		local unitToDamage = FindUnitsInRadius(caster:GetTeam(), target, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false)

		for i,v in ipairs(unitToDamage) do
			damagetable.victim = v
			ApplyDamage(damagetable)
			v:AddNewModifier(caster, nil, "modifier_stunned", {duration = 3})
		end
		caster:RemoveModifierByName("modifier_dreamgate")
	end

	if level == 2 then
		fireelemental:SetBaseDamageMin(228) 
		fireelemental:SetBaseDamageMax(236)
	elseif level >= 3 then
		fireelemental:AddAbility("elementalist_fire_elemental_immolation_aura_ability")
		fireAbility = fireelemental:FindAbilityByName("elementalist_fire_elemental_immolation_aura_ability")
		fireAbility:SetLevel(1) 
		fireelemental:SetBaseDamageMin(1038) 
		fireelemental:SetBaseDamageMax(1046)
	end
	if level == 4 then
		fireelemental:SetBaseDamageMin(1788) 
		fireelemental:SetBaseDamageMax(1796) 
	elseif level >= 5 then
		fireelemental:AddAbility("elementalist_fire_elemental_magma_explosion_ability") 
		fireAbility = fireelemental:FindAbilityByName("elementalist_fire_elemental_magma_explosion_ability")
		fireAbility:SetLevel(1)
		fireelemental:SetBaseDamageMin(2538)
		fireelemental:SetBaseDamageMax(2546) 
	end
end

--Earth Elemental

function SummonEarthElemental(keys)
	local caster = keys.caster
	local level = keys.ability:GetLevel()
	local player = caster:GetPlayerOwner()
	local team = caster:GetTeamNumber() 
	local heroloc = caster:GetAbsOrigin() 
	local target = keys.target_points[1]
	local modelScale = keys.ModelScale
	local HPScale = keys.HPScale
	local baseHP = keys.BaseHP
	local casterInt = caster:GetIntellect()
	local earthAbility
	

	-- Check if the elemental exists already
	elemental = CheckElemental(caster,earth)
	if elemental ~= nil then
		elemental:ForceKill(true)
	end

	local earthelemental = CreateUnitByName("elementalist_earth_elemental", target, true, caster, caster, team)
	earthelemental:SetControllableByPlayer(caster:GetPlayerID() , true)	
	earthelemental:SetModelScale(modelScale)
	earthelemental:SetMaxHealth(baseHP+casterInt*HPScale)
	earthelemental:SetHealth(earthelemental:GetMaxHealth())
	earthelemental:CreatureLevelUp(level-1)
	earthelemental:SetBaseDamageMin(level*1000+243)
	earthelemental:SetBaseDamageMax(level*1000+263)

	if level >= 3 then
	 	earthelemental:AddAbility("elementalist_earth_elemental_taunt_ability")
	 	earthAbility = earthelemental:FindAbilityByName("elementalist_earth_elemental_taunt_ability")
	 	earthAbility:SetLevel(1)
	end
	if level >= 5 then
		earthelemental:AddAbility("elementalist_earth_elemental_ground_shake_ability")
		earthAbility = earthelemental:FindAbilityByName("elementalist_earth_elemental_ground_shake_ability")
		earthAbility:SetLevel(1)
	end
	

end

function SummonLightningElemental(keys)
	local caster = keys.caster
	local level = keys.ability:GetLevel()
	local player = caster:GetPlayerOwner()
	local team = caster:GetTeamNumber() 
	local heroloc = caster:GetAbsOrigin() 
	local target = keys.target_points[1]
	local modelScale = keys.ModelScale
	local HPScale = keys.HPScale
	local baseHP = keys.BaseHP
	local casterInt = caster:GetIntellect()
	print(modelScale)
	print(HPScale)

	-- Check if the elemental exists already
	elemental = CheckElemental(caster,lightning)
	if elemental ~= nil then
		elemental:ForceKill(true)
	end

	local lightningelemental = CreateUnitByName("elementalist_lightning_elemental", target, true, caster, caster, team)
	lightningelemental:SetControllableByPlayer(caster:GetPlayerID(), true) 
	lightningelemental:CreatureLevelUp(level-1)
	lightningelemental:SetModelScale(modelScale)
	lightningelemental:SetMaxHealth(baseHP+HPScale*casterInt)
	lightningelemental:SetHealth(lightningelemental:GetMaxHealth())
	lightningelemental:SetMana(0)

	-- Dreamgate chain bonus
	if caster:HasModifier("modifier_dreamgate") then
		local dummyUnit = CreateUnitByName("npc_dummy_unit", target, false, nil, nil, team)
		dummyUnit:AddNewModifier(dummyUnit, nil, "modifier_phased", {}) 
		local dummyAbility = dummyUnit:FindAbilityByName("dummy_unit")
		dummyAbility:SetLevel(1)

		dummyUnit:AddAbility("dummy_unit_lightning_armor_reduction") 
		local dummyDreamgateAbility = dummyUnit:FindAbilityByName("dummy_unit_lightning_armor_reduction") 
		dummyDreamgateAbility:SetLevel(level) 
		Timers:CreateTimer(0.01, function()
		dummyUnit:CastAbilityNoTarget(dummyDreamgateAbility, 0) 
		print("Timer 1")
		Timers:CreateTimer(2, function()
			dummyUnit:RemoveSelf() 
			print("Timer 2")
			end)
		end)

		local unitToStun = FindUnitsInRadius(team, target, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false) 

		for _,v in ipairs(unitToStun) do
			v:AddNewModifier(caster, nil, "modifier_stunned", {duration = 6}) 
		end

		caster:RemoveModifierByName("modifier_dreamgate") 
	end

	if level == 2 then
		lightningelemental:SetBaseDamageMin(776) 
		lightningelemental:SetBaseDamageMax(784)
	elseif level >= 3 then
		lightningelemental:AddAbility("elementalist_lightning_elemental_chain_lightning_ability")
		lightningAbility = lightningelemental:FindAbilityByName("elementalist_lightning_elemental_chain_lightning_ability")
		lightningAbility:SetLevel(1) 
		lightningelemental:SetBaseDamageMin(1526) 
		lightningelemental:SetBaseDamageMax(1534)
	end
	if level == 4 then
		lightningelemental:SetBaseDamageMin(2276) 
		lightningelemental:SetBaseDamageMax(2284) 
	elseif level >= 5 then
		lightningelemental:AddAbility("elementalist_lightning_elemental_lightning_current_ability") 
		lightningAbility = lightningelemental:FindAbilityByName("elementalist_lightning_elemental_lightning_current_ability")
		lightningAbility:SetLevel(1)
		lightningelemental:SetBaseDamageMin(3026)
		lightningelemental:SetBaseDamageMax(3034) 
	end
end


function SummonWaterElemental(keys)
	local caster = keys.caster
	local level = keys.ability:GetLevel()
	local player = caster:GetPlayerOwner()
	local team = caster:GetTeamNumber() 
	local heroloc = caster:GetAbsOrigin() 
	local target = keys.target_points[1]
	local modelScale = keys.ModelScale
	local HPScale = keys.HPScale
	local baseHP = keys.BaseHP
	local casterInt = caster:GetIntellect()
	print(modelScale)
	print(HPScale)

	-- Check if the elemental exists already
	elemental = CheckElemental(caster,water)
	if elemental ~= nil then
		elemental:ForceKill(true)
	end

	local waterelemental = CreateUnitByName("elementalist_water_elemental", target, true, caster, caster, team)
	waterelemental:SetControllableByPlayer(caster:GetPlayerID(), true) 
	waterelemental:CreatureLevelUp(level-1)
	waterelemental:SetModelScale(modelScale)
	waterelemental:SetMaxHealth(baseHP+HPScale*casterInt)
	waterelemental:SetHealth(waterelemental:GetMaxHealth())

	if caster:HasModifier("modifier_dreamgate") then
		local dummyUnit = CreateUnitByName("npc_dummy_unit", target, false, nil, nil, team)
		dummyUnit:AddNewModifier(dummyUnit, nil, "modifier_phased", {}) 
		--local dummyAbility = dummyUnit:FindAbilityByName("dummy_unit")
		--dummyAbility:SetLevel(1)

		dummyUnit:AddAbility("dummy_unit_water_well") 
		local dummyDreamgateAbility = dummyUnit:FindAbilityByName("dummy_unit_water_well")
		dummyDreamgateAbility:SetLevel(1)

		Timers:CreateTimer(0.01, function()
		dummyUnit:CastAbilityNoTarget(dummyDreamgateAbility, 0) 
		print("Healing well 1")
		Timers:CreateTimer(6.5, function()
			dummyUnit:RemoveSelf() 
			print("Healing well 2")
			end)
		end)

		caster:RemoveModifierByName("modifier_dreamgate")
	end

	local damage_temp
	if level > 1 then
		damage_temp = level - 2
		waterelemental:SetBaseDamageMin(209 + 300*damage_temp)
		waterelemental:SetBaseDamageMax(213 + 300*damage_temp)
	end

	if level >= 3 then
		waterelemental:AddAbility("elementalist_water_elemental_purification_ability")
		waterAbility = waterelemental:FindAbilityByName("elementalist_water_elemental_purification_ability")
		waterAbility:SetLevel(1)
	end
	if level >= 5 then
		print("Give me chain heal")
		waterelemental:AddAbility("elementalist_water_elemental_chain_heal_ability")
		waterAbility = waterelemental:FindAbilityByName("elementalist_water_elemental_chain_heal_ability")
		waterAbility:SetLevel(1)
	end
end

function SummonShadowElemental(keys)
	local caster = keys.caster
	local level = keys.ability:GetLevel()
	local player = caster:GetPlayerOwner()
	local team = caster:GetTeamNumber() 
	local heroloc = caster:GetAbsOrigin() 
	local target = keys.target_points[1]
	local modelScale = keys.ModelScale
	local HPScale = keys.HPScale
	local baseHP = keys.BaseHP
	local casterInt = caster:GetIntellect()

	local elemental = {}
	elemental.fire = CheckElemental(caster,fire)
	if elemental.fire then elemental.fireDistance = (elemental.fire:GetAbsOrigin() - target):Length2D()
	end

	elemental.earth = CheckElemental(caster,earth)
	if elemental.earth then elemental.earthDistance = (elemental.earth:GetAbsOrigin() - target):Length2D()
	end

	elemental.water = CheckElemental(caster,water)
	if elemental.water then elemental.waterDistance = (elemental.water:GetAbsOrigin() - target):Length2D() 
	end

	elemental.lightning = CheckElemental(caster,lightning)
	if elemental.lightning then elemental.lightningDistance = (elemental.lightning:GetAbsOrigin() - target):Length2D() 
	end

	print(modelScale)
	print(HPScale)

	if (elemental.fire and elemental.fireDistance <= 1000) and 
		(elemental.earth and elemental.earthDistance <= 1000) and
		(elemental.water and elemental.waterDistance <= 1000) and
		(elemental.lightning and elemental.lightningDistance <= 1000) then

		elemental.fire:ForceKill(true)
		elemental.water:ForceKill(true)
		elemental.earth:ForceKill(true)
		elemental.lightning:ForceKill(true) 

		local shadowelemental = CreateUnitByName("elementalist_shadow_elemental", target, true, caster, caster, team)
		shadowelemental:SetControllableByPlayer(caster:GetPlayerID(), true) 
		shadowelemental:CreatureLevelUp(level-1)
		shadowelemental:SetModelScale(modelScale)
		shadowelemental:SetMaxHealth(baseHP+HPScale*casterInt)
		shadowelemental:SetHealth(shadowelemental:GetMaxHealth())

		shadowelemental:AddNewModifier(caster, nil, "modifier_stunned", {duration = 5})
		shadowelemental:AddNewModifier(caster, nil, "modifier_invulnerable", {duration = 5}) 
	else
		caster:AddSpeechBubble(1,"Need all elementals present", 5.0, 50, -10)
	end
end



