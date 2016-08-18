basket = {}

delimiter = "-*-" * 20 # для красоты

puts "Что Вы хотите сделать?"

loop do
	puts "Добавить товар => add | Посмотреть корзину => show | Выйти => stop"
	choice = gets.chomp.downcase
	
	break if choice == "stop"

	puts delimiter

	if choice == "add"
		print "Введите название товара: "
		title = gets.chomp.to_sym

		print "Введите цену за единицу товара: "
		price = gets.chomp.to_f

		print "Введите количество товара: "
		count = gets.chomp.to_f

		sum = price * count
		if (sum > 0)
			basket[title] = Hash.new(0) if !basket[title]
			basket[title][:price] = price # цену перезапишем, вдруг инфляция?
			basket[title][:count] += count # кол-во прибавим
			basket[title][:sum] = price * basket[title][:count] # итог пересчитаем по новой цене
		else
			puts "Количество товара и цена должны быть положительными числами! Товар не добавлен в корзину!"
		end
	
	elsif choice == "show"
		total_sum = 0
		basket.each do |title, item| 
			puts "#{title}: #{item[:sum].round(2)} руб. (#{item[:count]} ед. по #{item[:price]} руб.)"
			total_sum += item[:sum]
		end
		puts "Итого: #{total_sum.round(2)} руб."
	
	else 
		puts "Неизвестная команда :("
	
	end
	
	puts delimiter

end
