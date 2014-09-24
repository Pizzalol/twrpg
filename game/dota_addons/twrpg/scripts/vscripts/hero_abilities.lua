
fire = "phoenix"
water = "morphling"
lightning = "razor"
earth = "treant_protector"
shadow = "enigma"


--[[A link spell between 2 targets
	Gets the location of the two targets and compares the distance between them
	If the distance is greater than the link breaking point then it breaks the link]]
function ElementalLink( keys )
	local caster = keys.caster
	local casterloc = caster:GetAbsOrigin()
	local target = keys.target
	local targetloc = target:GetAbsOrigin()

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
			target:RemoveModifierByName("modifier_electric") 

		elseif target:GetUnitName() == "elementalist_earth_elemental" then
			target:RemoveAbility("elementalist_earth_elemental_souloftheforest_ability")
			target:RemoveModifierByName("modifier_souloftheforest")
		end

		target:RemoveAbility("elementalist_elemental_link_unit_death")
		target:RemoveModifierByName("modifier_elemental_link_ability") 
		ParticleManager:DestroyParticle(ElementalLinkParticle, true)
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

	ParticleManager:DestroyParticle(ElementalLinkParticle, true)
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

--[[This function is used when the caster dies while the link is active
	It searches for a unit owned by the caster and checks if it has the elemental modifier
	part of the elemental link, if it does then remove abilities from it including the modifier]]
function ElementalLinkCasterDeath( keys )
	local caster = keys.caster
	local elemental

	-- Destroys the link particle
	if ElementalLinkParticle ~= nil then
		ParticleManager:DestroyParticle(ElementalLinkParticle, true)
	end
	
	-- Finds the linked summon

	-- Fire Elemental
	elemental = CheckElemental(caster,fire)
	if elemental ~= nil and elemental:HasModifier("modifier_elemental_link_target")  then
		elemental:RemoveModifierByName("modifier_elemental_link_target") 
		elemental:RemoveModifierByName("modifier_elemental_link_ability")
		elemental:RemoveAbility("elementalist_fire_elemental_blazing_haste_ability") 
		elemental:RemoveAbility("elementalist_fire_elemental_blazing_haste_explosion_ability")
		elemental:RemoveAbility("elementalist_elemental_link_unit_death") 

		return
	else
		elemental = nil
	end
	
	-- Earth Elemental
	elemental = CheckElemental(caster,earth)
	if elemental ~= nil and elemental:HasModifier("modifier_elemental_link_target")  then
		elemental:RemoveModifierByName("modifier_elemental_link_target") 
		elemental:RemoveModifierByName("modifier_elemental_link_ability")
		elemental:RemoveAbility("elementalist_earth_elemental_souloftheforest_ability")
		-- Remove the aura after removing the ability
		elemental:RemoveModifierByName("modifier_souloftheforest") 
		elemental:RemoveAbility("elementalist_elemental_link_unit_death") 

		return
	else
		elemental = nil
	end

	-- Lightning Elemental
	elemental = CheckElemental(caster,lightning)
	if elemental ~= nil and elemental:HasModifier("modifier_elemental_link_target")  then
		elemental:RemoveModifierByName("modifier_elemental_link_target") 
		elemental:RemoveModifierByName("modifier_elemental_link_ability")
		elemental:RemoveAbility("elementalist_lightning_elemental_electric_aura_ability")
		-- Remove the aura after removing the ability
		elemental:RemoveModifierByName("modifier_electric") 
		elemental:RemoveAbility("elementalist_elemental_link_unit_death") 

		return
	else
		elemental = nil
	end

	-- Water Elemental
	elemental = CheckElemental(caster,water)
	if elemental ~= nil and elemental:HasModifier("modifier_elemental_link_target")  then
		elemental:RemoveModifierByName("modifier_elemental_link_target") 
		elemental:RemoveModifierByName("modifier_elemental_link_ability")
		elemental:RemoveAbility("elementalist_water_elemental_water_blessing_ability")
		elemental:RemoveAbility("elementalist_elemental_link_unit_death") 

		return
	end
	--print("Link recast check 6")
	return

end

--[[This function is called on every cast of the ability
	It sets up the link along with the particle
	If an existing link exists then it kills it]]
