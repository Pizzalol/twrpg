
function SummonFireElemental( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local ability_level_lua = ability_level + 1
	local player = caster:GetPlayerOwnerID()

	local ability_1 = keys.ability_1
	local ability_2 = keys.ability_2
	local ability_3 = keys.ability_3
	local modifier = keys.modifier

	local position = keys.target_points[1]
	local caster_int = caster:GetIntellect()
	local elemenental_damage = ability_level_lua * caster_int

	local model_scale = ability:GetLevelSpecialValueFor("model_scale", ability_level)
	local hp_scale = ability:GetLevelSpecialValueFor("hp_scale", ability_level)
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local base_hp = ability:GetLevelSpecialValueFor("base_hp", ability_level)
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)

	if caster.fire_elemental ~= nil and IsValidEntity(caster.fire_elemental) then
		caster.fire_elemental:ForceKill(true)
	end

	caster.fire_elemental = CreateUnitByName("elementalist_fire_elemental", position, true, caster, caster, caster:GetTeam())
	caster.fire_elemental:SetControllableByPlayer(player, true)

	caster.fire_elemental:CreatureLevelUp(ability_level)
	caster.fire_elemental:SetModelScale(model_scale)
	caster.fire_elemental:SetMaxHealth(base_hp+hp_scale*caster_int) -- Add skill damage
	caster.fire_elemental:SetHealth(caster.fire_elemental:GetMaxHealth()) 

	caster.fire_elemental:SetBaseDamageMin(elemenental_damage * 0.9)
	caster.fire_elemental:SetBaseDamageMax(elemenental_damage * 1.1)

	caster.fire_elemental:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})
	ability:ApplyDataDrivenModifier(caster, caster.fire_elemental, modifier, {})

	if caster:HasModifier("modifier_dreamgate") then
		local damagetable = {}
		damagetable.attacker = caster
		damagetable.damage = 200
		damagetable.damage_type = DAMAGE_TYPE_MAGICAL

		local unitToDamage = FindUnitsInRadius(caster:GetTeam(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false)

		for i,v in ipairs(unitToDamage) do
			damagetable.victim = v
			ApplyDamage(damagetable)
			v:AddNewModifier(caster, nil, "modifier_stunned", {duration = 3})
		end
		caster:RemoveModifierByName("modifier_dreamgate")
	end

	caster.fire_elemental:AddAbility(ability_1)
	if ability_level_lua >= 3 then
		caster.fire_elemental:AddAbility(ability_2)
	end
	if ability_level >= 5 then
		caster.fire_elemental:AddAbility(ability_3)
	end
end