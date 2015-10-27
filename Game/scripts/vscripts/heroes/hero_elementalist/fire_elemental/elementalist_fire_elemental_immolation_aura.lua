elementalist_fire_elemental_immolation_aura = class({})
LinkLuaModifier("modifier_elementalist_fire_elemental_immolation_aura", "heroes/hero_elementalist/fire_elemental/modifiers/modifier_elementalist_fire_elemental_immolation_aura.lua", LUA_MODIFIER_MOTION_NONE)

--[[Author: Pizzalol
	Ability which applies and removes the damaging aura modifier]]
function elementalist_fire_elemental_immolation_aura:OnToggle() 
	if self:GetToggleState() then
		EmitSoundOn("Hero_EmberSpirit.FlameGuard.Cast", self:GetCaster())

		self.nImmolationFX = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
		ParticleManager:SetParticleControlEnt(self.nImmolationFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_origin", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.nImmolationFX, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_origin", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.nImmolationFX, 2, Vector(self:GetSpecialValueFor("radius"),self:GetSpecialValueFor("radius"),self:GetSpecialValueFor("radius")))

		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_elementalist_fire_elemental_immolation_aura", {})
	else
		local hImmolationModifier = self:GetCaster():FindModifierByName("modifier_elementalist_fire_elemental_immolation_aura")

		if hImmolationModifier then
			hImmolationModifier:Destroy()
			ParticleManager:DestroyParticle(self.nImmolationFX, true)
		end
	end
end