hasPalmStrike = false

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

	DamageTable.damage = 100
	DamageTable.damage_type = DAMAGE_TYPE_PURE
	DamageTable.attacker = caster


	if not hasPalmStrike then
		if caster:GetAbilityByIndex(2):GetLevel() > 0 then
			hasPalmStrike = true
			print("Current ability is " .. tostring(caster:GetAbilityByIndex(2)))
		end
	end

	if hasPalmStrike then
		local casterLocation = caster:GetAbsOrigin()
		local radius = 300
		local unitsToDamage = FindUnitsInRadius(caster:GetTeam(), casterLocation, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)
		for i,v in ipairs(unitsToDamage) do
			print("I am an AOE strike")
			DamageTable.victim = v
			ApplyDamage(DamageTable)
		end
	else
		print("I am a single target strike")
		DamageTable.victim = target	
		ApplyDamage(DamageTable)
	end
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
