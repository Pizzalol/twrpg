elementalist_summon_earth_elemental = class({})

--[[ Author: Pizzalol
	Spawns a Earth Elemental unit under the casters control]]
function elementalist_summon_earth_elemental:OnSpellStart()
	local hCaster = self:GetCaster()
	local vTargetPosition = self:GetCursorPosition()

	-- Kill the old summon if it is still alive
	if hCaster.earth_elemental and IsValidEntity(hCaster.earth_elemental) then
		hCaster.earth_elemental:ForceKill(true)
	end

	-- Play the spawn sound and visual
	EmitSoundOn("Ability.LightStrikeArray", hCaster)

	local nSpawnFX = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
	ParticleManager:SetParticleControl(nSpawnFX, 0, vTargetPosition)
	ParticleManager:SetParticleControl(nSpawnFX, 1, Vector(100,0,0))
	ParticleManager:ReleaseParticleIndex(nSpawnFX)

	-- Spawn the earth Elemental
	hCaster.earth_elemental = CreateUnitByName("elementalist_earth_elemental", vTargetPosition, true, hCaster:GetPlayerOwner(), hCaster, hCaster:GetTeamNumber())
	hCaster.earth_elemental:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)

    --hCaster.earth_elemental:GetAbilityByIndex(0):SetActivated(false)
    --hCaster.earth_elemental:GetAbilityByIndex(1):SetActivated(false)
    --hCaster.earth_elemental:GetAbilityByIndex(2):SetActivated(false)
    --hCaster.earth_elemental:GetAbilityByIndex(3):SetActivated(false)
    --hCaster.earth_elemental:GetAbilityByIndex(3):OnOwnerSpawned() -- Required to activate the ability if the elemental has been linked
end