puts "Для определения вида треугольника укажите длины его сторон."
puts "Введите значения одной строкой через запятую:"

sides = gets.chomp.split(",").map! { |side| side.to_f}
sides.keep_if { |side| side > 0}
sides_count = sides.length

if sides_count < 3
	abort "Я не обнаружил во введенной строке три положительных числа! :("
end

if sides_count > 3
	sides = sides.take(3)
	puts "Вы ввели лишние значения, я оставлю для треугольника первые три: #{sides.join(', ')}."
end

sides.sort!
longest_side = sides[2]

perimeter = sides.reduce(:+)
if perimeter - longest_side <= longest_side # самая большая сторона д.б. меньше суммы двух других
	abort "Не выполняется условие существования треугольника!"
end

#все в порядке, можно проверить свойства треугольника
triangle_properties = []
if sides.uniq.length == 1
	triangle_properties.push("равносторонний")
else
	triangle_properties.push("равнобедренный") if sides.uniq.length == 2
	triangle_properties.push("прямоугольный") if longest_side**2 == (sides[0]**2 + sides[1]**2) 
end

puts triangle_properties.empty? ? "Ничем не примечательный треугольник." : "Треугольник #{triangle_properties.join(", ")}."
