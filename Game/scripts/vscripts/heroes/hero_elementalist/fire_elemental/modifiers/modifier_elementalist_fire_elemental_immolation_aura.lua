modifier_elementalist_fire_elemental_immolation_aura = class({})

--[[Author: Pizzalol
	Acts as a damaging aura that deals damage based on a set interval]]
function modifier_elementalist_fire_elemental_immolation_aura:OnCreated()
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.base_damage = self:GetAbility():GetSpecialValueFor("base_damage")
	self.int_scale = self:GetAbility():GetSpecialValueFor("int_scale")
	self.hp_cost = self:GetAbility():GetSpecialValueFor("hp_cost")
	self.tick_interval = self:GetAbility():GetSpecialValueFor("tick_interval")
	self.blazing_haste_hp_cost = self:GetAbility():GetSpecialValueFor("blazing_haste_hp_cost")

	if IsServer() then
		self:StartIntervalThink(self.tick_interval)
		self:OnIntervalThink()
	end
end

function modifier_elementalist_fire_elemental_immolation_aura:OnIntervalThink()
	if IsServer() then
		local tDamage_table = {}
		tDamage_table.attacker = self:GetParent()
		tDamage_table.damage = self.base_damage
		tDamage_table.damage_type = self:GetAbility():GetAbilityDamageType()
		tDamage_table.ability = self:GetAbility()

		local tImmolation_targets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, self:GetAbility():GetAbilityTargetTeam(), self:GetAbility():GetAbilityTargetType(), self:GetAbility():GetAbilityTargetFlags(), FIND_CLOSEST, false)

		for _,unit in pairs(tImmolation_targets) do
			tDamage_table.victim = unit
			ApplyDamage(tDamage_table)
		end

		tDamage_table.victim = self:GetParent()
		tDamage_table.damage = self:GetParent():GetHealth() * self.hp_cost / 100
		tDamage_table.damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NON_LETHAL
		ApplyDamage(tDamage_table)
	end
end