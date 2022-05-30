require_relative 'base_resource_container'

class CoffeeBeanContainer < BaseResourceContainer
  RESOURCE = 'coffee beans'.freeze
  UNIT = 'gram'.freeze
  UNIT_PLURAL = 'grams'.freeze
  UNIT_CONTRACTION = 'g'.freeze

  # Possible states:
  # :ground - coffee beans are ground and ready for consumption
  # :not_ground - coffee beans require grounding before consumption
  # Empty container assumed to be :ground.
  @state = :ground
  @autogrind = false

  def add(amount)
    super
    @state = :not_ground
  end

  def grind
    @state = :ground
  end

  def autogrind=(value)
    throw TypeError, 'Value must be boolean' unless [true, false].include?(value)
    frozen_check

    @autogrind = value
    return self
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