function ElementalLinkCasted( keys )
	local caster = keys.caster
	local target = keys.target
	local casterloc = caster:GetAbsOrigin()
	local targetloc = target:GetAbsOrigin()
	local elemental 

	-- If theres an existing particle link then kill it
	if ElementalLinkParticle ~= nil then
		ParticleManager:DestroyParticle(ElementalLinkParticle, true)
	end

	-- Link particle creation
	ElementalLinkParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_tether.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(ElementalLinkParticle, 0, caster, 5, "attach_hitloc", casterloc, false)
	ParticleManager:SetParticleControlEnt(ElementalLinkParticle, 1, target, 5, "attach_mouth", targetloc, false)

	-- Tries to find if a summon is linked
	-- Fire Elemental
	elemental = CheckElemental(caster,fire)
	if elemental ~= nil and elemental:HasModifier("modifier_elemental_link_target")  then
		elemental:RemoveModifierByName("modifier_elemental_link_target") 
		elemental:RemoveModifierByName("modifier_elemental_link_ability")
		elemental:RemoveAbility("elementalist_fire_elemental_blazing_haste_ability") 
		elemental:RemoveAbility("elementalist_fire_elemental_blazing_haste_explosion_ability")
		elemental:RemoveAbility("elementalist_elemental_link_unit_death") 

		return
	else
		elemental = nil
	end

	-- Earth Elemental
	elemental = CheckElemental(caster,earth)
	if elemental ~= nil and elemental:HasModifier("modifier_elemental_link_target")  then
		elemental:RemoveModifierByName("modifier_elemental_link_target") 
		elemental:RemoveModifierByName("modifier_elemental_link_ability")
		elemental:RemoveAbility("elementalist_earth_elemental_souloftheforest_ability")
		-- Remove the aura after removing the ability
		elemental:RemoveModifierByName("modifier_souloftheforest") 
		elemental:RemoveAbility("elementalist_elemental_link_unit_death") 

		return
	else
		elemental = nil
	end

	-- Lightning Elemental
	elemental = CheckElemental(caster,lightning)
	if elemental ~= nil and elemental:HasModifier("modifier_elemental_link_target")  then
		elemental:RemoveModifierByName("modifier_elemental_link_target") 
		elemental:RemoveModifierByName("modifier_elemental_link_ability")
		elemental:RemoveAbility("elementalist_lightning_elemental_electric_aura_ability")
		-- Remove the aura after removing the ability
		elemental:RemoveModifierByName("modifier_electric") 
		elemental:RemoveAbility("elementalist_elemental_link_unit_death") 

		return
	else
		elemental = nil
	end

	-- Water Elemental
	elemental = CheckElemental(caster,water)
	if elemental ~= nil and elemental:HasModifier("modifier_elemental_link_target")  then
		elemental:RemoveModifierByName("modifier_elemental_link_target") 
		elemental:RemoveModifierByName("modifier_elemental_link_ability")
		elemental:RemoveAbility("elementalist_water_elemental_water_blessing_ability")
		elemental:RemoveAbility("elementalist_elemental_link_unit_death") 

		return
	end

	-- Just in case
	return
end

--[[This function is run whenever the caster of the Elemental Link is healed]]
function OnCasterHealed( keys )
	local caster = keys.caster

	-- Keeps track of the health of the caster
	HealthTemp = HealthTemp or {}
	HealthTemp[caster] = HealthTemp[caster] or 0

	HealthTemp[caster] = caster:GetHealth() 

	--print(HealthTemp[caster])
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

function DreamgateCast( keys )
	local caster = keys.caster
	local target = keys.target_points[1]
	local team = caster:GetTeam()
	local numWisps = keys.NumberOfWisps
	local elemental

	if caster:HasModifier("modifier_dreamgate") then

		-- Creating wisps
		for i=1, numWisps do
			local wisp = CreateUnitByName("elementalist_wisp", target, true, caster, caster, team)
			wisp:SetControllableByPlayer(caster:GetPlayerID(), true)
			local wispAbility = wisp:FindAbilityByName("elementalist_wisp_phase_aura")
			wispAbility:SetLevel(1)
		end



		-- Checking if an elemental exists and then relocating him

		-- Fire Elemental
		elemental = CheckElemental(caster,fire)
		if elemental ~= nil then
			elemental:SetAbsOrigin(target+Vector(100,0,0))
			--elemental:AddNewModifier(elemental, nil, "modifier_elder_titan_echo_stomp", {}) 
			elemental = nil
		end

		-- Water Elemental
		elemental = CheckElemental(caster,water)
		if elemental ~= nil then
			elemental:SetAbsOrigin(target+Vector(75,75,0))
			elemental = nil
		end

		-- Lightning Elemental
		elemental = CheckElemental(caster,lightning)
		if elemental ~= nil then
			elemental:SetAbsOrigin(target+Vector(0,100,0))
			elemental = nil
		end

		-- Earth Elemental
		elemental = CheckElemental(caster,earth)
		if elemental ~= nil then
			elemental:SetAbsOrigin(target+Vector(-100,0,0))
			elemental = nil
		end

		-- Shadow Elemental
		elemental = CheckElemental(caster,shadow)
		if elemental ~= nil then
			elemental:SetAbsOrigin(target+Vector(0,-100,0))
			elemental = nil
		end

		caster:RemoveModifierByName("modifier_dreamgate")
	end
end

function CheckElemental( caster, elemental )
	local elementalModel = elemental

	if elemental == "phoenix" then
		elementalModel = "phoenix_bird"
	end

	local elementalTable = Entities:FindAllByModel("models/heroes/" .. elemental .. "/" .. elementalModel .. ".vmdl")
	for _,v in ipairs(elementalTable) do
		if v:GetOwner() == caster then
			return v
		end
	end
end