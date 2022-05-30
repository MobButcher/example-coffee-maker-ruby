require_relative 'base_resource_container'
require_relative '../mixins/expireable'

class MilkContainer < BaseResourceContainer
  include Expireable
  RESOURCE = 'milk'.freeze
  UNIT = 'milliliter'.freeze
  UNIT_PLURAL = 'milliliters'.freeze
  UNIT_CONTRACTION = 'ml'.freeze

  TIME_BEFORE_EXPIRY = 15

  def safe?
    @stored >= @min_value && !expired?
  end

  def remove(amount)
    super
    # If we clean all milk, there is no contaminated milk left.
    @time_elapsed = 0 if @stored.zero?
  end
end
