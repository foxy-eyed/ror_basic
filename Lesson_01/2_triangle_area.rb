def get_valid_input(param_label)
	value = 0
	until value > 0
		puts "#{param_label}:"
		value = gets.chomp.to_f
		puts "Параметр #{param_label} должен быть положительным числом!" if value <= 0
	end
	value
end

def calculate_triangle_area(base, height)
	0.5 * base * height
end

puts "Для расчета площади треугольника укажите его основание и высоту."

base = get_valid_input("Основание треугольника")
height = get_valid_input("Высота треугольника")

area = calculate_triangle_area(base, height)

puts "Площадь треугольника — #{area}"
