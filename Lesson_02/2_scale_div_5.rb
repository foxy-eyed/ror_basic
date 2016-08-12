def scale(min, max, step)
	scale = []
	number = min
	until number > max do
		scale << number
		number += step
	end
	scale
end

puts scale(10, 100, 15)
