--[[Author: Pizzalol
	Increases attack speed if attacking the same target over and over]]
function blazing_haste( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier = keys.modifier
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability_level)

	-- Check if we have an old target
	if caster.blazing_haste_target then
		-- Check if that old target is the same as the attacked target
		if caster.blazing_haste_target == target then
			-- Check if the caster has the attack speed modifier
			if caster:HasModifier(modifier) then
				-- Get the current stacks
				local stack_count = caster:GetModifierStackCount(modifier, ability)

				-- Check if the current stacks are lower than the maximum allowed
				if stack_count < max_stacks then
					-- Increase the count if they are
					caster:SetModifierStackCount(modifier, ability, stack_count + 1)
				end
			else
				-- Apply the attack speed modifier and set the starting stack number
				ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
				caster:SetModifierStackCount(modifier, ability, 1)
			end
		else
			-- If its not the same target then set it as the new target and remove the modifier
			caster:RemoveModifierByName(modifier)
			caster.blazing_haste_target = target
		end
	else
		caster.blazing_haste_target = target
	end
end

function blazing_haste_explosion( keys )
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
end