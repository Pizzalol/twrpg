
function KillSummon( keys )
	local caster = keys.caster
	caster:ForceKill(true) --[[Returns:void
	Kill this unit immediately.
	]]
	print("ded summon")
end




-- Fire Elemental

function SummonFireElemental(keys)
	local caster = keys.caster
	local level = keys.ability:GetLevel()
	local player = caster:GetPlayerOwner()
	local team = caster:GetTeamNumber() 
	local heroloc = caster:GetAbsOrigin() 
	local target = keys.target_points[1]
	local modelScale = keys.ModelScale
	local HPScale = keys.HPScale
	local casterInt = caster:GetIntellect()
	print(modelScale)
	print(HPScale)

	local checkelement = Entities:FindAllByModel("models/heroes/phoenix/phoenix_bird.vmdl")

	for i, element in ipairs(checkelement) do
		if element:GetPlayerOwner() == player then
			element:ForceKill(true)
		end
	end

	local fireelemental = CreateUnitByName("elementalist_fire_elemental", target, true, caster, caster, team)
	fireelemental:SetControllableByPlayer(caster:GetPlayerID(), true) 
	fireelemental:CreatureLevelUp(level-1)
	fireelemental:SetModelScale(modelScale)
	fireelemental:SetMaxHealth(HPScale*casterInt)
	fireelemental:SetHealth(fireelemental:GetMaxHealth())

	--[[if level == 1 then
		fireelemental:SetModelScale(0.20) 
	elseif level == 2 then
		fireelemental:SetModelScale(0.40) 
	elseif level == 3 then
		 fireelemental:SetModelScale(0.60)
	elseif level == 4 then
		fireelemental:SetModelScale(0.80) 
	elseif level == 5 then
		fireelemental:SetModelScale(1.00) 
	end]]
end

--Earth Elemental

function SummonEarthElemental(keys)
	local caster = keys.caster
	local level = keys.ability:GetLevel()
	local player = caster:GetPlayerOwner()
	local team = caster:GetTeamNumber() 
	local heroloc = caster:GetAbsOrigin() 
	local target = keys.target_points[1]
	local modelScale = keys.ModelScale
	local HPScale = keys.HPScale
	local casterInt = caster:GetIntellect()

	local checkelement = Entities:FindAllByModel("models/heroes/treant_protector/treant_protector.vmdl")

	for i, element in ipairs(checkelement) do
		if element:GetPlayerOwner() == player then
			element:ForceKill(true)
		end
	end

	local earthelemental = CreateUnitByName("elementalist_earth_elemental", target, true, caster, caster, team)
	earthelemental:SetControllableByPlayer(caster:GetPlayerID() , true)
	earthelemental:CreatureLevelUp(level-1)
	earthelemental:SetModelScale(modelScale)
	earthelemental:SetMaxHealth(casterInt*HPScale)
	earthelemental:SetHealth(earthelemental:GetMaxHealth())

	if level == 1 then
		earthelemental:SetModelScale(0.5) 
		earthelemental:AddAbility("elementalist_earth_elemental_thorns_ability") --[[Returns:void
		Add an ability to this unit by name.
		]]
		local earthability = earthelemental:FindAbilityByName("elementalist_earth_elemental_thorns_ability") --[[Returns:handle
		Retrieve an ability by name from the unit.
		]]
		print("hello")
		earthability:SetLevel(1) --[[Returns:void
		Sets the level of this ability.
		]]
		--earthelemental:AddNewModifier(earthelemental, nil, "modifier_item_assault_positive", {bonus_attack_speed = 35 , armor = 10}) --[[Returns:void
		--No Description Set
		--]]
		print("hello again")
	end
end

function SummonLightningElemental(keys)
	local caster = keys.caster
	local level = keys.ability:GetLevel()
	local player = caster:GetPlayerOwner()
	local team = caster:GetTeamNumber() 
	local heroloc = caster:GetAbsOrigin() 
	local target = keys.target_points[1]
	local modelScale = keys.ModelScale
	local HPScale = keys.HPScale
	local casterInt = caster:GetIntellect()
	print(modelScale)
	print(HPScale)

	local checkelement = Entities:FindAllByModel("models/heroes/razor/razor.vmdl")

	for i, element in ipairs(checkelement) do
		if element:GetPlayerOwner() == player then
			element:ForceKill(true)
		end
	end

	local lightningelemental = CreateUnitByName("elementalist_lightning_elemental", target, true, caster, caster, team)
	lightningelemental:SetControllableByPlayer(caster:GetPlayerID(), true) 
	lightningelemental:CreatureLevelUp(level-1)
	lightningelemental:SetModelScale(modelScale)
	lightningelemental:SetMaxHealth(HPScale*casterInt)
	lightningelemental:SetHealth(lightningelemental:GetMaxHealth())
	lightningelemental:SetMana(0)

	--[[if level == 1 then
		fireelemental:SetModelScale(0.20) 
	elseif level == 2 then
		fireelemental:SetModelScale(0.40) 
	elseif level == 3 then
		 fireelemental:SetModelScale(0.60)
	elseif level == 4 then
		fireelemental:SetModelScale(0.80) 
	elseif level == 5 then
		fireelemental:SetModelScale(1.00) 
	end]]
end


function SummonWaterElemental(keys)
	local caster = keys.caster
	local level = keys.ability:GetLevel()
	local player = caster:GetPlayerOwner()
	local team = caster:GetTeamNumber() 
	local heroloc = caster:GetAbsOrigin() 
	local target = keys.target_points[1]
	local modelScale = keys.ModelScale
	local HPScale = keys.HPScale
	local casterInt = caster:GetIntellect()
	print(modelScale)
	print(HPScale)

	local checkelement = Entities:FindAllByModel("models/heroes/morphling/morphling.vmdl")

	for i, element in ipairs(checkelement) do
		if element:GetPlayerOwner() == player then
			element:ForceKill(true)
		end
	end

	local waterelemental = CreateUnitByName("elementalist_water_elemental", target, true, caster, caster, team)
	waterelemental:SetControllableByPlayer(caster:GetPlayerID(), true) 
	waterelemental:CreatureLevelUp(level-1)
	waterelemental:SetModelScale(modelScale)
	waterelemental:SetMaxHealth(HPScale*casterInt)
	waterelemental:SetHealth(waterelemental:GetMaxHealth())

	--[[if level == 1 then
		fireelemental:SetModelScale(0.20) 
	elseif level == 2 then
		fireelemental:SetModelScale(0.40) 
	elseif level == 3 then
		 fireelemental:SetModelScale(0.60)
	elseif level == 4 then
		fireelemental:SetModelScale(0.80) 
	elseif level == 5 then
		fireelemental:SetModelScale(1.00) 
	end]]
end



