require_relative 'base_coffee_maker_builder'

class ExpensivePersonalCoffeeMakerBuilder < BaseCoffeeMakerBuilder
  def build
    super
    set_water_container(min: 500, max: 2500)
    set_milk_container(min: 0, max: 2500)
    set_coffee_beans_container(min: 0, max: 1000)
    set_cup_container
    # TODO: Add recipes
    finish
  end
end