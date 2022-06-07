require_relative 'base_resource_container'
require_relative '../resources/coffee_bean_resource'
require_relative '../validator'

class CoffeeBeanContainer < BaseResourceContainer
  RESOURCE = CoffeeBeanResource

  def initialize(min: 0, max: 100, frozen: false)
    super(min: min, max: max, frozen: frozen)
    # Possible states:
    # :ground - coffee beans are ground and ready for consumption
    # :not_ground - coffee beans require grounding before consumption
    # Empty container assumed to be :ground.
    @state = :ground
    @autogrind = false
  end

  def add(amount)
    super
    @state = :not_ground
  end

  def grind
    @state = :ground
  end

  def autogrind=(value)
    Validator.boolean?(value)
    frozen_check

    @autogrind = value
  end

  def safe?
    !empty? && @state == :ground
  end

  def ground?
    @state == :ground
  end

  def autogrind?
    @autogrind
  end
end