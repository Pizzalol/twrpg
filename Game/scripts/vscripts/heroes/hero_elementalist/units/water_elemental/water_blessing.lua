bitTable = {512,256,128,64,32,16,8,4,2,1}
--[[Author: Pizzalol
	Restores mana to the target and increases their primary attribute]]
function water_blessing( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local attribute_pct = ability:GetLevelSpecialValueFor("attribute_pct", ability_level) / 100
	local mana_restore_pct = ability:GetLevelSpecialValueFor("mana_restore_pct", ability_level)
	local target_max_mana = target:GetMaxMana()
	local primary_attribute = target:GetPrimaryAttribute()

	-- Determine the primary attribute
	local attribute
	local modifier_name
	-- 0 STR
	-- 1 AGI
	-- 2 INT
	if primary_attribute == 0 then
		attribute = target:GetStrength()
		modifier_name = "strength"
	elseif primary_attribute == 1 then
		attribute = target:GetAgility()
		modifier_name = "agility"
	else
		attribute = target:GetIntellect()
		modifier_name = "intellect" 
	end
	 
	 -- Calculate the attribute bonus
	local attribute_increase = math.floor(attribute * attribute_pct)

	-- Apply the bonus
	for p=1, #bitTable do
		local val = bitTable[p]
		local count = math.floor(attribute_increase / val)
		if count >= 1 then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_" .. modifier_name .. "_mod_" .. val, {})
			attribute_increase = attribute_increase - val
		end
	end

	-- Restore the targets mana by a percentage
	target:GiveMana(target_max_mana * mana_restore_pct)

end

--[[Author: Pizzalol
	Triggers upon expiration and removes the water blessing buffs]]
function water_blessing_remove( keys )
	local caster = keys.caster
	local target = keys.target
	local primary_attribute = target:GetPrimaryAttribute() 
	local modifier_name

	-- Determine the primary attribute
	-- 0 STR
	-- 1 AGI
	-- 2 INT
	if primary_attribute == 0 then
		modifier_name = "strength"
	elseif primary_attribute == 1 then
		modifier_name = "agility"
	else
		modifier_name = "intellect" 
	end
	
 
	-- Gets the list of modifiers on the hero and loops through removing attribute modifiers
	local modCount = target:GetModifierCount()
	for i = 0, modCount do
		for u = 1, #bitTable do
			local val = bitTable[u]
			if target:GetModifierNameByIndex(i) == "modifier_".. modifier_name .. "_mod_" .. val  then
				target:RemoveModifierByNameAndCaster("modifier_" .. modifier_name .. "_mod_" .. val, caster)
			end
		end
	end
end