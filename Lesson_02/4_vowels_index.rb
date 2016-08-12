alphabet = ("a".."z").to_a
vowels = ["a", "e", "i", "o", "u", "y"]
vowels_index = {}

i = 0
alphabet.each do |letter|
	i += 1
	vowels_index[letter] = i if vowels.include?(letter) 
end
