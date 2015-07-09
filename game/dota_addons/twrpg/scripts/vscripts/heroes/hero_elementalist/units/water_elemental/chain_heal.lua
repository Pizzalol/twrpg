
--[[Author: Pizzalol
	Chains from target to target, healing them to full

	Jump priority is
	1. Hurt heroes
	2. Hurt units
	3. Heroes
	4. Units]]
function chain_heal( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local target = keys.target
	local target_location = target:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local bounce_radius = ability:GetLevelSpecialValueFor("bounce_radius", ability_level)
	local max_targets = ability:GetLevelSpecialValueFor("max_targets", ability_level)
	local heal = target:GetMaxHealth()
	local unit_healed = false

	-- Particles
	local chain_heal_particle = keys.chain_heal_particle

	-- Setting up the hit table
	local hit_table = {}

	-- Mark the target as already hit
	table.insert(hit_table, target)
	-- Heal the initial target
	target:Heal(heal, caster)
	
	
	-- Priority is Hurt Heroes > Hurt Units > Heroes > Units
	-- we start from 2 first because we healed 1 target already
	for i = 2, max_targets do
		-- Helper variable to keep track if we healed a unit already
		unit_healed = false

		-- Find all the heroes in bounce radius
		local heroes = FindUnitsInRadius(caster:GetTeam(), target_location, nil, bounce_radius, ability:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_HERO, 0, FIND_CLOSEST, false)
		
		-- HURT HEROES --
		-- First we check for hurt heroes
		for _,unit in pairs(heroes) do
			local check_unit = 0	-- Helper variable to determine if a unit has been hit or not

			-- Checking the hit table to see if the unit is hit
			for c = 0, #hit_table do
				if hit_table[c] == unit then
					check_unit = 1
				end
			end

			-- If its not hit then check if the unit is hurt
			if check_unit == 0 then
				if unit:GetHealth() ~= unit:GetMaxHealth() then
					-- After we find the hurt hero unit then we insert it into the hit table to keep track of it
					-- and we also get the unit position
					table.insert(hit_table, unit)
					local unit_location = unit:GetAbsOrigin()

					-- Create the particle for the visual effect
					local particle = ParticleManager:CreateParticle(chain_heal_particle, PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
					ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit_location, true)

					-- Set the unit as the new target
					target = unit
					target_location = unit_location

					-- Heal it
					target:Heal(target:GetMaxHealth(), caster)

					-- Set the helper variable to true
					unit_healed = true

					-- Exit the loop for finding hurt heroes
					break
				end
			end
		end

		-- Find all the units in bounce radius
		local units = FindUnitsInRadius(caster:GetTeam(), target_location, nil, bounce_radius, ability:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL, 0, FIND_CLOSEST, false)
		
		-- HURT UNITS --
		-- check for hurt units if we havent healed a unit yet
		if not unit_healed then
			for _,unit in pairs(units) do
				local check_unit = 0	-- Helper variable to determine if the unit has been hit or not

				-- Checking the hit table to see if the unit is hit
				for c = 0, #hit_table do
					if hit_table[c] == unit then
						check_unit = 1
					end
				end

				-- If its not hit then check if the unit is hurt
				if check_unit == 0 then
					if unit:GetHealth() ~= unit:GetMaxHealth() then
						-- After we find the hurt hero unit then we insert it into the hit table to keep track of it
						-- and we also get the unit position
						table.insert(hit_table, unit)
						local unit_location = unit:GetAbsOrigin()

						-- Create the particle for the visual effect
						local particle = ParticleManager:CreateParticle(chain_heal_particle, PATTACH_CUSTOMORIGIN, caster)
						ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
						ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit_location, true)

						-- Set the unit as the new target
						target = unit
						target_location = unit_location

						-- Heal it
						target:Heal(target:GetMaxHealth(), caster)

						-- Set the helper variable to true
						unit_healed = true

						-- Exit the loop for finding hurt heroes
						break
					end
				end
			end
		end

		-- HEROES --
		-- In this loop we search for valid heroes regardless if it is hurt or not
		-- Search only if we havent healed a unit yet
		if not unit_healed then
			for _,unit in pairs(heroes) do
				local check_unit = 0	-- Helper variable to determine if a unit has been hit or not

				-- Checking the hit table to see if the unit is hit
				for c = 0, #hit_table do
					if hit_table[c] == unit then
						check_unit = 1
					end
				end

				-- If its not hit then do the bounce
				if check_unit == 0 then
					-- Insert the found unit into the hit table
					-- and we also get the unit position
					table.insert(hit_table, unit)
					local unit_location = unit:GetAbsOrigin()

					-- Create the particle for the visual effect
					local particle = ParticleManager:CreateParticle(chain_heal_particle, PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
					ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit_location, true)

					-- Set the unit as the new target
					target = unit
					target_location = unit_location

					-- Heal it
					target:Heal(target:GetMaxHealth(), caster)

					-- Set the helper variable to true
					unit_healed = true

					-- Exit the loop
					break				
				end
			end
		end

		-- UNITS --
		-- Search for units regardless if it is hurt or not
		-- Search only if we havent healed a unit yet
		if not unit_healed then
			for _,unit in pairs(units) do
				local check_unit = 0	-- Helper variable to determine if a unit has been hit or not

				-- Checking the hit table to see if the unit is hit
				for c = 0, #hit_table do
					if hit_table[c] == unit then
						check_unit = 1
					end
				end

				-- If its not hit then do the bounce
				if check_unit == 0 then
					-- Insert the found unit into the hit table
					-- and we also get the unit position
					table.insert(hit_table, unit)
					local unit_location = unit:GetAbsOrigin()

					-- Create the particle for the visual effect
					local particle = ParticleManager:CreateParticle(chain_heal_particle, PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
					ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit_location, true)

					-- Set the unit as the new target
					target = unit
					target_location = unit_location

					-- Heal it
					target:Heal(target:GetMaxHealth(), caster)

					-- Set the helper variable to true
					unit_healed = true

					-- Exit the loop for finding hurt heroes
					break				
				end
			end
		end
	end
end