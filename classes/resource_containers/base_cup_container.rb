require_relative 'base_resource_container'
require_relative '../resources/coffee_cup_resource'

class BaseCupContainer < BaseResourceContainer
  RESOURCE = CoffeeCupResource

  def self.valid_cup?(cup)
    CoffeeCupResource::VALID_SIZES.include?(cup)
  end

  def has?(cup)
    BaseCupContainer.check_cup_validity(cup)

    false
  end

  private_class_method :check_cup_validity

  def self.check_cup_validity(cup)
    throw RangeError, 'Invalid cup size' unless BaseCupContainer.valid_cup?(cup)
  end
end
