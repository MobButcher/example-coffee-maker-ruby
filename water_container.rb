require_relative 'resource_container'

class WaterContainer < ResourceContainer
  RESOURCE = 'water'.freeze
  UNIT = 'milliliter'.freeze
  UNIT_PLURAL = 'milliliters'.freeze
  UNIT_CONTRACTION = 'ml'.freeze
end