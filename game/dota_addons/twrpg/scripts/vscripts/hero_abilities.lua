


--[[A link spell between 2 targets
	Gets the location of the two targets and compares the distance between them
	If the distance is greater than the link breaking point then it breaks the link]]
function ElementalLink( keys )
	local caster = keys.caster
	local casterloc = caster:GetAbsOrigin()
	local target = keys.target
	local targetloc = target:GetAbsOrigin()

	--print(casterloc)
	--print(targetloc)
	-- Distance calculation
	local targetdistance = casterloc - targetloc
	local distance = targetdistance:Length2D()

	--print("Distance between the two targets " .. distance)

	-- Break the link if the distance limit is breached and
	-- remove abilities granted by the link
	if distance >= 1000 then
		caster:RemoveModifierByName("modifier_elemental_link_caster")
		target:RemoveModifierByName("modifier_elemental_link_target")
		print("Link is broken")
		if target:GetUnitName() == "elementalist_fire_elemental" then
			target:RemoveAbility("elementalist_fire_elemental_blazing_haste_ability")
			target:RemoveAbility("elementalist_fire_elemental_blazing_haste_explosion_ability")
		
		elseif target:GetUnitName() == "elementalist_water_elemental" then
			target:RemoveAbility("elementalist_water_elemental_water_blessing_ability")

		elseif target:GetUnitName() == "elementalist_lightning_elemental" then
			target:RemoveAbility("elementalist_lightning_elemental_electric_aura_ability")

		elseif target:GetUnitName() == "elementalist_earth_elemental" then
			target:RemoveAbility("elementalist_earth_elemental_souloftheforest_ability")
		end

		target:RemoveAbility("elementalist_elemental_link_unit_death")
	end
end

--[[On link cast, it applies the link modifier which calls this function
	This function grants the target abilities depending on what type of elemental it is]]
function ElementalLinkAddAbility( keys )
	local target = keys.target

	-- Adds abilities for the fire elemental
	if target:GetUnitName() == "elementalist_fire_elemental" then

		target:AddAbility("elementalist_fire_elemental_blazing_haste_ability")
		local blazingHaste = target:FindAbilityByName("elementalist_fire_elemental_blazing_haste_ability")
		blazingHaste:SetLevel(1)

		target:AddAbility("elementalist_fire_elemental_blazing_haste_explosion_ability")
		local blazingHasteExplosion = target:FindAbilityByName("elementalist_fire_elemental_blazing_haste_explosion_ability")
		blazingHasteExplosion:SetLevel(1)

		-- This ability is granted to all elementals, it breaks the link if the unit dies
		target:AddAbility("elementalist_elemental_link_unit_death")
		local unitDeath = target:FindAbilityByName("elementalist_elemental_link_unit_death")
		unitDeath:SetLevel(1)

	-- Adds abilities for the lightning elemental
	elseif target:GetUnitName() =="elementalist_lightning_elemental" then
		target:AddAbility("elementalist_lightning_elemental_electric_aura_ability")
		local electricAura = target:FindAbilityByName("elementalist_lightning_elemental_electric_aura_ability")
		electricAura:SetLevel(1)

		target:AddAbility("elementalist_elemental_link_unit_death")
		local unitDeath = target:FindAbilityByName("elementalist_elemental_link_unit_death")
		unitDeath:SetLevel(1)

	-- Adds abilities for the water elemental
	elseif target:GetUnitName() == "elementalist_water_elemental" then
		target:AddAbility("elementalist_water_elemental_water_blessing_ability")
		local waterBlessing = target:FindAbilityByName("elementalist_water_elemental_water_blessing_ability")
		waterBlessing:SetLevel(1)

		target:AddAbility("elementalist_elemental_link_unit_death")
		local unitDeath = target:FindAbilityByName("elementalist_elemental_link_unit_death")
		unitDeath:SetLevel(1)

	-- Adds abilities for the earth elemental
	elseif target:GetUnitName() == "elementalist_earth_elemental" then
		target:AddAbility("elementalist_earth_elemental_souloftheforest_ability")
		local soulOfTheForest = target:FindAbilityByName("elementalist_earth_elemental_souloftheforest_ability")
		soulOfTheForest:SetLevel(1)

		target:AddAbility("elementalist_elemental_link_unit_death")
		local unitDeath = target:FindAbilityByName("elementalist_elemental_link_unit_death")
		unitDeath:SetLevel(1)
	end
end

--[[This function activates when the linked elemental dies
	It removes all link abilities from the elemental and removes the link modifier from
	the elemental owner]]
function ElementalLinkUnitDeath( keys )
	local caster = keys.caster

	caster:RemoveModifierByName("modifier_elemental_link_target")
	caster:RemoveAbility("elementalist_fire_elemental_blazing_haste_ability")
	caster:RemoveAbility("elementalist_fire_elemental_blazing_haste_explosion_ability")
	caster:RemoveAbility("elementalist_water_elemental_water_blessing_ability")
	caster:RemoveAbility("elementalist_lightning_elemental_electric_aura_ability")
	caster:RemoveAbility("elementalist_earth_elemental_souloftheforest_ability")

	local casterOwner = caster:GetOwner() 
	casterOwner:RemoveModifierByName("modifier_elemental_link_caster")

	caster:RemoveAbility("elementalist_elemental_link_unit_death")
