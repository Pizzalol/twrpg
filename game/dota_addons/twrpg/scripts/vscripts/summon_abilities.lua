-- Global variables

--lightningCount = 0
abyssCount = 0
bitTable = {512,256,128,64,32,16,8,4,2,1}




-- Earth Elemental abilities

--[[Channeled ability which heals the caster and deals damage to the enemy units
	around the caster while draining his mana
	It is also supposed to ministun but thats not implemented yet]]
function StompInterval(keys)
	local caster = keys.caster
	local mana = caster:GetMana()
	local table = {}
	local casterloc = caster:GetAbsOrigin() 
	local upkeep = keys.Upkeep
	local heal = keys.HealAmount
	local radius = keys.Radius

	-- Getting the info so that we can toggle the ability off when the caster is out of mana
	local playerID = caster:GetOwner():GetPlayerID()
	local ability = caster:FindAbilityByName("elementalist_earth_elemental_ground_shake_ability")


	--for k,v in pairs(keys) do
	--	print(k,v)
	--end

	table.attacker = caster
	table.damage = 50
	table.damage_type = DAMAGE_TYPE_MAGICAL 

	--print(caster:GetOwner():GetClassname())
	print("Earth elemental current mana: " .. tostring(mana))

	-- Checks if the caster has enough mana
	if mana >= upkeep then
		print("Earth elemental mana while having enough: " .. tostring(mana))
		caster:SpendMana(upkeep, caster) --[[Returns:void
		Spend mana from this unit, this can be used for spending mana from abilities or item usage.
		]]
		caster:Heal(heal, caster) --[[Returns:void
		Heal this unit.
		]]

		-- Tried to create this sandking particle but it never showed up in game, no clue why
		--print("Particle pls")
		--local particle = ParticleManager:CreateParticle("particles/twrpg_gameplay/sandking_epicenter.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		--ParticleManager:SetParticleControlEnt(particle, 0, caster, 5, "attach_hitloc", casterloc, false)
		--ParticleManager:SetParticleControlEnt(particle, 1, caster, 5, "attach_hitloc", casterloc+Vector(200,0,0), false)
		--local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_fire_spirit_ground_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		--ParticleManager:SetParticleControl(particle, 0, casterloc)
		--ParticleManager:SetParticleControl(particle, 3, casterloc+Vector(300,0,0))

		-- Finds all valid targets around the caster and deals damage to them
		local unittodamage = FindUnitsInRadius(caster:GetTeam(), casterloc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)

		for i,v in ipairs(unittodamage) do
			table.victim = v
			v:AddNewModifier(caster, nil, "modifier_stunned", {duration = 0.1})
			ApplyDamage(table)
		end

		

	else
		-- If the caster doesnt have enough mana then it toggles the spell off
		caster:CastAbilityToggle(ability, playerID) --[[Returns:void
		Toggle an ability. ( hAbility, iPlayerIndex )
		]]
	end

end

--[[Chance on being called for whenever the caster takes damage
	On activation it deals scaling damage to the attacker]]
function ThornsAura(keys)
	local caster = keys.caster
	local target = keys.attacker
	local table = {}
	local damageAmount = keys.DamageAmount
	local reflectAmount = keys.ReflectAmount / 100
	local ownerInt = caster:GetOwner():GetIntellect() -- Gets the intelligence  of the hero that owns this unit

	print("Damage taken was " .. tostring(damageAmount))

	table.attacker = caster
	table.victim = target
	table.damage_type = DAMAGE_TYPE_PURE
	table.damage = damageAmount * reflectAmount

	ApplyDamage(table)
end

-- [[Adds armor to the unit depending on the owners intelligence]]
function ThornsAuraArmor(keys)
	local caster = keys.caster
	local owner = caster:GetOwner()
	local ownerInt = owner:GetIntellect()
	local baseArmor = keys.BaseArmor	
	local armor = math.floor(ownerInt / 10)

	--print("Base armor value: " .. tostring(baseArmor))

	armor = armor + baseArmor

	-- Creates temporary item to steal the modifiers from
	local armorBonus = CreateItem("item_armor_modifier", nil, nil) 
	for p=1, #bitTable do
		local val = bitTable[p]
		local count = math.floor(armor / val)
		if count >= 1 then
			armorBonus:ApplyDataDrivenModifier(caster, caster, "modifier_armor_mod_" .. val, {})
			armor = armor - val
		end
	end
	-- Cleanup
	UTIL_RemoveImmediate(armorBonus)
	armorBonus = nil
end

--[[Has a chance to trigger everytime the caster is hit
	Once it activates it heals all allied units in a radius for 10% of the casters
	maximum health]]
function SoulOfTheForestHeal( keys )
	local caster = keys.caster
	local table = {}
	local casterloc = caster:GetAbsOrigin()
	local casterMaxHP = caster:GetMaxHealth()
	print("magma test")

	-- Checks if the attacker is the caster to prevent crashes if the caster
	-- is forcefully killed by script
	if keys.attacker == caster then
		return nil
	end

	-- Finds all valid units in a radius around the caster and heals them
	local unittoheal =FindUnitsInRadius(caster:GetTeam(), casterloc, nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, 0, false)
	for i,v in ipairs(unittoheal) do
		v:Heal(casterMaxHP*0.1, caster)
	end
end



-- Fire Elemental abilities

--[[A cleave ability which deals scaling damage on the target unit position]]
function FlameFists(keys)
	local caster = keys.caster
	local table = {}
	local target = keys.target
	local targetloc = target:GetAbsOrigin()
	local casterDmg = caster:GetAttackDamage()
	local ownerInt = caster:GetOwner():GetIntellect()
	local radius = keys.Radius

	if caster:HasModifier("modifier_elemental_link_target") then radius = 500 end

	table.attacker = caster
	table.damage = casterDmg*ownerInt
	table.damage_type = DAMAGE_TYPE_MAGICAL

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_fire_spirit_ground_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle, 0, targetloc)
	ParticleManager:SetParticleControl(particle, 3, targetloc)

	-- Finds all valid targets and deals damage to them
	local unittodamage = FindUnitsInRadius(caster:GetTeam(), targetloc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)
	for i,v in ipairs(unittodamage) do
		table.victim = v
		ApplyDamage(table)
	end
