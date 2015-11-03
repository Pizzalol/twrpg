modifier_elementalist_fire_elemental_blazing_haste = class({})

function modifier_elementalist_fire_elemental_blazing_haste:IsHidden() 
	return false--(self:GetStackCount() == 0)
end

function modifier_elementalist_fire_elemental_blazing_haste:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_EVENT_ON_DEATH
	}

	return funcs
end

function modifier_elementalist_fire_elemental_blazing_haste:OnCreated()
	self.blazing_haste_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.blazing_haste_max_stacks = self:GetAbility():GetSpecialValueFor("max_stacks")
	self.blazing_haste_target = nil

	if IsServer() then
		self.nBlazingFX = ParticleManager:CreateParticle("particles/twrpg_gameplay/heroes/hero_elementalist/elementalist_blazing_haste.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(self.nBlazingFX, false, false, -1, false, false)
	end
end

function modifier_elementalist_fire_elemental_blazing_haste:OnAttackLanded(keys)
	if IsServer() and keys.attacker == self:GetParent() then
		local hTarget = keys.target

		if self.blazing_haste_target == hTarget then
			if self:GetStackCount() < self.blazing_haste_max_stacks then
				self:SetStackCount(self:GetStackCount() + 1)
			end
		else
			self.blazing_haste_target = hTarget
			self:SetStackCount(0)
		end
	end

	return 0
end

function modifier_elementalist_fire_elemental_blazing_haste:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount() * self.blazing_haste_attack_speed
end

function modifier_elementalist_fire_elemental_blazing_haste:OnDeath(keys)
	if IsServer() and keys.unit == self:GetParent() then
		self:GetParent():GetAbilityByIndex(2):OnSpellStart()
	end
end