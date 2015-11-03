elementalist_fire_elemental_blazing_haste = class({})
LinkLuaModifier( "modifier_elementalist_fire_elemental_blazing_haste", "heroes/hero_elementalist/fire_elemental/modifiers/modifier_elementalist_fire_elemental_blazing_haste.lua" , LUA_MODIFIER_MOTION_NONE )

function elementalist_fire_elemental_blazing_haste:GetIntrinsicModifierName()
	return "modifier_elementalist_fire_elemental_blazing_haste"
end

function elementalist_fire_elemental_blazing_haste:OnOwnerSpawned()
	Timers:CreateTimer(0.1,function()
		if self:GetCaster():IsAlive() and IsValidEntity(self:GetCaster()) then
			--
			if not self:IsActivated() and self:GetCaster():HasModifier(self:GetIntrinsicModifierName()) then
				self:GetCaster():RemoveModifierByName(self:GetIntrinsicModifierName())
			elseif self:IsActivated() and not self:GetCaster():HasModifier(self:GetIntrinsicModifierName()) then
				self:GetCaster():AddNewModifier(self:GetCaster(), self, self:GetIntrinsicModifierName(), {})
			end

			return 0.1
		else
			return nil
		end
	end)
end