end

--[[An aura which deals damage to targets around the caster
	it also deals damage to the caster]]
function ImmolationAura(keys)
	local caster = keys.caster
	local table = {}
	local casterloc = caster:GetAbsOrigin()
	local ownerInt = caster:GetOwner():GetIntellect()
	local hpcost = keys.HPCost/100
	local radius = keys.Radius
	print("Current HP cost is: " .. tostring(hpcost))

	-- Test particle for Immolation aura
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_egg_ring_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(particle, 3, caster, 5, "attach_hitloc", casterloc, false)
	--ParticleManager:SetParticleControl(particle, 0, casterloc+Vector(1000,0,0))
	--ParticleManager:SetParticleControl(particle, 3, casterloc+Vector(0,0,50))

	table.attacker = caster
	table.damage = 50 + ownerInt * 6
	table.damage_type = DAMAGE_TYPE_MAGICAL

	-- Find all valid targets around the caster and deal damage to them
	local unittodamage = FindUnitsInRadius(caster:GetTeam(), casterloc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)
	for i,v in ipairs(unittodamage) do
		table.victim = v
		ApplyDamage(table)
	end

	if caster:HasModifier("modifier_elemental_link_target") then hpcost = hpcost/2 end
	-- Deal damage to the caster
	table.victim = caster
	table.damage_type = DAMAGE_TYPE_MAGICAL
	table.damage = caster:GetHealth() * hpcost
	print("Immolation aura dealing damage to self: " .. tostring(table.damage))
	ApplyDamage(table)
