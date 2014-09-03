-- Global variables

lightningCount = 0
abyssCount = 0




-- Earth Elemental abilities

--[[Channeled ability which heals the caster and deals damage to the enemy units
	around the caster while draining his mana
	It is also supposed to ministun but thats not implemented yet]]
function StompInterval(keys)
	local caster = keys.caster
	local mana = caster:GetMana()
	local table = {}
	local casterloc = caster:GetAbsOrigin() 

	-- Getting the info so that we can toggle the ability off when the caster is out of mana
	local playerID = caster:GetOwner():GetPlayerID()
	local ability = caster:FindAbilityByName("elementalist_earth_elemental_toggle_ability")


	--for k,v in pairs(keys) do
	--	print(k,v)
	--end

	table.attacker = caster
	table.damage = 50
	table.damage_type = DAMAGE_TYPE_MAGICAL 

	--print(caster:GetOwner():GetClassname())

	-- Checks if the caster has enough mana
	if mana >= 2 then
		caster:SpendMana(2, caster) --[[Returns:void
		Spend mana from this unit, this can be used for spending mana from abilities or item usage.
		]]
		caster:Heal(100.0, caster) --[[Returns:void
		Heal this unit.
		]]
		print("Particle pls")
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_epicenter_pulse.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		--ParticleManager:SetParticleControlEnt(particle, 0, caster, 5, "attach_hitloc", casterloc, false)
		--ParticleManager:SetParticleControlEnt(particle, 1, caster, 5, "attach_hitloc", casterloc+Vector(200,0,0), false)
		--local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_fire_spirit_ground_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(particle, 0, casterloc+Vector(500,500,500))
		ParticleManager:SetParticleControl(particle, 1, casterloc+Vector(300,0,0))

		-- Finds all valid targets around the caster and deals damage to them
		local unittodamage = FindUnitsInRadius(caster:GetTeam(), casterloc, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)

		for i,v in ipairs(unittodamage) do
			table.victim = v
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
	local ownerInt = caster:GetOwner():GetIntellect() -- Gets the intelligence  of the hero that owns this unit

	table.attacker = caster
	table.victim = target
	table.damage_type = DAMAGE_TYPE_PURE
	table.damage = 100 + 2*ownerInt

	ApplyDamage(table) --[[Returns:float
	Pass ''table'' - Inputs: victim, attacker, damage, damage_type, damage_flags, abilityReturn damage done.
	]]
end

-- Was playing around with this function, doesnt work, ignore
--[[function ThornsAuraArmor(keys)
	local caster = keys.caster
	local getability = caster:FindAbilityByName("elementalist_earth_elemental_thorns_ability")

	caster:AddNewModifier(caster, getability, "modifier_thorns_armor", {armor_bonus = 80})
end]]

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

	table.attacker = caster
	table.damage = casterDmg*ownerInt
	table.damage_type = DAMAGE_TYPE_MAGICAL

	-- Finds all valid targets and deals damage to them
	local unittodamage = FindUnitsInRadius(caster:GetTeam(), targetloc, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)
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

	-- Test particle for Immolation aura
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_egg_ring_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(particle, 3, caster, 5, "attach_hitloc", casterloc, false)
	--ParticleManager:SetParticleControl(particle, 0, casterloc+Vector(1000,0,0))
	--ParticleManager:SetParticleControl(particle, 3, casterloc+Vector(0,0,50))

	table.attacker = caster
	table.damage = 50 + ownerInt * 6
	table.damage_type = DAMAGE_TYPE_MAGICAL

	-- Find all valid targets around the caster and deal damage to them
	local unittodamage = FindUnitsInRadius(caster:GetTeam(), casterloc, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)
	for i,v in ipairs(unittodamage) do
		table.victim = v
		ApplyDamage(table)
	end

	-- Deal damage to the caster
	table.victim = caster
	table.damage_type = DAMAGE_TYPE_MAGICAL
	print("immolration aura test")
	--ApplyDamage(table)
end

--[[Suicide ability which deals damage in an area depending on the casters missing health]]
function MagmaExplosion(keys)
	local caster = keys.caster
	local table = {}
	local casterloc = caster:GetAbsOrigin()
	local ownerInt = caster:GetOwner():GetIntellect()
	local casterMaxHP = caster:GetMaxHealth()
	local casterCurrentHP = caster:GetHealth()

	--print("magma test")

	table.attacker = caster
	table.damage = casterMaxHP - casterCurrentHP
	table.damage_type = DAMAGE_TYPE_MAGICAL

	-- Find all valid targets and deal damage to them
	local unittodamage = FindUnitsInRadius(caster:GetTeam(), casterloc, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)
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
	local healAmount = casterMaxHP*0.05
	--local healAmount = 100

	--if target:HasModifier("modifier_souloftheforest_protection") then
		--healAmount = healAmount*0.5
	--end

	target:Heal(healAmount, caster) --[[Returns:void
	Heal this unit.
	]]
end

-- Lightning Elemental abilities

--[[Chain lightning spell which deals damage to 3 additional targets
	Fires every 4th attack using lightningCount as the attack counter]]
function ChainLightning( keys )
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

		-- Chains to the closest target first
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
end

--[[Massive damage single target spell which ministuns on impact
	It is called once every 8th attack, keeping count of the attacks using lightningCount
	and reseting the counter once it reaches 8 attacks]]
function ThunderStrike(keys)
	if lightningCount == 8 then
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
		lightningCount = 0
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
