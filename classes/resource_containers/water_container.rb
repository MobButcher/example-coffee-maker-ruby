require_relative 'base_resource_container'

class WaterContainer < BaseResourceContainer
  RESOURCE = 'water'.freeze
  UNIT = 'milliliter'.freeze
  UNIT_PLURAL = 'milliliters'.freeze
  UNIT_CONTRACTION = 'ml'.freeze
end