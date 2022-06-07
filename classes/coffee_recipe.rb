require_relative 'resource_containers/base_cup_container'
require_relative 'resources/water_resource'
require_relative 'resources/coffee_bean_resource'
require_relative 'resources/coffee_cup_resource'
require_relative 'resources/milk_resource'

class CoffeeRecipe
  attr_reader :ingredients, :time, :name

  def initialize(name:, water: 0, coffee_beans: 0, milk: 0, cup: :small, time: 0)
    unless [water, coffee_beans, milk, time].all? { |resource| resource.instance_of?(Integer) }
      raise TypeError, 'Quantitative resources must be of type Integer'
    end
    unless [water, coffee_beans, milk, time].all? { |resource| resource >= 0 }
      raise RangeError, 'Quantitative resources must be non-negative'
    end
    raise RangeError, 'Unknown cup type' unless BaseCupContainer.valid_cup?(cup)

    @ingredients = {}

    @ingredients[WaterResource] = water if water > 0
    @ingredients[CoffeeBeanResource] = coffee_beans if coffee_beans > 0
    @ingredients[MilkResource] = milk if milk > 0
    @ingredients[CoffeeCupResource] = cup
    @name = name
    @time = time
  end


end
