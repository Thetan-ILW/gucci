local function getStrainMultiplier(s)
	if s < 500000 then
		return s / 500000 * 0.1
	elseif s < 600000 then
		return (s - 500000) / 100000 * 0.3
	elseif s < 700000 then
		return (s - 600000) / 100000 * 0.25 + 0.3
	elseif s < 800000 then
		return (s - 700000) / 100000 * 0.2 + 0.55
	elseif s < 900000 then
		return (s - 800000) / 100000 * 0.15 + 0.75
	else
		return (s - 900000) / 100000 * 0.1 + 0.9
	end
end

-- SOURCE: maniapp.uy.to
return function(notes, star_rate, od, score)
	local strain = math.pow(5 * math.max(1, star_rate / 0.2) - 4, 2.2) / 135 * (1 + 0.1 * math.min(1, notes / 1500))
	local strain_multiplier = getStrainMultiplier(score)

	local accuracy_value = 0

	if score >= 960000 then
		accuracy_value = od * 0.02 * strain * math.pow((score - 960000) / 40000, 1.1)
	end

	return (0.73 * math.pow(math.pow(accuracy_value, 1.1) + math.pow(strain * strain_multiplier, 1.1), 1 / 1.1) * 1.1)
end
