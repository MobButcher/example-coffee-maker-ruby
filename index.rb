require_relative 'classes/coffee_maker_factories/personal_coffee_maker_factory'

coffee_maker = PersonalCoffeeMakerFactory.new.build(:cheap)

coffee_maker.turn_on
coffee_maker.load_coffee_beans(300)
coffee_maker.load_water(1000)
coffee_maker.load_coffee_cup(:small)
coffee_maker.select_recipe(0) # Index-based selection
coffee_maker.start
coffee_maker.wait(2)
coffee = coffee_maker.take_coffee

puts coffee.name
