--[[Author: Pizzalol
	Deals damage depending on distance and kills the caster]]
function magma_explosion( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local radius_min = ability:GetLevelSpecialValueFor("radius_min", ability_level)
	local radius_max = ability:GetLevelSpecialValueFor("radius_max", ability_level) 

	-- Inside min radius damage = radius min damage - radius max
	-- radius max damage = radius max damage
	local int_scale_min = ability:GetLevelSpecialValueFor("int_scale_min", ability_level) -- Scaling smaller radius
	local int_scale_max = ability:GetLevelSpecialValueFor("int_scale_max", ability_level) -- Scaling bigger radius

	local damage_max = 10 * int_scale_max	-- Damage bigger radius
	local damage_min = (10 * int_scale_min) - damage_max -- Damage smaller radius

	-- Target variables
	local target_team = ability:GetAbilityTargetTeam()
	local target_type = ability:GetAbilityTargetType() 
	local target_flag = ability:GetAbilityTargetFlags()

	-- Initialize the damage table
	local damage_table = {}
	damage_table.attacker = caster
	damage_table.ability = ability
	damage_table.damage_type = ability:GetAbilityDamageType()

	-- Find the units inside the smaller radius
	local radius_min_targets = FindUnitsInRadius(caster:GetTeam(), caster_location, nil, radius_min, target_team, target_type, target_flag, FIND_CLOSEST, false)
	-- Find the units inside the bigger radius
	local radius_max_targets = FindUnitsInRadius(caster:GetTeam(), caster_location, nil, radius_max, target_team, target_type, target_flag, FIND_CLOSEST, false)

	-- Set the damage for the inner radius and deal it to each target
	damage_table.damage = damage_min
	for _,unit in ipairs(radius_min_targets) do
		damage_table.victim = unit
		ApplyDamage(damage_table)
	end

	-- Set the damage for the outer radius and deal it to each target
	damage_table.damage = damage_max
	for _,unit in ipairs(radius_max_targets) do
		damage_table.victim = unit
		ApplyDamage(damage_table)
	end

	-- Kill the caster
	caster:ForceKill(true)
end