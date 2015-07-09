--[[Author: igo95862, Noya
	Used by: Pizzalol
	Checks if the target is one of the 4 elementals owned by the caster]]
function elemental_link_check( keys )
	local caster = keys.caster
	local target = keys.target
	local player = caster:GetPlayerOwner()
	local playerID = caster:GetPlayerOwnerID()

	if target ~= caster.fire_elemental
		and target ~= caster.water_elemental
		and target ~= caster.lightning_elemental
		and target ~= caster.earth_elemental then

		caster:Stop()

		-- Play Error Sound
		EmitSoundOnClient("General.CastFail_InvalidTarget_Hero", player)

		-- This makes use of the Custom Error Flash module by zedor. https://github.com/zedor/CustomError
		FireGameEvent( 'custom_error_show', { player_ID = pID, _error = "Must target an Elemental that you own" } )
	end
end

--[[Author: Pizzalol
	Removes the old modifiers from the caster and linked target]]
function elemental_link_remove_old( keys )
	local caster = keys.caster
	local caster_modifier = keys.caster_modifier
	local target_modifier = keys.target_modifier

	-- Remove the modifier from the caster
	caster:RemoveModifierByName(caster_modifier) 

	-- Check if a linked target exists, if it does then remove the target modifier
	if caster.elemental_link_target and IsValidEntity(caster.elemental_link_target) then
		caster.elemental_link_target:RemoveModifierByName(target_modifier)
	end
end

--[[Author: Pizzalol
	Determine which elemental was linked, save it as the linked target and create the particle]]
function elemental_link_start( keys )
	local caster = keys.caster
	local target = keys.target
	local caster_location = caster:GetAbsOrigin() 
	local target_location = target:GetAbsOrigin()

	-- Particles
	local earth_particle = keys.earth_particle
	local fire_particle = keys.fire_particle
	local water_particle = keys.water_particle
	local lightning_particle = keys.lightning_particle

	-- Determine which elemental it was and choose the particle accordingly
	if target == caster.water_elemental then
		caster.elemental_link_particle = water_particle
	elseif target == caster.fire_elemental then
		caster.elemental_link_particle = fire_particle
	elseif target == caster.lightning_elemental then
		caster.elemental_link_particle = lightning_particle
	else
		caster.elemental_link_particle = earth_particle
	end

	-- Save the target as the link target
	caster.elemental_link_target = target

	-- Create the particle
	local particle = ParticleManager:CreateParticle(caster.elemental_link_particle, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster_location, false)
	ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, false)

	-- Save the particle so that we can destroy it later
	caster.elemental_link_particle = particle

	-- Activate the 4th elemental ability
	target:GetAbilityByIndex(3):SetActivated(true)
end

--[[Author: Pizzalol
	Reset and remove all the bonuses granted by the link]]
function elemental_link_end( keys )
	local caster = keys.caster
	local modifier = keys.modifier
	
	-- Remove the particle
	ParticleManager:DestroyParticle(caster.elemental_link_particle, false)
	ParticleManager:ReleaseParticleIndex(caster.elemental_link_particle)

	-- Remove the bonuses
	caster:RemoveModifierByName(modifier)
	caster.elemental_link_target:GetAbilityByIndex(3):SetActivated(false)
end

--[[Author: Pizzalol
	Remove the link modifier from the linked target upon the death of the caster]]
function elemental_link_death( keys )
	local caster = keys.caster
	local modifier = keys.modifier

	caster.elemental_link_target:RemoveModifierByName(modifier)
end

--[[Author: Pizzalol
	Checks if the leash distance has been broken]]
function elemental_link_distance( keys )
	local caster = keys.caster
	local target = keys.target
	local caster_location = caster:GetAbsOrigin() 
	local target_location = target:GetAbsOrigin() 
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local link_distance = ability:GetLevelSpecialValueFor("link_distance", ability_level)
	local modifier = keys.modifier

	-- Calculate the distance between the two linked targets
	local distance = (target_location - caster_location):Length2D()

	-- If the distance is greater than the leash distance then remove the link modifier
	if distance >= link_distance then
		target:RemoveModifierByName(modifier) 
	end
end

--[[Author: Pizzalol
	Calculates the prevented damage to share it with the linked elemental]]
function elemental_link_damage( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local damage_taken = keys.Damage
	local incoming_damage = ability:GetLevelSpecialValueFor("incoming_damage", ability_level) / 100

	-- Damage calculation
	local pre_reduction_damage = damage_taken / (1 + incoming_damage)
	local link_damage = pre_reduction_damage - damage_taken

	-- Initalize the damage table
	local damage_table = {}
	damage_table.attacker = attacker
	damage_table.victim = caster.elemental_link_target
	damage_table.ability = ability
	damage_table.damage_type = ability:GetAbilityDamageType() 
	damage_table.damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS
	damage_table.damage = link_damage

	ApplyDamage(damage_table)
end