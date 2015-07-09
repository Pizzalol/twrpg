--[[Author: Pizzalol
	Deals damage around the caster and to the caster]]
function immolation_aura( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin() 
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level) 
	local base_damage = ability:GetLevelSpecialValueFor("base_damage", ability_level) 
	local int_scale = ability:GetLevelSpecialValueFor("int_scale", ability_level) 
	local hp_cost = ability:GetLevelSpecialValueFor("hp_cost", ability_level) / 100
	local blazing_haste_hp_cost = ability:GetLevelSpecialValueFor("blazing_haste_hp_cost", ability_level) / 100
	local modifier = keys.modifier

	-- Check for the Blazing Haste enhancement
	if caster:HasModifier(modifier) then
		hp_cost = blazing_haste_hp_cost
	end
	
	-- Initialize the damage table
	local damage_table = {}
	damage_table.attacker = caster
	damage_table.ability = ability
	damage_table.damage_type = ability:GetAbilityDamageType() 
	damage_table.damage = base_damage

	-- Targeting variables
	local target_team = ability:GetAbilityTargetTeam() 
	local target_type = ability:GetAbilityTargetType() 
	local target_flag = ability:GetAbilityTargetFlags() 

	-- Find the targets and deal damage to them
	local immolation_targets = FindUnitsInRadius(caster:GetTeam(), caster_location, nil, radius, target_team, target_type, target_flag, FIND_CLOSEST, false)

	for _,unit in ipairs(immolation_targets) do
		damage_table.victim = unit
		ApplyDamage(damage_table)
	end

	-- Deal non lethal damage to the caster
	damage_table.victim = caster
	damage_table.damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL
	damage_table.damage = caster:GetHealth() * hp_cost
	ApplyDamage(damage_table)
end