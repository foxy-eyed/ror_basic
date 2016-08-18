require_relative 'controller.rb'

require_relative 'cargo_wagon.rb'
require_relative 'cargo_train.rb'
require_relative 'passenger_train.rb'
require_relative 'passenger_wagon.rb'
require_relative 'station.rb'

controller = Controller.new

puts "Добро пожаловать!"

loop do
  controller.show_actions
  choice = gets.chomp.downcase
  break if choice == 'exit'
  controller.run_action(choice)
end
