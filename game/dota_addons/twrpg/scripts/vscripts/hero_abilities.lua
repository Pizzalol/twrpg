
--[[A link spell between 2 targets
	Gets the location of the two targets and compares the distance between them
	If the distance is greater than the link breaking point then it breaks the link]]
function ElementalLink( keys )
	local caster = keys.caster
	local casterloc = caster:GetAbsOrigin()
	local target = keys.target
	local targetloc = target:GetAbsOrigin()
	DeepPrintTable( keys )

	print(casterloc)
	print(targetloc)
	-- Distance calculation
	local targetdistance = casterloc - targetloc
	local distance = targetdistance:Length2D()

	print("Distance between the two targets " .. distance)

	-- Break the link if the distance limit is breached
	if distance >= 1000 then
		caster:RemoveModifierByName("modifier_elemental_link_caster")
		target:RemoveModifierByName("modifier_elemental_link_target")
		print("Link is broken")
		if target:GetUnitName() == "elementalist_fire_elemental" then
			target:RemoveAbility("elementalist_fire_elemental_blazing_haste_ability")
			target:RemoveAbility("elementalist_fire_elemental_blazing_haste_explosion_ability")
		end
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
	end
end