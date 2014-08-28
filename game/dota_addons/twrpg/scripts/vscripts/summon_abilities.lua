-- Global variables

lightningCount = 0
abyssCount = 0




-- Earth Elemental abilities

function StompInterval(keys)
	local caster = keys.caster
	local mana = caster:GetMana()
	local table = {}
	local casterloc = caster:GetAbsOrigin() 

	local playerID = caster:GetOwner():GetPlayerID()
	local ability = caster:FindAbilityByName("elementalist_earth_elemental_toggle_ability")


	--for k,v in pairs(keys) do
	--	print(k,v)
	--end

	table.attacker = keys.caster
	table.damage = 50
	table.damage_type = DAMAGE_TYPE_MAGICAL 

	--print(caster:GetOwner():GetClassname())

	if mana >= 2 then
		caster:SpendMana(2, caster) --[[Returns:void
		Spend mana from this unit, this can be used for spending mana from abilities or item usage.
		]]
		caster:Heal(100.0, caster) --[[Returns:void
		Heal this unit.
		]]
		local unittodamage = FindUnitsInRadius(caster:GetTeam(), casterloc, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)

		for i,v in ipairs(unittodamage) do
			table.victim = v
			ApplyDamage(table)
		end

	else
		caster:CastAbilityToggle(ability, playerID) --[[Returns:void
		Toggle an ability. ( hAbility, iPlayerIndex )
		]]
	end

end

function ThornsAura(keys)
	local caster = keys.caster
	local target = keys.attacker
	local table = {}
	local ownerInt = caster:GetOwner():GetIntellect()

	table.attacker = caster
	table.victim = target
	table.damage_type = DAMAGE_TYPE_PURE
	table.damage = 100 + 2*ownerInt

	ApplyDamage(table) --[[Returns:float
	Pass ''table'' - Inputs: victim, attacker, damage, damage_type, damage_flags, abilityReturn damage done.
	]]
end

--[[function ThornsAuraArmor(keys)
	local caster = keys.caster
	local getability = caster:FindAbilityByName("elementalist_earth_elemental_thorns_ability")

	caster:AddNewModifier(caster, getability, "modifier_thorns_armor", {armor_bonus = 80})
end]]

function SoulOfTheForestHeal( keys )
	local caster = keys.caster
	local table = {}
	local casterloc = caster:GetAbsOrigin()
	local casterMaxHP = caster:GetMaxHealth()
	print("magma test")

	
	if keys.attacker == caster then
		return nil
	end

	local unittoheal =FindUnitsInRadius(caster:GetTeam(), casterloc, nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, 0, false)
	for i,v in ipairs(unittoheal) do
		v:Heal(casterMaxHP*0.1, caster)
	end
end



-- Fire Elemental abilities

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

	local unittodamage = FindUnitsInRadius(caster:GetTeam(), targetloc, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)
	for i,v in ipairs(unittodamage) do
		table.victim = v
		ApplyDamage(table)
	end
end

function ImmolationAura(keys)
	local caster = keys.caster
	local table = {}
	local casterloc = caster:GetAbsOrigin()
	local ownerInt = caster:GetOwner():GetIntellect()

	table.attacker = caster
	table.damage = 50 + ownerInt * 6
	table.damage_type = DAMAGE_TYPE_MAGICAL

	local unittodamage = FindUnitsInRadius(caster:GetTeam(), casterloc, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)
	for i,v in ipairs(unittodamage) do
		table.victim = v
		ApplyDamage(table)
	end
	table.victim = caster
	table.damage_type = DAMAGE_TYPE_MAGICAL
	--print("immolration aura test")
	ApplyDamage(table)
end

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

	local unittodamage = FindUnitsInRadius(caster:GetTeam(), casterloc, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)
	for i,v in ipairs(unittodamage) do
		table.victim = v
		ApplyDamage(table)
	end

	caster:ForceKill(true)
	--print("Magma test 3")
end

function BlazingHasteExplosion( keys )
	local caster = keys.caster
	local table = {}
	local casterloc = caster:GetAbsOrigin()
	local ownerInt = caster:GetOwner():GetIntellect()
	local casterMaxHP = caster:GetMaxHealth()
	--print("magma test")

	table.attacker = caster
	table.damage = casterMaxHP
	table.damage_type = DAMAGE_TYPE_MAGICAL

	local unittodamage = FindUnitsInRadius(caster:GetTeam(), casterloc, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)
	for i,v in ipairs(unittodamage) do
		table.victim = v
		ApplyDamage(table)
	end
end

-- Water Elemental abilities

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

function ChainLightning( keys )
	lightningCount = lightningCount + 1
	

	print("lightning 1")

	if lightningCount % 4 == 0 then
		local caster = keys.caster
		local target = keys.target
		local targetloc = target:GetAbsOrigin() 
		local hitCount = 0
		local table = {}

		print("lightning 2")

		table.attacker = caster
		table.victim = target
		table.damage_type = DAMAGE_TYPE_MAGICAL
		table.damage = 500
		ApplyDamage(table) --[[Returns:float
		Pass ''table'' - Inputs: victim, attacker, damage, damage_type, damage_flags, abilityReturn damage done.
		]]

		local unittodamage = FindUnitsInRadius(caster:GetTeam(), targetloc, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false) --[[Returns:table
		Finds the units in a given radius with the given flags. ( iTeamNumber, vPosition, hCacheUnit, flRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, bCanGrowCache )
		]]

		for i,v in ipairs(unittodamage) do
			print("lightning 3")
			if hitCount < 3 then
				targetloc = v:GetAbsOrigin()
				table.victim = v
				ApplyDamage(table)
				hitCount = hitCount + 1
				unittodamage = FindUnitsInRadius(caster:GetTeam(), targetloc, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)
			end
		end
	end
end

function ThunderStrike(keys)
	if lightningCount == 8 then
		local target = keys.target
		local caster = keys.caster
		local table = {}

		print("ThunderStrike cast")

		table.attacker = caster
		table.victim = target
		table.damage_type = DAMAGE_TYPE_MAGICAL
		table.damage = 200
		ApplyDamage(table)

		target:AddNewModifier(caster, nil, "modifier_stunned", {duration = 0.1}) --[[Returns:void
		No Description Set
		]]

		lightningCount = 0
	end
end

-- Shadow Elemental abilities

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
