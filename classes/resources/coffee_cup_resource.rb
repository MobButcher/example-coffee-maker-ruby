require_relative 'base_resource'

class CoffeeCupResource < BaseResource
  NAME = 'cups'.freeze
  UNIT = 'cup'.freeze
  UNIT_PLURAL = 'cups'.freeze

  VALID_SIZES = %i[small medium large]
end