end

--[[Suicide ability which deals damage in an area depending on the casters missing health]]
function MagmaExplosion(keys)
	local caster = keys.caster
	local table = {}
	local casterloc = caster:GetAbsOrigin()
	local ownerInt = caster:GetOwner():GetIntellect()
	local casterMaxHP = caster:GetMaxHealth()
	local casterCurrentHP = caster:GetHealth()
	local radius = keys.Radius

	--print("magma test")

	table.attacker = caster
	table.damage = casterMaxHP - casterCurrentHP
	table.damage_type = DAMAGE_TYPE_MAGICAL

	-- Find all valid targets and deal damage to them
	local unittodamage = FindUnitsInRadius(caster:GetTeam(), casterloc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)
	for i,v in ipairs(unittodamage) do
		table.victim = v
		ApplyDamage(table)
	end

	-- Kill the caster
	caster:ForceKill(true)
	--print("Magma test 3")
end

--[[This ability activates when the caster dies and acts as an explosion,
	dealing damage to targets around the caster at the time of his death]]
function BlazingHasteExplosion( keys )
	local caster = keys.caster
	local table = {}
	local casterloc = caster:GetAbsOrigin()
	local ownerInt = caster:GetOwner():GetIntellect()
	local casterMaxHP = caster:GetMaxHealth()
	--print("magma test")

	-- Damage done is equal to the casters maximum health
	table.attacker = caster
	table.damage = casterMaxHP
	table.damage_type = DAMAGE_TYPE_MAGICAL

	-- Find all valid targets and deal damage to them
	local unittodamage = FindUnitsInRadius(caster:GetTeam(), casterloc, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)
	for i,v in ipairs(unittodamage) do
		table.victim = v
		ApplyDamage(table)
	end
end

-- Water Elemental abilities

--[[Heal the target unit for an amount that is equal to 5% of the casters MaxHP]]
function Purification( keys )
	local caster = keys.caster
	local target = keys.target
	local casterMaxHP = caster:GetMaxHealth()
	local hpHeal = keys.HPHeal
	local healAmount = casterMaxHP*(hpHeal/100)
	--local healAmount = 100

	--if target:HasModifier("modifier_souloftheforest_protection") then
		--healAmount = healAmount*0.5
	--end

	target:Heal(healAmount, caster) --[[Returns:void
	Heal this unit.
	]]
end

function ChainHeal( keys )
	local caster = keys.caster
	local target = keys.target
	local targetloc = target:GetAbsOrigin()
	local chainjumps = keys.ChainJumps
	local targetshealed = 0

	local unitstoheal = FindUnitsInRadius(caster:GetTeam(), targetloc, nil, 800, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false)

	for i,v in ipairs(unitstoheal) do
		if targetshealed < chainjumps then
			v:SetHealth(v:GetMaxHealth())
			targetshealed = targetshealed + 1
		end
	end
end

function WaterBlessing( keys )
	local target = keys.target 
	local primaryAttribute = target:GetPrimaryAttribute()
	local attributePercentage = keys.AttributeIncrease / 100
	local attribute
	local attributeBoostItem
	local modifierName
	print("Primary attribute is " .. tostring(primaryAttribute))

	-- 0 STR
	-- 1 AGI
	-- 2 INT
	if primaryAttribute == 0 then
		attribute = target:GetStrength() 
		attributeBoostItem = CreateItem("item_strength_modifier", nil, nil)
		modifierName = "strength"
	elseif primaryAttribute == 1 then
		attribute = target:GetAgility()
		attributeBoostItem = CreateItem("item_agility_modifier", nil, nil)
		modifierName = "agility"
	else
		attribute = target:GetIntellect()
		attributeBoostItem = CreateItem("item_intellect_modifier", nil, nil)
		modifierName = "intellect" 
	end
	print("Modifier name is " .. modifierName)

	 
	local attributeBoost = math.floor(attribute * attributePercentage)
	print("Attribute boost is ".. tostring(attributeBoost))

	 
	for p=1, #bitTable do
		local val = bitTable[p]
		local count = math.floor(attributeBoost / val)
		if count >= 1 then
			attributeBoostItem:ApplyDataDrivenModifier(target, target, "modifier_" .. modifierName .. "_mod_" .. val, {})
			attributeBoost = attributeBoost - val
		end
	end
	-- Cleanup
	UTIL_RemoveImmediate(attributeBoostItem)
	attributeBoostItem = nil
