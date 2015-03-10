--[[Author: Pizzalol
	Triggers on interval to launch a projectile if the caster has enough mana]]
function discharge( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin() 
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Visuals
	local sound = keys.sound
	local modifier = keys.modifier
	local projectile_particle = keys.projectile_particle

	-- Ability variables
	local mana_cost = ability:GetLevelSpecialValueFor("mana_cost", ability_level) 
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level) 
	local range = ability:GetLevelSpecialValueFor("range", ability_level) 
	local discharge_speed = ability:GetLevelSpecialValueFor("discharge_speed", ability_level) 
	local discharge_interval = ability:GetLevelSpecialValueFor("discharge_interval", ability_level) - 0.06

	-- If the caster doesnt have enough mana then turn off the ability
	if caster:GetMana() < mana_cost then
		ability:ToggleAbility()
	else
		-- Otherwise spend the mana
		caster:SpendMana(mana_cost, ability) 

		-- Play the sound
		EmitSoundOn(sound, caster) 

		-- Apply the animation modifier
		ability:ApplyDataDrivenModifier(caster, caster, modifier, {duration = discharge_interval})

		-- Create projectile
		local projectileTable =
		{
			EffectName = projectile_particle,
			Ability = ability,
			vSpawnOrigin = caster_location,
			vVelocity = caster:GetForwardVector() * discharge_speed,
			fDistance = range,
			fStartRadius = radius,
			fEndRadius = radius,
			Source = caster,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = ability:GetAbilityTargetTeam(),
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = ability:GetAbilityTargetType()
		}
		ProjectileManager:CreateLinearProjectile( projectileTable )
	end
end

--[[Author: Pizzalol
	Triggers upon being hit by a discharge projectile
	Deals damage to those hit by it]]
function discharge_hit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local int_scale = ability:GetLevelSpecialValueFor("int_scale", ability_level) 

	local damage_table = {}
	damage_table.attacker = caster
	damage_table.victim = target
	damage_table.ability = ability
	damage_table.damage_type = ability:GetAbilityDamageType() 
	damage_table.damage = 10 * int_scale

	ApplyDamage(damage_table)
end

--[[Author: Pizzalol
	Triggers when an order is issued
	Toggles the ability off if it is on]]
function discharge_order( keys )
	local ability = keys.ability

	Timers:CreateTimer(0.03, function()
		if ability:GetToggleState() then
			ability:ToggleAbility() 
		end
	end)
end