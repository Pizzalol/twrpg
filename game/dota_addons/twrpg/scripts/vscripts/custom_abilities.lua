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