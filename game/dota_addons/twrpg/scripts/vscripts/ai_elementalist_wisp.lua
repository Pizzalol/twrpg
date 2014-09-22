--[[
Elementalist Wisp AI
]]

require( "ai_core" )

behaviorSystem = {} -- create the global so we can assign to it

function Spawn( entityKeyValues )
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
	--thisEntity:AddNewModifier(thisEntity, nil, "modifier_phased", {}) 
    --behaviorSystem = AICore:CreateBehaviorSystem( { BehaviorFollow, BehaviorAttack, BehaviorReturn, BehaviorRunAway } )
    behaviorSystem = AICore:CreateBehaviorSystem( { BehaviorFollow, BehaviorAttack, BehaviorReturn } ) 
end

function AIThink() -- For some reason AddThinkToEnt doesn't accept member functions
       return behaviorSystem:Think()
end


owner = thisEntity:GetOwner()
result = {owner:GetAbsOrigin()+Vector(100,0,0),
owner:GetAbsOrigin()+Vector(100,100,0),
owner:GetAbsOrigin()+Vector(0,100,0),
owner:GetAbsOrigin()+Vector(-100,0,0),
owner:GetAbsOrigin()+Vector(-100,-100,0),
owner:GetAbsOrigin()+Vector(0,-100,0),
owner:GetAbsOrigin()+Vector(100,-100,0),
owner:GetAbsOrigin()+Vector(-100,100,0)}

POSITIONS_retreat = result
--------------------------------------------------------------------------------------------------------

BehaviorFollow = {}

function BehaviorFollow:Evaluate()
	return 1 -- must return a value > 0, so we have a default
end

function BehaviorFollow:Begin()
	self.endTime = GameRules:GetGameTime() + 1
	
	--local owner = thisEntity:GetOwner()
	
	if owner then
		self.order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_TARGET,
			TargetIndex = owner:entindex()
		}
	else
		self.order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_STOP
		}
	end
end

function BehaviorFollow:Continue()
	self.endTime = GameRules:GetGameTime() + 1

	result = {owner:GetAbsOrigin()+Vector(100,0,0),
	owner:GetAbsOrigin()+Vector(100,100,0),
	owner:GetAbsOrigin()+Vector(0,100,0),
	owner:GetAbsOrigin()+Vector(-100,0,0),
	owner:GetAbsOrigin()+Vector(-100,-100,0),
	owner:GetAbsOrigin()+Vector(0,-100,0),
	owner:GetAbsOrigin()+Vector(100,-100,0),
	owner:GetAbsOrigin()+Vector(-100,100,0)}
	
	POSITIONS_retreat = result

	local happyPlaceIndex =  RandomInt( 1, #POSITIONS_retreat )
	escapePoint = POSITIONS_retreat[ happyPlaceIndex ]

	self.order =
	{
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = escapePoint
		
	}
end

--------------------------------------------------------------------------------------------------------

BehaviorAttack = {}

function BehaviorAttack:Evaluate()
	self.dismemberAbility = thisEntity:FindAbilityByName("creature_dismember")
	local target
	local desire = 0
	local range = thisEntity:GetAttackRange() 

	-- let's not choose this twice in a row
	if AICore.currentBehavior == self then return desire end

	--[[if self.dismemberAbility and self.dismemberAbility:IsFullyCastable() then
		local range = self.dismemberAbility:GetCastRange()
		target = AICore:RandomEnemyHeroInRange( thisEntity, range )
	end]]

	target = AICore:RandomEnemyHeroInRange(thisEntity, range)

	if target then
		desire = 2
		self.target = target
	end

	return desire
end

function BehaviorAttack:Begin()
	self.endTime = GameRules:GetGameTime() + 2

	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		UnitIndex = thisEntity:entindex(),
		TargetIndex = self.target:entindex()
	}
end

BehaviorAttack.Continue = BehaviorAttack.Begin --if we re-enter this ability, we might have a different target; might as well do a full reset

