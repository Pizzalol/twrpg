--[[Author: Pizzalol
	Upon activation it heals every unit within the radius for an amount equal to the specified
	caster HP percentage]]
function soul_of_the_forest_heal( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local heal_pct = ability:GetLevelSpecialValueFor("heal_pct", ability_level) / 100
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local caster_hp = caster:GetMaxHealth()
	local heal_amount = caster_hp * heal_pct

	-- Target variables
	local target_type = ability:GetAbilityTargetType()
	local target_team = ability:GetAbilityTargetTeam()
	local target_flags = ability:GetAbilityTargetFlags()

	-- Find the valid units and heal them
	local units_to_heal = FindUnitsInRadius(caster:GetTeam(), caster_location, nil, radius, target_team, target_type, target_flags, FIND_CLOSEST, false)

	for _,v in ipairs(units_to_heal) do
		v:Heal(heal_amount, caster)
	end
end