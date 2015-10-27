elementalist_fire_elemental_magma_explosion = class({})

--[[Author: Pizzalol
	Kills the caster and deals aoe damage based on distance from explosion location and the missing hp of the caster]]
function elementalist_fire_elemental_magma_explosion:OnSpellStart()
	local hCaster = self:GetCaster()
	local vLocation = hCaster:GetAbsOrigin()

	self.radius_min = self:GetSpecialValueFor("radius_min")
	self.radius_max = self:GetSpecialValueFor("radius_max")
	self.int_scale = self:GetSpecialValueFor("int_scale")
	self.base_damage = self:GetSpecialValueFor("base_damage")

	-- Ability sound and visuals
	EmitSoundOn("Hero_Techies.Suicide", hCaster)

	local nMagmaFX = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:ReleaseParticleIndex(nMagmaFX)

	local nTarget_team = self:GetAbilityTargetTeam() 
	local nTarget_type = self:GetAbilityTargetType() 
	local nTarget_flag = self:GetAbilityTargetFlags()

	local tDamage_table = {}
	tDamage_table.attacker = hCaster
	tDamage_table.damage_type = self:GetAbilityDamageType()
	tDamage_table.ability = self

	local tMagma_targets = FindUnitsInRadius(hCaster:GetTeamNumber(), vLocation, nil, self.radius_max, nTarget_team, nTarget_type, nTarget_flag, FIND_CLOSEST, false)

	for _,target in pairs(tMagma_targets) do
		local flDistance_coefficient = 1 -- Coefficient used to calculate distance damage
		local flDistance = (target:GetAbsOrigin() - vLocation):Length2D()

		-- If the distance between the two points is greater than the full damage radius then do the formula
		-- for damage outside the full damage zone
		if flDistance > self.radius_min then
			-- For values min 300 and max 600 the coefficient will be 0.5 at maximum distance
			flDistance_coefficient = 1 - ((flDistance - self.radius_min)/self.radius_max)
		end

		-- (Base_damage * Distance_coefficient) * Extra damage
		-- Extra damage is based on the casters missing HP
		-- e.g. if the caster has 1% HP remaining at the time of casting the ability then the ability will deal 99% more damage
		tDamage_table.damage = (self.base_damage * flDistance_coefficient) * (2 - hCaster:GetHealth()/hCaster:GetMaxHealth())
		tDamage_table.victim = target
		ApplyDamage(tDamage_table)
	end

	hCaster:ForceKill(true)
end