end

function WaterBlessingRemove( keys )
	local target = keys.target
	local primaryAttribute = target:GetPrimaryAttribute() 
	local modifierName
	print("Primary attribute is " .. tostring(primaryAttribute))

	-- 0 STR
	-- 1 AGI
	-- 2 INT
	if primaryAttribute == 0 then
		modifierName = "strength"
	elseif primaryAttribute == 1 then
		modifierName = "agility"
	else
		modifierName = "intellect" 
	end
	
 
	-- Gets the list of modifiers on the hero and loops through removing and health modifier
	local modCount = target:GetModifierCount()
	for i = 0, modCount do
		for u = 1, #bitTable do
			local val = bitTable[u]
			if target:GetModifierNameByIndex(i) == "modifier_".. modifierName .. "_mod_" .. val  then
				target:RemoveModifierByName("modifier_" .. modifierName .. "_mod_" .. val)
			end
		end
	end
end

-- Lightning Elemental abilities

--[[Chain lightning spell which deals damage to 3 additional targets
	Fires every 4th attack using lightningCount as the attack counter]]
--[[function ChainLightning( keys )
	-- Counts the number of attack that have been made
	lightningCount = lightningCount + 1
	

	print("lightning 1")

	-- Once it reaches 4 attacks, it starts doing the chain lightning code
	if lightningCount % 4 == 0 then
		local caster = keys.caster
		local casterloc = caster:GetAbsOrigin()
		local target = keys.target
		local targetloc = target:GetAbsOrigin() 
		local hitCount = 0
		local table = {}

		print("lightning 2")

		-- Define the table
		table.attacker = caster
		table.damage_type = DAMAGE_TYPE_MAGICAL
		table.damage = 200

		-- Create the particle
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(particle, 0, caster, 5, "attach_hitloc", casterloc, false)
		ParticleManager:SetParticleControlEnt(particle, 1, target, 5, "attach_hitloc", targetloc, false)
		ParticleManager:ReleaseParticleIndex(particle)

		-- Saves all valid targets to which the chain can jump
		local unittodamage = FindUnitsInRadius(caster:GetTeam(), targetloc, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false) --[[Returns:table
		Finds the units in a given radius with the given flags. ( iTeamNumber, vPosition, hCacheUnit, flRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, bCanGrowCache )
		]]

		--[[ Chains to the closest target first
		for i,v in ipairs(unittodamage) do
			print("lightning 3")
			-- As long as it hasnt chained to 3 targets already, it will continue
			-- searching and dealing damage to targets it can find
			if hitCount < 4 then
				-- Changing caster and target for particle chaining
				caster = target
				target = v
				print("Attacking this target " .. tostring(target))
				casterloc = targetloc
				targetloc = v:GetAbsOrigin()
				table.victim = v
				ApplyDamage(table)

				-- Creating the particle
				local particlelink = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControlEnt(particlelink, 0, caster, 5, "attach_hitloc", casterloc, false)
				ParticleManager:SetParticleControlEnt(particlelink, 1, target, 5, "attach_hitloc", targetloc, false)
				ParticleManager:ReleaseParticleIndex(particlelink)

				hitCount = hitCount + 1
			end
		end
	end
end]]

function ChainLightning( keys )
	print("Chain Lightning lightning count is " .. tostring(lightningCount[keys.caster]))

	if lightningCount[keys.caster] % 4 == 0 then
		local caster = keys.caster
		local target = keys.target
		local casterloc = caster:GetAbsOrigin()
		local targetloc = target:GetAbsOrigin()
		local tableDamage = {}
		local damagepercentage = keys.DamagePercentage
		local hitTable = {}
		local chainjumps = keys.ChainJumps
		local ability = keys.ability

		local damage = 50 * damagepercentage

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
					ApplyDamage(tableDamage)	--Deal damage
					ability:ApplyDataDrivenModifier(target,target,"elementalist_lightning_elemental_chain_lightning_magicresist_modifier",{})
					break
				end
			end
		end
	end
end







-- Testing
--[[function Chainlightning(keys)
	local dmg = keys.dmg				--base attack damage
	local jumps = keys.maxjumps			--get max jumps from key values
	local shock = keys.shockperc / 100	--%shock damage from keyvalues
	local Target = keys.target			--Attacked unit
	local Caster = keys.caster			--Attacking unit
	local hitTable = {}					--Table of hit units. Lightning never strikes twice in the same place
	
	dmg = (dmg * shock)
	
	local damageTable = {victim = Target, attacker = Caster, damage = dmg, damage_type = DAMAGE_TYPE_MAGICAL}
	ApplyDamage(damageTable)	--Deal damage
	print("The first unit is " .. Target:GetName())
	table.insert( hitTable, Target)
	lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, Caster)
	ParticleManager:SetParticleControl(lightningBolt,1,Vector(Target:GetAbsOrigin().x,Target:GetAbsOrigin().y,Target:GetAbsOrigin().z+((Target:GetBoundingMaxs().z - Target:GetBoundingMins().z)/2)))
	
	for i = 0, jumps do
		for _, unit in pairs(Entities:FindAllInSphere(Target:GetAbsOrigin(), 400)) do
			if (unit:GetClassname() == "npc_dota_creature" or unit:GetClassname() == "npc_dota_creep_neutral") and unit:GetTeamNumber() == 3 and unit:IsAlive() then
				print("The #" .. i .. " unit found is " .. unit:GetName())
				local checkunit = 0 					--bool check if we hit this unit before
				
				for c = 0, #hitTable do					--iterate through hit units`
					if hitTable[c] == unit then
						checkunit = 1					--unit has been hit
					end
				end
				
				if checkunit == 0 then					--if unit has not been hit
					print("Dealing " .. dmg .." to " .. unit:GetName())
					Caster = Target						
					Target = unit						--unit becomes new start point
					lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, Caster)
					ParticleManager:SetParticleControl(lightningBolt,1,Vector(Target:GetAbsOrigin().x,Target:GetAbsOrigin().y,Target:GetAbsOrigin().z+((Target:GetBoundingMaxs().z - Target:GetBoundingMins().z)/2)))
					table.insert( hitTable, Target )	--log as a hit unit
					damageTable = {victim = Target, attacker = Caster, damage = dmg, damage_type = DAMAGE_TYPE_MAGICAL}
					ApplyDamage(damageTable)	--Deal damage
					break
				end
			end
		end
	end
end]]








