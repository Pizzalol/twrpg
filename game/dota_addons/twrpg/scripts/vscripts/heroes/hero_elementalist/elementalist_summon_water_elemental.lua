--[[Author: Pizzalol
	Summons a Water Elemental]]
function SummonWaterElemental( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local ability_level_lua = ability_level + 1
	local player = caster:GetPlayerOwnerID()

	-- Abilities and modifiers
	local ability_1 = keys.ability_1
	local ability_2 = keys.ability_2
	local ability_3 = keys.ability_3
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
	if caster.water_elemental ~= nil and IsValidEntity(caster.water_elemental) then
		caster.water_elemental:ForceKill(true)
	end

	-- Creates the elemental and sets it to be controllable
	caster.water_elemental = CreateUnitByName("elementalist_water_elemental", position, true, caster, caster, caster:GetTeam())
	caster.water_elemental:SetControllableByPlayer(player, true)

	-- Sets the stats of the elemental
	caster.water_elemental:CreatureLevelUp(ability_level)
	caster.water_elemental:SetModelScale(model_scale)
	caster.water_elemental:SetMaxHealth(base_hp+hp_scale*caster_int) -- Add skill damage
	caster.water_elemental:SetHealth(caster.water_elemental:GetMaxHealth()) 

	caster.water_elemental:SetBaseDamageMin(elemenental_damage * 0.9)
	caster.water_elemental:SetBaseDamageMax(elemenental_damage * 1.1)

	-- Applying the duration modifier and particle modifier
	caster.water_elemental:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})
	ability:ApplyDataDrivenModifier(caster, caster.water_elemental, modifier, {})

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

	-- Adding abilities based on level
	caster.water_elemental:AddAbility(ability_1)
	if ability_level_lua >= 3 then
		caster.water_elemental:AddAbility(ability_2)
	end
	if ability_level >= 5 then
		caster.water_elemental:AddAbility(ability_3)
	end
end