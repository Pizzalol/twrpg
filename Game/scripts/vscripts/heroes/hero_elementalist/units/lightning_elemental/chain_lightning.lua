--[[Author: Pizzalol
	Launches a chain lightning every set number of attacks]]
function chain_lightning( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin() 
	local target = keys.target
	local target_location = target:GetAbsOrigin() 
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local max_targets = ability:GetLevelSpecialValueFor("max_targets", ability_level) 
	local int_scale = ability:GetLevelSpecialValueFor("int_scale", ability_level) 
	local hits_needed = ability:GetLevelSpecialValueFor("hits_needed", ability_level) 
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level) 
	local mana_gain = ability:GetLevelSpecialValueFor("mana_gain", ability_level) 
	local reduction = ability:GetLevelSpecialValueFor("reduction", ability_level) / 100
	local jump_radius = ability:GetLevelSpecialValueFor("jump_radius", ability_level)
	local modifier = keys.modifier

	-- Increase the hit count
	caster.lightning_hits = caster.lightning_hits + 1

	-- Check if we did the required number of attacks
	if caster.lightning_hits % hits_needed == 0 then
		-- Sound and visual
		local sound = keys.sound
		local chain_lightning_particle = keys.chain_lightning_particle

		-- Grant the mana to the caster
		caster:GiveMana(mana_gain) 

		-- Initialize the damage and hit tables
		local hit_table = {}
		local damage_table = {}
		damage_table.attacker = caster
		damage_table.victim = target
		damage_table.ability = ability
		damage_table.damage_type = ability:GetAbilityDamageType() 
		damage_table.damage = 10 * int_scale

		table.insert(hit_table, target)

		-- Searching variables
		local target_types = ability:GetAbilityTargetType() 
		local target_teams = ability:GetAbilityTargetTeam() 
		local target_flags = ability:GetAbilityTargetFlags() 

		-- Play the visual and sound
		EmitSoundOn(sound, target) 

		local particle = ParticleManager:CreateParticle(chain_lightning_particle, PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster_location, false)
		ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, false)
		ParticleManager:ReleaseParticleIndex(particle)

		-- Apply the modifier and the damage
		ability:ApplyDataDrivenModifier(caster, target, modifier, {Duration = duration}) 
		ApplyDamage(damage_table)

		-- Start jumping to other targets, starting from 2 because we hit the original target already
		for i = 2, max_targets do
			-- Find valid targets in the radius
			local jump_targets = FindUnitsInRadius(caster:GetTeam(), target_location, nil, jump_radius, target_teams, target_types, target_flags, FIND_CLOSEST, false)
			for _,unit in ipairs(jump_targets) do
				local hit_check = false

				-- Check if the unit has been hit before
				for j = 0, #hit_table do
					if hit_table[j] == unit then
						hit_check = true
						break
					end
				end

				-- If it hasnt then jump to it
				if not hit_check then
					-- Adjust the tables for the new target
					table.insert(hit_table, unit)
					damage_table.damage = damage_table.damage * reduction
					damage_table.victim = unit

					-- Get the new jump location
					local unit_location = unit:GetAbsOrigin()

					-- Play the visual and sound
					EmitSoundOn(sound, unit) 

					local particle = ParticleManager:CreateParticle(chain_lightning_particle, PATTACH_CUSTOMORIGIN, unit)
					ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, false)
					ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit_location, false)
					ParticleManager:ReleaseParticleIndex(particle)

					-- Apply the modifier and damage to the new unit
					ability:ApplyDataDrivenModifier(caster, unit, modifier, {Duration = duration}) 
					ApplyDamage(damage_table) 

					-- Save the unit for the next jump
					target = unit
					target_location = unit_location
					break
				end
			end
		end
		-- Reset the count
		caster.lightning_hits = 0
	end
end