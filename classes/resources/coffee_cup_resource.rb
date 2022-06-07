require_relative 'base_resource'

class CoffeeCupResource < BaseResource
  NAME = 'cups'.freeze
  UNIT = 'cup'.freeze
  UNIT_PLURAL = 'cups'.freeze

  VALID_SIZES = %i[small medium large]

  def self.valid_size?(size)
    VALID_SIZES.include?(size)
  end
end
