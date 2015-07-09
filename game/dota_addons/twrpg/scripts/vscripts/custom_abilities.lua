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

--[[Author: Pizzalol
	Input: Modifier Name

	Runs periodically on passive abilities to decide if they should be active or disabled
	depending on the ability state]]
function ability_tracker( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier = keys.modifier

	-- If the ability is active and the caster doesnt have the modifier then apply it
	if ability:IsActivated() and not caster:HasModifier(modifier) then
		ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
	-- If the ability is not active and the caster has the modifier then remove it
	elseif not ability:IsActivated() and caster:HasModifier(modifier) then
		caster:RemoveModifierByNameAndCaster(modifier, caster) 
	end
end