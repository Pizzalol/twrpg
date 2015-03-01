--[[Author: Pizzalol
	Chain lightning spell which deals damage to 3 additional targets, granting mana and applying a magic resistance debuff
	Fires every 4th attack]]
function ChainLightning( keys )
	print("Chain Lightning lightning count is " .. tostring(lightningCount[keys.caster]))

	if lightningCount[keys.caster] % 4 == 0 then
		local caster = keys.caster
		local target = keys.target
		local casterloc = caster:GetAbsOrigin()
		local targetloc = target:GetAbsOrigin()
		local tableDamage = {}
		local damagepercentage = keys.DamagePercentage / 100
		local hitTable = {}
		local chainjumps = keys.ChainJumps
		local ability = keys.ability
		local mana = keys.ManaGain

		local damage = 50

		if caster:HasModifier("elementalist_elemental_link_target") then damagepercentage = 1 end
		print(caster:GetManaRegen())
		caster:GiveMana(mana) 

		tableDamage.attacker = caster
		tableDamage.victim = target
		tableDamage.damage = damage
		tableDamage.damage_type = DAMAGE_TYPE_MAGICAL
		ApplyDamage(tableDamage)
		ability:ApplyDataDrivenModifier(target,target,"elementalist_lightning_elemental_chain_lightning_magicresist_modifier",{})
		print("The first unit is " .. target:GetName())
		table.insert(hitTable, target)

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(particle, 0, caster, 5, "attach_hitloc", casterloc, false)
		ParticleManager:SetParticleControlEnt(particle, 1, target, 5, "attach_hitloc", targetloc, false)
		ParticleManager:ReleaseParticleIndex(particle)


		for i = 0, chainjumps do
			for _, unit in pairs(FindUnitsInRadius(caster:GetTeam(), targetloc, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false)) do
				print("The #" .. i .. " unit found is " .. unit:GetName())
				local checkunit = 0

				for c = 0, #hitTable do					--iterate through hit units`
					if hitTable[c] == unit then
						checkunit = 1					--unit has been hit
					end
				end

				if checkunit == 0 then					--if unit has not been hit
					print("Dealing " .. damage .." to " .. unit:GetName())
					--caster = target
					particleCaster = target						
					target = unit
					targetloc = target:GetAbsOrigin()						--unit becomes new start point
					local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_CUSTOMORIGIN, particleCaster)
					ParticleManager:SetParticleControlEnt(particle, 0, particleCaster, 5, "attach_hitloc", targetloc, false)
					targetloc = target:GetAbsOrigin()
					ParticleManager:SetParticleControlEnt(particle, 1, target, 5, "attach_hitloc", targetloc, false)
					ParticleManager:ReleaseParticleIndex(particle)
					table.insert( hitTable, target )	--log as a hit unit
					tableDamage.victim = target
					tableDamage.damage = tableDamage.damage * damagepercentage
					ApplyDamage(tableDamage)	--Deal damage
					ability:ApplyDataDrivenModifier(target,target,"elementalist_lightning_elemental_chain_lightning_magicresist_modifier",{})
					break
				end
			end
		end
	end
end