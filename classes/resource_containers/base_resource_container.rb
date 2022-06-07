require_relative '../validator'

class BaseResourceContainer
  RESOURCE = 'resource'.freeze
  UNIT = 'unit'.freeze
  UNIT_PLURAL = 'units'.freeze
  UNIT_CONTRACTION = nil

  attr_reader :stored, :is_frozen

  def initialize(min: 0, max: 100, frozen: false)
    @min_value = min
    @max_value = max
    @is_frozen = frozen
    @stored = 0
  end

  def add(amount)
    Validator.integer?(amount)
    Validator.non_negative?(amount)

    unless amount + @stored <= @max_value
      raise RangeError, "#{self.class} cannot contain #{@stored} #{contracted_unit_name} of #{self.RESOURCE}"
    end

    add!(amount)
  end

  def add!(amount)
    @stored += amount
  end

  def remove(amount)
    Validator.integer?(amount)
    Validator.non_negative?(amount)

    unless amount - @stored >= @min_value
      raise RangeError, "#{self.class} does not have #{@stored} #{contracted_unit_name} of #{RESOURCE}"
    end

    remove!(amount)
  end

  def remove!(amount)
    raise RangeError, "Unable to remove #{amount} #{contracted_unit_name} of #{RESOURCE}" unless @stored >= amount

    @stored -= amount
  end

  def has?(amount)
    Validator.integer?(amount)
    Validator.non_negative?(amount)

    @stored >= amount
  end

  def unit_name
    @stored == 1 ? UNIT : UNIT_PLURAL
  end

  def contracted_unit_name
    UNIT_CONTRACTION.nil? ? unit_name : UNIT_CONTRACTION
  end

  def set_bounds(min, max)
    frozen_check
    Validator.integer?(min)
    Validator.integer?(max)
    Validator.non_negative?(min)
    Validator.non_negative?(max)

    @min_value = min
    @max_value = max
    self
  end

  def freeze_bounds
    @is_frozen = true
    self
  end

  def empty
    @stored = 0
  end

  def empty?
    @stored < @min_value || @stored.zero?
  end

  def within_bounds?
    # (@min_value...@max_value).include?(@stored)
    @min_value <= @stored && @stored <= @max_value
  end

  def safe?
    within_bounds?
  end

  protected

  def frozen_check
    raise RuntimeError, 'Container bounds have been frozen' if @is_frozen
  end
end
