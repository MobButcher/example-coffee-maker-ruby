require_relative 'resources/coffee_cup_resource'
require_relative 'validator'

class Coffee
  attr_reader :name

  def initialize(size, name)
    Validator.of_type?(String, name)
    raise ArgumentError, 'Invalid cup size' unless CoffeeCupResource.valid_size?(size)

    @size = size
    @name = name
  end
end