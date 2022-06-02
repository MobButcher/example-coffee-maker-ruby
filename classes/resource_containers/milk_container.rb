require_relative 'base_resource_container'
require_relative '../mixins/expireable'
require_relative '../resources/milk_resource'

class MilkContainer < BaseResourceContainer
  include Expireable
  RESOURCE = MilkResource

  TIME_BEFORE_EXPIRY = 15

  def safe?
    @stored >= @min_value && !expired?
  end

  def remove(amount)
    super
    # If we clean all milk, there is no contaminated milk left.
    @time_elapsed = 0 if @stored.zero?
  end

  def empty
    super
    @time_elapsed = 0
  end
end