--[[Massive damage single target spell which ministuns on impact
	It is called once every 8th attack, keeping count of the attacks using lightningCount
	and reseting the counter once it reaches 8 attacks]]
function ThunderStrike(keys)
	lightningCount = lightningCount or {}
	lightningCount[keys.caster] = lightningCount[keys.caster] or 0
	lightningCount[keys.caster] = lightningCount[keys.caster] + 1
	if lightningCount[keys.caster] == 8 then
		print("ThunderStrike Lightning count is " .. tostring(lightningCount[keys.caster]))
		local target = keys.target
		local targetloc = target:GetAbsOrigin()
		local caster = keys.caster
		local table = {}

		print("ThunderStrike cast")

		table.attacker = caster
		table.victim = target
		table.damage_type = DAMAGE_TYPE_MAGICAL
		table.damage = 200
		ApplyDamage(table)

		-- Create the spell particle
		local lightningBoltParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControl(lightningBoltParticle, 1, targetloc + Vector(0,0,2000))
		ParticleManager:ReleaseParticleIndex(lightningBoltParticle)
		

		-- Adds the ministun
		target:AddNewModifier(caster, nil, "modifier_stunned", {duration = 0.1}) 

		-- Resets the attack counter
		lightningCount[keys.caster] = 0
	end
