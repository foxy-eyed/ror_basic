puts "Для решения квадратного уравнения вида a*x^2 + b*x + c = 0\nтребуется ввести коэффициенты a, b, c."

puts "Коэффициент a:"
a = gets.chomp.to_f

puts "Коэффициент b:"
b = gets.chomp.to_f

puts "Коэффициент c:"
c = gets.chomp.to_f

if a == 0
	if b == 0 
		puts "Это не уравнение, a и b одновременно не могут быть нулями!"
	else
		root = -c / b
		puts "Уравнение при a = 0 уже не квадратное, а линейное,\nно посчитать корень мне не трудно: x = #{root}."
	end
else
	discriminant = b**2 - 4 * a * c

	puts "Дискриминант = #{discriminant}."

	if discriminant < 0 
		puts "Действительных корней нет."
	elsif discriminant == 0
		root = -b * 0.5 / a
		puts "Корни равны: x1 = x2 = #{root}."
	else
		root1 = (-b - Math.sqrt(discriminant)) * 0.5 / a
		root2 = (-b + Math.sqrt(discriminant)) * 0.5 / a
		puts "Уравнение имеет два корня: x1 = #{root1}; x2 = #{root2}."
	end 
end
