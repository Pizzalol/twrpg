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

function PalmStrike( keys )
	local chance = RandomFloat(0, 100)
	local ability = keys.ability
	local caster = keys.caster

	if chance <= 100 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_palm_strike_attack", {}) 
	end
end

function PalmStrikeAttack( keys )
	local caster = keys.caster
	local target = keys.target
	local DamageTable = {}

	DamageTable.attacker = caster
	DamageTable.victim = target
	DamageTable.damage_type = DAMAGE_TYPE_PURE
	DamageTable.damage = 100

	ApplyDamage(DamageTable)
end

function VacuumPalm( keys )
	local caster = keys.caster
	local chance = RandomFloat(0,100)
	local ability = keys.ability
	local target = keys.target
	local StackCount = 0
	local modCount = 0


	if chance <= 100 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_vacuum_palm_slow", {})
		modCount = target:GetModifierCount()
		for i = 0, modCount do
			if target:GetModifierNameByIndex(i) == "modifier_vacuum_palm_slow" then
				StackCount = StackCount + 1
			end
		end
		print("Current stack count is : ".. tostring(StackCount))

		if StackCount >= 2 then
			print("Hello?")
			ability:ApplyDataDrivenModifier(caster, target, "modifier_vacuum_palm_armor", {}) 
		end
	end
end

function InnerMeditation( keys )
	local caster = keys.caster
	local ability = keys.ability
	local chance = RandomFloat(0, 100)

	if chance <= 100 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_inner_meditation_meditate", {})
	end
end

function HeavenlyEmperorStrike( keys )
	local chance = RandomFloat(0, 100)
	local ability = keys.ability
	local caster = keys.caster
	print("Chance is :" .. tostring(chance))

	if chance <= 100 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_heavenly_emperor_strike_attack", {}) 
	end 
end

function HeavenlyEmperorStrikeAttack( keys )
	local caster = keys.caster
	local target = keys.target
	local DamageTable = {}

	DamageTable.attacker = caster
	DamageTable.victim = target
	DamageTable.damage_type = DAMAGE_TYPE_PURE
	DamageTable.damage = 200

	ApplyDamage(DamageTable)
end
