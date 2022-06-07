require_relative 'base_coffee_maker_builder'
require_relative '../coffee_recipe'

class CheapPersonalCoffeeMakerBuilder < BaseCoffeeMakerBuilder
  def build
    super
    set_water_container(min: 500, max: 1500)
    set_coffee_beans_container(min: 0, max: 500)
    set_cup_container
    add_recipe(CoffeeRecipe.new(
      name: 'Espresso',
      water: 150,
      coffee_beans: 5,
      cup: :small,
      time: 2
    ))
    finish
  end
end