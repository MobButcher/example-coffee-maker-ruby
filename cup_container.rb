require_relative 'resource_container'

class CupContainer < ResourceContainer
  RESOURCE = 'cups'.freeze
  UNIT = 'cup'.freeze
  UNIT_PLURAL = 'cups'.freeze
  UNIT_CONTRACTION = nil

  VALID_CUPS = %i[small, medium, large]

  def self.valid_cup?(cup)
    VALID_CUPS.include?(cup)
  end

  def has?(cup)
    CupContainer.check_cup_validity(cup)

    false
  end

  protected

  def self.check_cup_validity(cup)
    throw RangeError, "Invalid cup size" unless CupContainer.valid_cup?(cup)
  end
end
