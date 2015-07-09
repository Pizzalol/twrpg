
function dreamgate( keys )
	local caster = keys.caster
	local target_point = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_dreamgate = keys.modifier_dreamgate
	local modifier_wisp = keys.modifier_wisp

	if caster:HasModifier(modifier_dreamgate) then

		local wisp = CreateUnitByName("elementalist_wisp", target_point, false, caster, caster, caster:GetTeamNumber())
		wisp:SetControllableByPlayer(caster:GetPlayerID(), true)

		ability:ApplyDataDrivenModifier(caster, wisp, modifier_wisp, {})
	end
end