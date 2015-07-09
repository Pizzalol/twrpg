--[[Author: Pizzalol
	Heals the target based on the casters max HP]]
function purify( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local hp_pct = ability:GetLevelSpecialValueFor("hp_pct", ability_level) / 100
	local caster_max_hp = caster:GetMaxHealth()
	local heal = caster_max_hp * hp_pct

	-- Heal the target and display the heal particle
	target:Heal(heal, caster)

	heal = math.floor(heal)
	PopupHealing(target, heal)
end

--[[Author: Pizzalol
	Autocast system for the purify spell]]
function purify_autocast( keys )
	local caster = keys.caster
	local target = keys.unit
	local ability = keys.ability

	if ability:GetAutoCastState() and ability:GetCooldownTimeRemaining() == 0 and not ability:IsInAbilityPhase() then
		caster:CastAbilityOnTarget(target, ability, caster:GetPlayerOwnerID() )
	end
end