elementalist_summon_fire_elemental = class({})

function elementalist_summon_fire_elemental:OnSpellStart()
	local hCaster = self:GetCaster()
	local vTargetPosition = self:GetCursorPosition()

	if hCaster.fire_elemental and IsValidEntity(hCaster.fire_elemental) then
		hCaster.fire_elemental:ForceKill(true)
	end

	hCaster.fire_elemental = CreateUnitByName("elementalist_fire_elemental", vTargetPosition, true, hCaster:GetPlayerOwner(), hCaster, hCaster:GetTeamNumber())
	hCaster.fire_elemental:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)

	local particle = ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster.fire_elemental)
    ParticleManager:SetParticleControl(particle, 2, Vector(1,0,0))
    ParticleManager:SetParticleControl(particle, 3, Vector(1,0,0))
    ParticleManager:SetParticleControl(particle, 6, Vector(1,0,0))

    hCaster.fire_elemental:GetAbilityByIndex(0):SetActivated(false)
end