end

--[[This function is used for recasting the link and in case the caster of the link dies
	It searches for a unit owned by the caster and checks if it has the elemental modifier
	part of the elemental link, if it does then remove abilities from it including the modifier]]
function ElementalLinkCasterDeath( keys )
	local caster = keys.caster

	local summonCheck = Entities:FindAllByModel("models/heroes/phoenix/phoenix_bird.vmdl") --[[Returns:table
	Find entities by model name.
	]]
	print(summonCheck)
	print("Link recast check 1")
	for i,v in ipairs(summonCheck) do
		if v:HasModifier("modifier_elemental_link_target") and v:GetOwner() == caster then
			v:RemoveModifierByName("modifier_elemental_link_target")
			v:RemoveModifierByName("modifier_elemental_link_ability")
			v:RemoveAbility("elementalist_fire_elemental_blazing_haste_ability")
			v:RemoveAbility("elementalist_fire_elemental_blazing_haste_explosion_ability")
			v:RemoveAbility("elementalist_elemental_link_unit_death")
			print("Link recast check 2")
			return
		end
	end

	local summonCheck = Entities:FindAllByModel("models/heroes/treant_protector/treant_protector.vmdl") --[[Returns:table
	Find entities by model name.
	]]
	print(summonCheck)
	print("Link recast check 3")
	for i,v in ipairs(summonCheck) do
		if v:HasModifier("modifier_elemental_link_target") and v:GetOwner() == caster then
			v:RemoveModifierByName("modifier_elemental_link_target")
			v:RemoveModifierByName("modifier_elemental_link_ability")
			v:RemoveAbility("elementalist_earth_elemental_souloftheforest_ability")
			v:RemoveAbility("elementalist_elemental_link_unit_death")
			return
		end
	end

	local summonCheck = Entities:FindAllByModel("models/heroes/razor/razor.vmdl") --[[Returns:table
	Find entities by model name.
	]]
	print(summonCheck)
	for i,v in ipairs(summonCheck) do
		if v:HasModifier("modifier_elemental_link_target") and v:GetOwner() == caster then
			v:RemoveModifierByName("modifier_elemental_link_target")
			v:RemoveModifierByName("modifier_elemental_link_ability")
			v:RemoveAbility("elementalist_lightning_elemental_electric_aura_ability")
			v:RemoveAbility("elementalist_elemental_link_unit_death")
			return
		end
	end

	local summonCheck = Entities:FindAllByModel("models/heroes/morphling/morphling.vmdl") --[[Returns:table
	Find entities by model name.
	]]
	print(summonCheck)
	print("Link recast check 4")
	for i,v in ipairs(summonCheck) do
		if v:HasModifier("modifier_elemental_link_target") and v:GetOwner() == caster then
			v:RemoveModifierByName("modifier_elemental_link_target")
			v:RemoveModifierByName("modifier_elemental_link_ability")
			v:RemoveAbility("elementalist_water_elemental_water_blessing_ability")
			v:RemoveAbility("elementalist_elemental_link_unit_death")
			print("Link recast check 5")
			return
		end
	end
	print("Link recast check 6")

end

--[[This function is run whenever the caster of the Elemental Link is healed]]
function OnCasterHealed( keys )
	local caster = keys.caster

	-- Keeps track of the health of the caster
	HealthTemp = HealthTemp or {}
	HealthTemp[caster] = HealthTemp[caster] or 0

	HealthTemp[caster] = caster:GetHealth() 

	print(HealthTemp[caster])
end

--[[This function is run whenever the caster of the Elemental Link is damaged
	The Elemental Link shares any damage taken by the caster with the linked elemental
	summon]]
function OnCasterDamaged( keys )
	local caster = keys.caster
	local attacker = keys.attacker

	-- Keeps track of the health of the caster
	HealthTemp = HealthTemp or {}
	HealthTemp[caster] = HealthTemp[caster] or 0
	local damage = 0

	if HealthTemp[caster] == 0 then
		damage = caster:GetMaxHealth() - caster:GetHealth() 
	else
		damage = HealthTemp[caster] - caster:GetHealth() 
	end

	HealthTemp[caster] = caster:GetHealth() 

	print("Damage done to the caster = " .. tostring(damage))

	-- Deals damage to the elemental summon that has the elemental link modifier
	local linkTarget = Entities:FindAllByModel("models/heroes/phoenix/phoenix_bird.vmdl")
	local table = {}
	table.attacker = attacker
	table.damage = damage
	table.damage_type = DAMAGE_TYPE_PURE

	for i,v in ipairs(linkTarget) do
		if v:HasModifier("modifier_elemental_link_target") and v:GetOwner() == caster then
			table.victim = v
			ApplyDamage(table)
			print("Dealt damage to link minion")
			return
		end
	end
end