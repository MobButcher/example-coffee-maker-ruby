require_relative 'base_coffee_maker_factory'
require_relative '../coffee_maker_builders/cheap_personal_coffee_maker_builder'
require_relative '../coffee_maker_builders/expensive_personal_coffee_maker_builder'

class PersonalCoffeeMakerFactory < BaseCoffeeMakerFactory
  MODELS = {
      :cheap => CheapPersonalCoffeeMakerBuilder,
      :expensive => ExpensivePersonalCoffeeMakerBuilder,
  }.freeze
end
