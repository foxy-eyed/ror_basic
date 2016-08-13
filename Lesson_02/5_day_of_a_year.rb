MONTHS = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

def leap_year?(year)
	((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)
end

def validate(d, m, y)
	errors = []
	
	errors << "До 45 года до н.э. не было юлианского календаря, там другой отсчёт!" if y < -45
	errors << "Месяц должен быть числом от 1 до 12." if m <= 0 || m > 12
	errors << "День не может быть отрицательным числом!" if d <= 0

	if errors.empty?
		max_day_in_month = (m == 2 && leap_year?(y)) ? 29 : MONTHS[m - 1]
		errors << "В указанном месяце #{max_day_in_month} дней, вы ввели #{d}." if d > max_day_in_month
	end

	errors.empty? ? {success: true} : {success: false, errors: errors}
end

def day_number(d, m, y)
	day_number = MONTHS.take(m - 1).reduce(:+) + d
	leap_year?(y) && (m > 2) ? day_number + 1 : day_number
end


puts "Введите число:"
d = gets.chomp.to_i

puts "Введите месяц:"
m = gets.chomp.to_i

puts "Введите год:"
y = gets.chomp.to_i

validation_result = validate(d, m, y)

puts validation_result[:success] ? day_number(d, m, y) : validation_result[:errors]
