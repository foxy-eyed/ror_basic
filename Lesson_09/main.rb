require_relative 'controllers/controller'
require_relative 'modules/accessors'
require_relative 'modules/instance_counter'
require_relative 'modules/validation'
require_relative 'modules/vendor'
require_relative 'models/station'
require_relative 'models/cargo_wagon'
require_relative 'models/cargo_train'
require_relative 'models/passenger_train'
require_relative 'models/passenger_wagon'

data = {
  trains: [
    { number: "123-45", type: 1, wagons_count: 5, wagons_capacity: 75.2 },
    { number: "234-56", type: 1, wagons_count: 10, wagons_capacity: 138 },
    { number: "345-67", type: 1, wagons_count: 9, wagons_capacity: 80.5 },
    { number: "16999", type: 2, wagons_count: 7, wagons_capacity: 48 },
    { number: "99111", type: 2, wagons_count: 3, wagons_capacity: 81 }
  ],
  stations: ["New Vasyuki", "Old Vasyuki", "Moscow", "Samara"]
}

puts "Добро пожаловать!"

controller = Controller.new
controller.init(data)

loop do
  controller.show_actions
  choice = gets.chomp.downcase
  break if choice == 'exit'
  controller.run_action(choice)
end