end

-- Shadow Elemental abilities

--[[Simple dash to point ability which deals damage to targets around the dashing point]]
function AbyssDash( keys )
	local caster = keys.caster
	local casterloc = caster:GetAbsOrigin()
	local target = keys.target_points[1]
	local facevec = target - casterloc
	local distance = facevec:Length2D() -- calculates the distance between the two points
	--print("Dash distance " .. distance)

	-- Sets the new distance depending on the target point because it overshoots by ~100-200 for whatever reason
	if distance >= 400 then 
		distance = distance - 200
	elseif distance >= 200 then
		distance = distance - 100
	end
	--print("Dash distance after change " .. distance)
	-- Forces the target to face the target point
	facevec = facevec:Normalized()
	facevec.z = 0
	caster:SetForwardVector(facevec)

	-- Applies the forcestaff push to simulate a dash
	caster:AddNewModifier(caster, nil, "modifier_item_forcestaff_active", {push_length = distance})

	-- Damage table definitions
	local table = {}
	table.attacker = caster
	table.damage_type = DAMAGE_TYPE_MAGICAL
	table.damage = 300

	-- Saving every valid target in a table
	local unittodamage = FindUnitsInRadius(caster:GetTeam(), target, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false) --[[Returns:table
	Finds the units in a given radius with the given flags. ( iTeamNumber, vPosition, hCacheUnit, flRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, bCanGrowCache )
	]]

	-- Applying damage to every target that was found
	for i,v in ipairs(unittodamage) do
		table.victim = v
		ApplyDamage(table)
	end
end

--[[This is supposed to be like a black hole ability, sucking everything to the center
	On cast, a dummy is created which uses a Vacuum-based spell
	Once every target is pulled to the center, the damage is applied]]
function AbyssPull( keys )
	local caster = keys.caster
	local casterloc = caster:GetAbsOrigin()
	local owner = caster:GetOwner()
	local playerID = owner:GetPlayerID()
	local table = {}

	-- Create a dummy unit which will cast the spell on the caster location
	local dummy = CreateUnitByName("npc_dummy_unit", casterloc, false, owner, owner, owner:GetTeam()) 
	
	-- Add the phased modifier so units dont collide with the dummy
	dummy:AddNewModifier(dummy, nil, "modifier_phased", {})
	-- Add the spell to the dummy unit that needs to be cast
	dummy:AddAbility("dummy_unit_pull")
	-- Set the ability level so that it can be casted
	local ability = dummy:FindAbilityByName("dummy_unit_pull")
	ability:SetLevel(1)
	-- Activate the passive ability for dummy units so that its invisible, invulnerable
	-- and has no health bar
	local dummyability = dummy:FindAbilityByName("dummy_unit")
	dummyability:SetLevel(1)
	--dummy:SetControllableByPlayer(playerID, true)

	-- Create first timer so that the spell gets cast by the dummy unit 0.01 seconds
	-- after the dummy unit is created as you cant issue commands to units that are created
	-- on the same frame as the command is given
	-- Create the second timer so that it removes the dummy unit 2 seconds after it started
	-- casting the spell
	Timers:CreateTimer(0.01, function()
		dummy:CastAbilityOnPosition(casterloc, ability, 0)
		print("Timer 1")
		Timers:CreateTimer(2, function()
			dummy:RemoveSelf() 
			print("Timer 2")
			end)
		end)

end


