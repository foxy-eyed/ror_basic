puts "Как тебя зовут?"
name = gets.chomp

puts "Какой у тебя рост (в сантиметрах)?"
height = gets.chomp.to_i

perfect_weight = height - 110

puts perfect_weight > 0 ? "#{name}, твой идеальный вес — #{perfect_weight} кг" : "#{name}, твой вес оптимален!"
