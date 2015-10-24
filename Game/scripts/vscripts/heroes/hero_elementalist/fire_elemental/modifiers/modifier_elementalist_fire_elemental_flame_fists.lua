modifier_elementalist_fire_elemental_flame_fists = class({})

function modifier_elementalist_fire_elemental_flame_fists:IsHidden()
	return false
end

function modifier_elementalist_fire_elemental_flame_fists:DeclareFunctions()
	local funcs = {
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

function modifier_elementalist_fire_elemental_flame_fists:OnCreated()
	if IsServer() then
		Timers:CreateTimer(0.1, function()
			if not self:GetAbility():IsActivated() then
				self:GetParent():RemoveModifierByName("modifier_elementalist_fire_elemental_flame_fists")
			end
		end)
	end
end

function modifier_elementalist_fire_elemental_flame_fists:OnAttackLanded(keys)
	if IsServer() then
		local hTarget = keys.target
		local vLocation = hTarget:GetAbsOrigin()

		-- Ability variables
		local nRadius = self:GetAbility():GetSpecialValueFor("radius")
		local nInt_scale = self:GetAbility():GetSpecialValueFor("int_scale")
		local nBase_damage = self:GetAbility():GetSpecialValueFor("base_damage")

		-- Target flags
		local nTarget_team = self:GetAbility():GetAbilityTargetTeam()
		local nTarget_type = self:GetAbility():GetAbilityTargetType()
		local nTarget_flag = self:GetAbility():GetAbilityTargetFlags()

		-- Initializing the damage table
		local tDamage_table = {}
		tDamage_table.attacker = self:GetParent()
		tDamage_table.ability = self:GetAbility()
		tDamage_table.damage_type = self:GetAbility():GetAbilityDamageType()
		tDamage_table.damage = nBase_damage

		-- Find all valid targets around the attacked unit and then damage them
		local tFlame_targets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), vLocation, nil, nRadius, nTarget_team, nTarget_type, nTarget_flag, FIND_CLOSEST, false)

		for _,unit in pairs(tFlame_targets) do
			tDamage_table.victim = unit
			ApplyDamage(tDamage_table)
		end
	end

	return 0
end