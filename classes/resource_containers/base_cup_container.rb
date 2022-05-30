require_relative 'base_resource_container'

class BaseCupContainer < BaseResourceContainer
  RESOURCE = 'cups'.freeze
  UNIT = 'cup'.freeze
  UNIT_PLURAL = 'cups'.freeze
  UNIT_CONTRACTION = nil

  VALID_CUPS = %i[small, medium, large]

  def self.valid_cup?(cup)
    VALID_CUPS.include?(cup)
  end

  def has?(cup)
    BaseCupContainer.check_cup_validity(cup)

    false
  end

  protected

  def self.check_cup_validity(cup)
    throw RangeError, "Invalid cup size" unless BaseCupContainer.valid_cup?(cup)
  end
end
