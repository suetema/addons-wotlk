function BC.HasBuff(unit, textureName)
	local i = 1
	while UnitBuff(unit, i) do
		local texture = UnitBuff(unit, i)
		if string.find(texture, textureName) then
			return true
		end
		i = i + 1
	end
	return false
end

function BC.HasDebuff(unit, textureName)
	local i = 1
	while UnitDebuff(unit, i) do
		local texture, applications = UnitDebuff(unit, i)
		if string.find(texture, textureName) then
			return applications
		end
		i = i + 1
	end
	return 0
end
