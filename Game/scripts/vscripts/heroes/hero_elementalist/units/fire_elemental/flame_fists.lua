--[[Author: Pizzalol
	Deals damage in an area around the target]]
function flame_fists( keys )
	local caster = keys.caster
	local target = keys.target
	local target_location = target:GetAbsOrigin() 
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level) 
	local int_scale = ability:GetLevelSpecialValueFor("int_scale", ability_level) 
	local base_damage = ability:GetLevelSpecialValueFor("base_damage", ability_level) 

	-- Targeting variables
	local target_team = ability:GetAbilityTargetTeam() 
	local target_type = ability:GetAbilityDamageType() 
	local target_flag = ability:GetAbilityTargetFlags()

	-- Initializing the damage table
	local damage_table = {}
	damage_table.attacker = caster
	damage_table.ability = ability
	damage_table.damage_type = ability:GetAbilityDamageType() 
	damage_table.damage = base_damage

	-- Find all the valid targets and damage them
	local flame_targets = FindUnitsInRadius(caster:GetTeam(), target_location, nil, radius, target_team, target_type, target_flag, FIND_CLOSEST, false)

	for _,unit in ipairs(flame_targets) do
		damage_table.victim = unit
		ApplyDamage(damage_table)
	end
end