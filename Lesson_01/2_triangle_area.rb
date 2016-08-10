def get_valid_input_param(param_label)
	param = 0
	until param > 0
		puts "#{param_label}:"
		param = gets.chomp.to_f
		puts "Параметр #{param_label} должен быть положительным числом!" if param <= 0
	end
	return param
end

def calculate_triangle_area(base, height)
	area = 0.5 * base * height
	return area
end

puts "Для расчета площади треугольника укажите его основание и высоту."

base = get_valid_input_param "Основание треугольника"
height = get_valid_input_param "Высота треугольника"

area = calculate_triangle_area base, height

puts "Площадь треугольника — #{area}"