--[[It is a cleave ability, dealing extra damage on each attack
	Everytime its called it increases the abyss hit count by 1
	Once the count reaches 5, it gives additional damage to the cleave]]
function AbyssReach( keys )
	-- Define the caster, target, target location and damage
	local caster = keys.caster
	local table = {}
	local target = keys.target
	local targetloc = target:GetAbsOrigin()
	local casterDmg = caster:GetAttackDamage()
	--local ownerInt = caster:GetOwner():GetIntellect()

	-- Counts how many attacks have been made so far
	abyssCount = abyssCount + 1
	print("Counting empowered attacks")

	table.attacker = caster
	table.damage = casterDmg
	table.damage_type = DAMAGE_TYPE_MAGICAL

	-- If its the 5th attack then "Empower" it and reset the counter
	if abyssCount % 5 == 0 then
		print("Empowered attack")
		table.damage = casterDmg * 2
		abyssCount = 0
	end

	-- Find all valid targets and damage them
	local unittodamage = FindUnitsInRadius(caster:GetTeam(), targetloc, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)
	for i,v in ipairs(unittodamage) do
		table.victim = v
		ApplyDamage(table)
	end
end

function AbyssEye( keys )
	local caster = keys.caster
	local casterloc = caster:GetAbsOrigin() 
	local owner = caster:GetOwner()
	local damageTable = {}

	damageTable.attacker = caster
	damageTable.damage_type = DAMAGE_TYPE_PURE
	damageTable.damage = 50

	-- Spiral part
	-- checks whose turn it is to step
	local xstep
	local ystep
	
	-- x and y orientation
	local xcheck = false
	local ycheck = false

	-- Test to see if y or x should swap orientation
	local checkersCheck = false

	-- Counter for steps
	local counter = 1
	local counterMax = 8
	-- Counter for how often the maximum should be reduced
	local counterMaxMax = 1
	--positional vectors
	local vectorX = 0
	local vectorY = 0

	-- create dummy at start coordinates to be linked with
	local dummy = CreateUnitByName("npc_dummy_unit", casterloc, false, owner, owner, owner:GetTeam()) 
	--dummy:HasFlyMovementCapability() 
	dummy:AddNewModifier(dummy, nil, "modifier_phased", {})
	local dummyability = dummy:FindAbilityByName("dummy_unit")
	dummyability:SetLevel(1)
	dummy:SetAbsOrigin(casterloc+Vector(0,0,500))

	-- first block
	local dummySpiralStart = CreateUnitByName("npc_dummy_unit", casterloc+Vector(700,-700,0), false, owner, owner, owner:GetTeam()) 
	dummySpiralStart:AddNewModifier(dummySpiralStart, nil, "modifier_phased", {})
	local dummyability = dummySpiralStart:FindAbilityByName("dummy_unit")
	dummyability:SetLevel(1)

	local targetsToDamage = FindUnitsInRadius(caster:GetTeam(), dummySpiralStart:GetAbsOrigin(), nil, 155, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)

	for _,v in ipairs(targetsToDamage) do
		damageTable.victim = v
		ApplyDamage(damageTable)
	end

	-- particle
	ElementalLinkParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_tether.vpcf", PATTACH_CUSTOMORIGIN, dummy)
	ParticleManager:SetParticleControlEnt(ElementalLinkParticle, 0, dummy, 5, "attach_hitloc", dummy:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(ElementalLinkParticle, 1, dummySpiralStart, 5, "attach_mouth", dummySpiralStart:GetAbsOrigin(), false)

	-- Setting up the counters
	
	-- do loops for the rest
	--while(xstep>0) do
	--	xstep = xstep - 1
	--	print("Is it in the loop?")
		-- create a dummy
		--[[Timers:CreateTimer(1,function()
			--ParticleManager:DestroyParticle(ElementalLinkParticle, true)
			vectorX = counter * 250
			dummySpiral = CreateUnitByName("npc_dummy_unit", casterloc+Vector(600-vectorX,600,0), false, owner, owner, owner:GetTeam())
			dummySpiral:AddNewModifier(dummySpiral, nil, "modifier_phased", {})
			local dummyability = dummySpiral:FindAbilityByName("dummy_unit")
			dummyability:SetLevel(1)
			print("Counter is " .. tostring(counter))
			counter = counter + 1

			ElementalLinkParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_tether.vpcf", PATTACH_CUSTOMORIGIN, dummy)
			ParticleManager:SetParticleControlEnt(ElementalLinkParticle, 0, dummy, 5, "attach_hitloc", dummy:GetAbsOrigin(), false)
			ParticleManager:SetParticleControlEnt(ElementalLinkParticle, 1, dummySpiral, 5, "attach_mouth", dummySpiral:GetAbsOrigin(), false)

			if counter <= counterMax then
				return 1.0
			else
				counter = 1
				return
			end
			end)]]
	--end

	ystep = true
	xstep = false

	xcheck = true

	

	Timers:CreateTimer(0.045, function()
		-- check whose turn it is to go and calculate
		if ystep then
			if not ycheck then
				vectorY = vectorY - 155
			else
				vectorY = vectorY + 155
			end
		else
			if not xcheck then
				vectorX = vectorX - 155
			else
				vectorX = vectorX + 155
			end
		end
		ParticleManager:DestroyParticle(ElementalLinkParticle, true)
		dummySpiral = CreateUnitByName("npc_dummy_unit", casterloc+Vector(700-vectorX,-700-vectorY,0), false, owner, owner, owner:GetTeam())
		dummySpiral:AddNewModifier(dummySpiral, nil, "modifier_phased", {})
		local dummyability = dummySpiral:FindAbilityByName("dummy_unit")
		dummyability:SetLevel(1)

		local targetsToDamage = FindUnitsInRadius(caster:GetTeam(), dummySpiral:GetAbsOrigin(), nil, 155, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)

		for _,v in ipairs(targetsToDamage) do
			damageTable.victim = v
			ApplyDamage(damageTable)
		end

		ElementalLinkParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_tether.vpcf", PATTACH_CUSTOMORIGIN, dummy)
		ParticleManager:SetParticleControlEnt(ElementalLinkParticle, 0, dummy, 5, "attach_hitloc", dummy:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(ElementalLinkParticle, 1, dummySpiral, 5, "attach_mouth", dummySpiral:GetAbsOrigin(), false)

		-- Kill the dummy
		Timers:CreateTimer(0.0,function()
			local temporaryDummy = dummySpiral
			Timers:CreateTimer(0.03,function()
				temporaryDummy:RemoveSelf()
				end)
			end)

		counter = counter + 1
		print("Counter is ".. tostring(counter))
		print("Counter Maximum is " .. tostring(counterMax))

		if counter <= counterMax then
			return 0.045
		else
			ystep = not ystep
			xstep = not xstep
			counter = 0
			counterMaxMax = counterMaxMax + 1
			if counterMaxMax == 2 then
				counterMax = counterMax - 1
				counterMaxMax = 0
			end 

			if checkersCheck then
				xcheck = not xcheck
			else
				ycheck = not ycheck
			end

			checkersCheck = not checkersCheck

			if counterMax < 0 then
				ParticleManager:DestroyParticle(ElementalLinkParticle, true)
				--dummySpiral:RemoveSelf() 
				return
			else
				return 0.045
			end
		end



		end)

	--[[for i=4,0,-1 do
		xstep = i
		ystep = i
		while(ystep>0) do
			ystep = ystep - 1
			if ycheck then
				-- create a dummy in a positive direction
			else
				-- create a dummy in a negative direction
			end
		end

		while(xstep>0) do
			xstep = xstep - 1
			if xcheck then
				-- create a dummy in a positive direction
			else
				-- create a dummy in a negative direction
			end
		end

		ycheck = not ycheck
		xcheck = not xcheck
	end]]

end
