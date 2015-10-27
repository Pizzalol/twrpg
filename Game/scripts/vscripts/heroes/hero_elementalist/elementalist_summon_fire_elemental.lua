elementalist_summon_fire_elemental = class({})

--[[ Author: Pizzalol
	Spawns a Fire Elemental unit under the casters control]]
function elementalist_summon_fire_elemental:OnSpellStart()
	local hCaster = self:GetCaster()
	local vTargetPosition = self:GetCursorPosition()

	-- Kill the old summon if it is still alive
	if hCaster.fire_elemental and IsValidEntity(hCaster.fire_elemental) then
		hCaster.fire_elemental:ForceKill(true)
	end

	-- Play the spawn sound and visual
	EmitSoundOn("Ability.LightStrikeArray", hCaster)

	local nSpawnFX = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
	ParticleManager:SetParticleControl(nSpawnFX, 0, vTargetPosition)
	ParticleManager:SetParticleControl(nSpawnFX, 1, Vector(100,0,0))
	ParticleManager:ReleaseParticleIndex(nSpawnFX)

	-- Spawn the Fire Elemental
	hCaster.fire_elemental = CreateUnitByName("elementalist_fire_elemental", vTargetPosition, true, hCaster:GetPlayerOwner(), hCaster, hCaster:GetTeamNumber())
	hCaster.fire_elemental:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)

	-- Attach the fire trail particle to the fire elemental
	local nTrailFX = ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster.fire_elemental)
    ParticleManager:SetParticleControl(nTrailFX, 2, Vector(1,0,0))
    ParticleManager:SetParticleControl(nTrailFX, 3, Vector(1,0,0))
    ParticleManager:SetParticleControl(nTrailFX, 6, Vector(1,0,0))

    --hCaster.fire_elemental:GetAbilityByIndex(0):SetActivated(false)
end