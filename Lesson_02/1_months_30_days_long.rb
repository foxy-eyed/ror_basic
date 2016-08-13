months = {
	January: {duration: 31, name: "Январь"},
	February: {duration: 28, name: "Февраль"},
	March: {duration: 31, name: "Март"},
	April: {duration: 30, name: "Апрель"},
	May: {duration: 31, name: "Май"},
	June: {duration: 30, name: "Июнь"},
	July: {duration: 31, name: "Июль"},
	August: {duration: 31, name: "Август"},
	September: {duration: 30, name: "Сентябрь"},
	October: {duration: 31, name: "Октябрь"},
	November: {duration: 30, name: "Ноябрь"},
	December: {duration: 31, name: "Декабрь"}
}

puts "Месяцы длиной в 30 дней:"

months.each_value { |month| puts month[:name] if month[:duration] == 30 }
