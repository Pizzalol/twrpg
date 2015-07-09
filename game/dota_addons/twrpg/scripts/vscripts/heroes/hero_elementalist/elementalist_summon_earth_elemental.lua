--[[Author: Pizzalol
	Summons an Earth Elemental]]
function SummonEarthElemental( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local ability_level_lua = ability_level + 1
	local player = caster:GetPlayerOwnerID()

	-- Modifier	
	local modifier = keys.modifier

	-- Custom variables
	local position = keys.target_points[1]
	local caster_int = caster:GetIntellect()
	local elemenental_damage = ability_level_lua * caster_int

	-- Ability Special variables
	local model_scale = ability:GetLevelSpecialValueFor("model_scale", ability_level)
	local hp_scale = ability:GetLevelSpecialValueFor("hp_scale", ability_level)
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local base_hp = ability:GetLevelSpecialValueFor("base_hp", ability_level)
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)

	-- Checks if an elemental already exists
	if caster.earth_elemental ~= nil and IsValidEntity(caster.earth_elemental) then
		caster.earth_elemental:ForceKill(true)
	end

	-- Creates the elemental and sets it to be controllable
	caster.earth_elemental = CreateUnitByName("elementalist_earth_elemental", position, true, caster, caster, caster:GetTeam())
	caster.earth_elemental:SetControllableByPlayer(player, true)

	-- Sets the stats of the elemental
	caster.earth_elemental:CreatureLevelUp(ability_level)
	caster.earth_elemental:SetModelScale(model_scale)
	caster.earth_elemental:SetMaxHealth(base_hp+hp_scale*caster_int) -- Add skill damage
	caster.earth_elemental:SetHealth(caster.earth_elemental:GetMaxHealth()) 

	caster.earth_elemental:SetBaseDamageMin(elemenental_damage * 0.9)
	caster.earth_elemental:SetBaseDamageMax(elemenental_damage * 1.1)

	-- Applying the duration modifier and the elemental modifier
	caster.earth_elemental:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})
	ability:ApplyDataDrivenModifier(caster, caster.earth_elemental, modifier, {})

	-- Dreamgate enhancement
	if caster:HasModifier("modifier_dreamgate") then
		local damagetable = {}
		damagetable.attacker = caster
		damagetable.damage = 200
		damagetable.damage_type = DAMAGE_TYPE_MAGICAL

		local unitToDamage = FindUnitsInRadius(caster:GetTeam(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false)

		for i,v in ipairs(unitToDamage) do
			damagetable.victim = v
			ApplyDamage(damagetable)
			v:AddNewModifier(caster, nil, "modifier_stunned", {duration = 3})
		end
		caster:RemoveModifierByName("modifier_dreamgate")
	end

	-- Get the abilities
	local ability_1 = caster.earth_elemental:GetAbilityByIndex(1)
	local ability_2 = caster.earth_elemental:GetAbilityByIndex(2)
	local ability_3 = caster.earth_elemental:GetAbilityByIndex(3)

	-- Disable abilities based on level
	if ability_level_lua < 3 then
		ability_1:SetActivated(false)

		ability_2:SetActivated(false)
	elseif ability_level_lua < 5 then
		ability_2:SetActivated(false)
	end

	-- Always disable the ultimate ability
	ability_3:SetActivated(false)
end