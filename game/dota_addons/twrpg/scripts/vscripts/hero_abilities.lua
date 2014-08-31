
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

	-- Break the link if the distance limit is breached
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

function ElementalLinkAddAbility( keys )
	local target = keys.target

	if target:GetUnitName() == "elementalist_fire_elemental" then

		target:AddAbility("elementalist_fire_elemental_blazing_haste_ability")
		local blazingHaste = target:FindAbilityByName("elementalist_fire_elemental_blazing_haste_ability")
		blazingHaste:SetLevel(1)

		target:AddAbility("elementalist_fire_elemental_blazing_haste_explosion_ability")
		local blazingHasteExplosion = target:FindAbilityByName("elementalist_fire_elemental_blazing_haste_explosion_ability")
		blazingHasteExplosion:SetLevel(1)

		target:AddAbility("elementalist_elemental_link_unit_death")
		local unitDeath = target:FindAbilityByName("elementalist_elemental_link_unit_death")
		unitDeath:SetLevel(1)

	elseif target:GetUnitName() =="elementalist_lightning_elemental" then
		target:AddAbility("elementalist_lightning_elemental_electric_aura_ability")
		local electricAura = target:FindAbilityByName("elementalist_lightning_elemental_electric_aura_ability")
		electricAura:SetLevel(1)

		target:AddAbility("elementalist_elemental_link_unit_death")
		local unitDeath = target:FindAbilityByName("elementalist_elemental_link_unit_death")
		unitDeath:SetLevel(1)

	elseif target:GetUnitName() == "elementalist_water_elemental" then
		target:AddAbility("elementalist_water_elemental_water_blessing_ability")
		local waterBlessing = target:FindAbilityByName("elementalist_water_elemental_water_blessing_ability")
		waterBlessing:SetLevel(1)

		target:AddAbility("elementalist_elemental_link_unit_death")
		local unitDeath = target:FindAbilityByName("elementalist_elemental_link_unit_death")
		unitDeath:SetLevel(1)

	elseif target:GetUnitName() == "elementalist_earth_elemental" then
		target:AddAbility("elementalist_earth_elemental_souloftheforest_ability")
		local soulOfTheForest = target:FindAbilityByName("elementalist_earth_elemental_souloftheforest_ability")
		soulOfTheForest:SetLevel(1)

		target:AddAbility("elementalist_elemental_link_unit_death")
		local unitDeath = target:FindAbilityByName("elementalist_elemental_link_unit_death")
		unitDeath:SetLevel(1)
	end
end

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
			v:RemoveAbility("elementalist_water_elemental_water_blessing_ability")
			v:RemoveAbility("elementalist_elemental_link_unit_death")
			print("Link recast check 5")
			return
		end
	end
	print("Link recast check 6")

end