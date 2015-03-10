function AddSkillDamage( keys )
	local caster = keys.caster
	local skill_damage = keys.SkillDamage
	local playerID = caster:GetPlayerOwnerID()

	HeroArray[playerID].skill_damage = HeroArray[playerID].skill_damage + skill_damage
end

function RemoveSkillDamage( keys )
	local caster = keys.caster
	local skill_damage = keys.SkillDamage
	local playerID = caster:GetPlayerOwnerID()

	HeroArray[playerID].skill_damage = HeroArray[playerID].skill_damage - skill_damage
end

function ability_tracker( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier = keys.modifier

	if ability:IsActivated() and not caster:HasModifier(modifier) then
		ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
	elseif not ability:IsActivated() and caster:HasModifier(modifier) then
		caster:RemoveModifierByNameAndCaster(modifier, caster) 
	end
end