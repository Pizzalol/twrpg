function EmperorStrike( keys )
	local chance = RandomFloat(0, 100)
	local ability = keys.ability
	local caster = keys.caster
	print("Chance is :" .. tostring(chance))

	if chance <= 100 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_emperor_strike_attack", {}) 
	end 
end

function EmperorStrikeAttack( keys )
	local caster = keys.caster
	local target = keys.target
	local DamageTable = {}

	DamageTable.attacker = caster
	DamageTable.victim = target
	DamageTable.damage_type = DAMAGE_TYPE_PURE
	DamageTable.damage = 100

	ApplyDamage(DamageTable)
end