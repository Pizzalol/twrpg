--[[Author: Pizzalol
	Function is called on each attack to check if the hit goal is reached
	Upon reaching the hit goal, strike the target with thunder]]
function thunder_strike( keys )
	local caster = keys.caster
	local target = keys.target
	local target_location = target:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", ability_level) 
	local int_scale = ability:GetLevelSpecialValueFor("int_scale", ability_level) 
	local hits_needed = ability:GetLevelSpecialValueFor("hits_needed", ability_level) 
	local mana_gain = ability:GetLevelSpecialValueFor("mana_gain", ability_level) 

	-- Increment the hit count
	caster.thunder_hits = caster.thunder_hits + 1
	if caster.thunder_hits % hits_needed == 0 then
		-- Visual and sound
		local thunder_strike_particle = keys.thunder_strike_particle
		local sound = keys.sound

		-- Grant the mana
		caster:GiveMana(mana_gain)

		-- Initialize the damage table
		local damage_table = {}
		damage_table.attacker = caster
		damage_table.victim = target
		damage_table.damage_type = ability:GetAbilityDamageType() 
		damage_table.ability = ability
		damage_table.damage = 10 * int_scale

		-- Play visuals and sound
		local particle = ParticleManager:CreateParticle(thunder_strike_particle, PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControl(particle, 1, target_location + Vector(0,0,2000))
		ParticleManager:ReleaseParticleIndex(particle)

		EmitSoundOn(sound, target)

		-- Reset hit count and apply damage
		caster.thunder_hits = 0
		ApplyDamage(damage_table)
	end
end