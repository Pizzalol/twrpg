--[[Author: Pizzalol
	Deals damage in intervals
	Checks if the target has enough mana to cast it, if it doesnt then it toggles the ability off
	otherwise it heals the caster and deals damage in a radius around it]]
function quake( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local mana_cost = ability:GetLevelSpecialValueFor("tick_cost", ability_level)
	local current_mana = caster:GetMana()

	-- Check if we have enough mana to cast it
	if mana_cost > current_mana then
		-- Toggle it off if we dont
		ability:ToggleAbility()
	else
		-- Ability variables
		local heal_amount = ability:GetLevelSpecialValueFor("heal_amount", ability_level)
		local base_damage = ability:GetLevelSpecialValueFor("base_damage", ability_level)
		local int_scale = ability:GetLevelSpecialValueFor("int_scale", ability_level)
		local radius = ability:GetLevelSpecialValueFor("radius", ability_level)

		-- Visuals
		local quake_particle = keys.quake_particle
		local sound = keys.sound

		-- Targeting variables
		local target_type = ability:GetAbilityTargetType()
		local target_flag = ability:GetAbilityTargetFlags()
		local target_team = ability:GetAbilityTargetTeam()

		-- Initialize the damage table
		local damage_table = {}
		damage_table.attacker = caster
		damage_table.ability = ability
		damage_table.damage_type = ability:GetAbilityDamageType()
		damage_table.damage = base_damage

		-- Spend the mana cost and heal the caster
		caster:SpendMana(mana_cost, ability)
		caster:Heal(heal_amount, caster)

		-- Play the sound and particle
		EmitSoundOn(sound, caster)

		local particle = ParticleManager:CreateParticle(quake_particle, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(particle, 1, Vector(radius,0,0))
		ParticleManager:ReleaseParticleIndex(particle)

		-- Find all the valid units and damage them
		local units_to_damage = FindUnitsInRadius(caster:GetTeam(), caster_location, nil, radius, target_team, target_type, target_flag, FIND_CLOSEST, false)

		for _,v in ipairs(units_to_damage) do
			damage_table.victim = v

			ApplyDamage(damage_table)
		end
	end
end