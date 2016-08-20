require_relative 'controllers/controller'

require_relative 'models/cargo_wagon'
require_relative 'models/cargo_train'
require_relative 'models/passenger_train'
require_relative 'models/passenger_wagon'
require_relative 'models/station'

controller = Controller.new

puts "Добро пожаловать!"

loop do
  controller.show_actions
  choice = gets.chomp.downcase
  break if choice == 'exit'
  controller.run_action(choice)
end
