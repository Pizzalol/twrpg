
--[[A link spell between 2 targets
	Gets the location of the two targets and compares the distance between them
	If the distance is greater than the link breaking point then it breaks the link]]
function ElementalLink( keys )
	local caster = keys.caster
	local casterloc = caster:GetAbsOrigin()
	local target = keys.target
	local targetloc = target:GetAbsOrigin()

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
	end
end