function BehaviorAttack:Think(dt)
	if not self.target:IsAlive() then
		self.endTime = GameRules:GetGameTime()
		return
	end
end

--------------------------------------------------------------------------------------------------------

BehaviorReturn = {}

function BehaviorReturn:Evaluate()
	local desire = 0
	local vDistance
	
	-- let's not choose this twice in a row
	--[[if currentBehavior == self then return desire end

	self.hookAbility = thisEntity:FindAbilityByName( "creature_meat_hook" )
	
	if self.hookAbility and self.hookAbility:IsFullyCastable() then
		self.target = AICore:RandomEnemyHeroInRange( thisEntity, self.hookAbility:GetCastRange() )
		if self.target then
			desire = 4
		end
	end


	local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			local enemyVec = enemy:GetOrigin() - thisEntity:GetOrigin()
			local myForward = thisEntity:GetForwardVector()
			local dotProduct = enemyVec:Dot( myForward ) 
			if dotProduct > 0 then
				desire = 2
			end
		end
	end ]]

	vDistance = (thisEntity:GetOrigin() - owner:GetOrigin()):Length2D() 

	if vDistance >= 500 then
		desire = 4
	else
		desire = 1
	end

	return desire
end

function BehaviorReturn:Begin()
	self.endTime = GameRules:GetGameTime() + 1
	
	--local owner = thisEntity:GetOwner()
	thisEntity:SetOrigin(owner:GetOrigin()+Vector(100,100,0))
	
	if owner then
		self.order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_TARGET,
			TargetIndex = owner:entindex()
		}
	else
		self.order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_STOP
		}
	end

end

function BehaviorReturn:Continue()
	self.endTime = GameRules:GetGameTime() + 1	
end

--------------------------------------------------------------------------------------------------------
--[[
BehaviorRunAway = {}

function BehaviorRunAway:Evaluate()
	local desire = 0
	local happyPlaceIndex =  RandomInt( 1, #POSITIONS_retreat )
	escapePoint = POSITIONS_retreat[ happyPlaceIndex ]
	-- let's not choose this twice in a row
	if currentBehavior == self then return desire end
	
	local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
	if #enemies > 0 then
		desire = #enemies
	end 
	
	for i=0,DOTA_ITEM_MAX-1 do
		local item = thisEntity:GetItemInSlot( i )
		if item and item:GetAbilityName() == "item_force_staff" then
			self.forceAbility = item
		end
		if item and item:GetAbilityName() == "item_phase_boots" then
			self.phaseAbility = item
		end
		if item and item:GetAbilityName() == "item_ancient_janggo" then
			self.drumAbility = item
		end
		if item and item:GetAbilityName() == "item_urn_of_shadows" then
			self.urnAbility = item
		end
	end
	
	return desire
end


function BehaviorRunAway:Begin()
	self.endTime = GameRules:GetGameTime() + 6

	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		UnitIndex = thisEntity:entindex(),
		TargetIndex = thisEntity:entindex(),
		AbilityIndex = self.forceAbility:entindex()
	}
end

function BehaviorRunAway:Think(dt)
	
	ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			TargetIndex = thisEntity:entindex(),
			AbilityIndex = self.forceAbility:entindex()
		})
		
	if self.forceAbility and not self.forceAbility:IsFullyCastable() then
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = escapePoint
		})
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.drumAbility:entindex()
		})
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.phaseAbility:entindex()
		})
	end
	
	if self.urnAbility and self.urnAbility:IsFullyCastable() and self.endTime < GameRules:GetGameTime() + 2 then
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			TargetIndex = thisEntity:entindex(),
			AbilityIndex = self.urnAbility:entindex()
		})
	end
end

BehaviorRunAway.Continue = BehaviorRunAway.Begin

--------------------------------------------------------------------------------------------------------

AICore.possibleBehaviors = { BehaviorFollow, BehaviorAttack, BehaviorReturn, BehaviorRunAway }
]]
AICore.possibleBehaviors = { BehaviorFollow, BehaviorAttack, BehaviorReturn }