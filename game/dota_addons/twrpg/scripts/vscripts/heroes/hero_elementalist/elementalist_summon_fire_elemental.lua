--[[Author: Pizzalol
	Date: 24.01.2015.
	Summons an elemental]]
function SummonFireElemental( keys )
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
	if caster.fire_elemental ~= nil and IsValidEntity(caster.fire_elemental) then
		caster.fire_elemental:ForceKill(true)
	end

	-- Creates the elemental and sets it to be controllable
	caster.fire_elemental = CreateUnitByName("elementalist_fire_elemental", position, true, caster, caster, caster:GetTeam())
	caster.fire_elemental:SetControllableByPlayer(player, true)

	-- Sets the stats of the elemental
	caster.fire_elemental:CreatureLevelUp(ability_level)
	caster.fire_elemental:SetModelScale(model_scale)
	caster.fire_elemental:SetMaxHealth(base_hp+hp_scale*caster_int) -- Add skill damage
	caster.fire_elemental:SetHealth(caster.fire_elemental:GetMaxHealth()) 

	caster.fire_elemental:SetBaseDamageMin(elemenental_damage * 0.9)
	caster.fire_elemental:SetBaseDamageMax(elemenental_damage * 1.1)

	-- Applying the duration modifier and particle modifier
	caster.fire_elemental:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})
	ability:ApplyDataDrivenModifier(caster, caster.fire_elemental, modifier, {})

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

	-- Disable abilities based on level
	if ability_level_lua < 3 then
		ability = caster.fire_elemental:FindAbilityByName(ability_1)
		ability:SetActivated(false)

		ability = caster.fire_elemental:FindAbilityByName(ability_2)
		ability:SetActivated(false)
	elseif ability_level_lua < 5 then
		ability = caster.fire_elemental:FindAbilityByName(ability_2)
		ability:SetActivated(false)
	end

	-- Always disable the ultimate ability
	ability = caster.fire_elemental:FindAbilityByName(ability_3)
	ability:SetActivated(false)
end