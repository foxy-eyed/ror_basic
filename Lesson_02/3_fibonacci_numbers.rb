fibonacci_numbers = [0]

number = 1
until number > 100 do
	fibonacci_numbers << number
	number = fibonacci_numbers.last(2).reduce(:+)
end
