require_relative 'resource_containers/base_cup_container'

class CoffeeRecipe
  attr_reader :ingredients, :time, :name

  @ingredients = {}

  def initialize(name:, water: 0, coffee_beans: 0, milk: 0, cup: :small, time: 0)
    unless [water, coffee_beans, milk, time].all? { |resource| resource.instance_of?(Integer) }
      raise TypeError, 'Quantitative resources must be of type Integer'
    end
    unless [water, coffee_beans, milk, time].all? { |resource| resource >= 0 }
      raise RangeError, 'Quantitative resources must be non-negative'
    end
    raise RangeError, 'Unknown cup type' unless BaseCupContainer.valid_cup?(cup)

    @ingredients[WaterResource] = water
    @ingredients[CoffeeBeanResource] = coffee_beans
    @ingredients[MilkResource] = milk
    @ingredients[CoffeeCupResource] = cup
    @name = name
    @time = time
  end


end
