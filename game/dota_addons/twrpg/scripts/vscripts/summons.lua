
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
	local checkelement = Entities:FindAllByClassname("npc_dota_creature") --[[Returns:table
	Finds all entities by class name. Returns an array containing all the found entities.
	]]

	for i, element in ipairs(checkelement) do
		if element:GetPlayerOwner() == player and element:GetModelName() == "models/heroes/phoenix/phoenix_bird.vmdl" then
			element:ForceKill(true)
		end
	end

	local fireelemental = CreateUnitByName("elementalist_fire_elemental", target, true, caster, caster, team) --[[Returns:handle
	Creates a DOTA unit by its dota_npc_units.txt name ( szUnitName, vLocation, bFindClearSpace, hNPCOwner, hUnitOwner, iTeamNumber )
	]]
	fireelemental:SetControllableByPlayer(caster:GetPlayerID(), true) --[[Returns:void
	Set this unit controllable by the player with the passed ID.
	]]
	fireelemental:CreatureLevelUp(level-1) --[[Returns:void
	Level the creature up by the specified number of levels
	]]

	if level == 1 then
		fireelemental:SetModelScale(0.20) --[[Returns:void
		Sets the model's scale to <i>scale</i>, <br/>so if a unit had its model scale at 1, and you use <i>SetModelScale(<b>10.0</b>)</i>, it would set the scale to <b>10.0</b>.
		]]
	elseif level == 2 then
		fireelemental:SetModelScale(0.40) --[[Returns:void
		Sets the model's scale to <i>scale</i>, <br/>so if a unit had its model scale at 1, and you use <i>SetModelScale(<b>10.0</b>)</i>, it would set the scale to <b>10.0</b>.
		]]
	elseif level == 3 then
		 fireelemental:SetModelScale(0.60) --[[Returns:void
		 Sets the model's scale to <i>scale</i>, <br/>so if a unit had its model scale at 1, and you use <i>SetModelScale(<b>10.0</b>)</i>, it would set the scale to <b>10.0</b>.
		 ]]
	elseif level == 4 then
		fireelemental:SetModelScale(0.80) --[[Returns:void
		Sets the model's scale to <i>scale</i>, <br/>so if a unit had its model scale at 1, and you use <i>SetModelScale(<b>10.0</b>)</i>, it would set the scale to <b>10.0</b>.
		]]
	elseif level == 5 then
		fireelemental:SetModelScale(1.00) --[[Returns:void
		Sets the model's scale to <i>scale</i>, <br/>so if a unit had its model scale at 1, and you use <i>SetModelScale(<b>10.0</b>)</i>, it would set the scale to <b>10.0</b>.
		]]
	end
end

--Earth Elemental

function SummonEarthElemental(keys)
	local caster = keys.caster
	local level = keys.ability:GetLevel()
	local player = caster:GetPlayerOwner()
	local team = caster:GetTeamNumber() 
	local heroloc = caster:GetAbsOrigin() 
	local target = keys.target_points[1]

	local earthelemental = CreateUnitByName("elementalist_earth_elemental", target, true, player, caster, team) --[[Returns:handle
	Creates a DOTA unit by its dota_npc_units.txt name ( szUnitName, vLocation, bFindClearSpace, hNPCOwner, hUnitOwner, iTeamNumber )
	]]
	earthelemental:SetControllableByPlayer(caster:GetPlayerID() , true) --[[Returns:void
	Set this unit controllable by the player with the passed ID.
	]]

	earthelemental:CreatureLevelUp(level-1) --[[Returns:void
	Level the creature up by the specified number of levels
	]]

	if level == 1 then
		earthelemental:SetModelScale(0.5) --[[Returns:void
		Sets the model's scale to <i>scale</i>, <br/>so if a unit had its model scale at 1, and you use <i>SetModelScale(<b>10.0</b>)</i>, it would set the scale to <b>10.0</b>.
		]]
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




