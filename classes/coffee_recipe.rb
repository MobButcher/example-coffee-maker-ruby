require_relative 'resource_containers/base_cup_container'

class CoffeeRecipe
  attr_reader :water, :coffee_beans, :milk, :cup, :time

  def initialize(name:, water: 0, coffee_beans: 0, milk: 0, cup: :small, time: 0)
    unless [water, coffee_beans, milk, time].all? { |resource| resource.instance_of?(Integer) }
      throw TypeError, 'Quantitative resources must be of type Integer'
    end
    unless [water, coffee_beans, milk, time].all? { |resource| resource >= 0 }
      throw RangeError, 'Quantitative resources must be non-negative'
    end
    throw RangeError, 'Unknown cup type' unless BaseCupContainer.valid_cup?(cup)

    @water = water
    @coffee_beans = coffee_beans
    @milk = milk
    @cup = cup
    @time = time
  end
end
