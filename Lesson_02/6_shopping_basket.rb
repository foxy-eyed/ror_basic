basket = {goods: {}, total_sum: 0}

delimiter = "-*-" * 20 # для красоты

puts "Что Вы хотите сделать?"

loop do
	puts "Добавить товар => add | Посмотреть корзину => show | Выйти => stop"
	choice = gets.chomp.downcase
	
	break if choice == "stop"

	puts delimiter

	if choice == "add"
		print "Введите название товара: "
		title = gets.chomp

		print "Введите цену за единицу товара: "
		price = gets.chomp.to_f

		print "Введите количество товара: "
		count = gets.chomp.to_f

		sum = price * count
		if (sum > 0)
			basket[:goods][title] = {price: price, count: count, sum: sum}
			basket[:total_sum] += sum
		else
			puts "Количество товара и цена должны быть положительными числами! Товар не добавлен в корзину!"
		end
	
	elsif choice == "show"
		basket[:goods].each do |title, item| 
			puts "#{title}: #{item[:sum].round(2)} руб. (#{item[:count]} ед. по #{item[:price]} руб.)"
		end
		puts "Итого: #{basket[:total_sum].round(2)} руб."
	
	else 
		puts "Неизвестная команда :("
	
	end
	
	puts delimiter

end
