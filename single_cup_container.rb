require_relative 'cup_container'

class SingleCupContainer < CupContainer
  @cup = nil
  @is_frozen = true

  def add(cup)
    CupContainer.check_cup_validity(cup)
    throw RuntimeError, "#{@cup.to_s.capitalize} cup already loaded" unless @cup.nil?

    @cup = cup
  end

  def remove(cup = nil)
    throw RuntimeError, 'No cup to remove' if @cup.nil?
    @cup = nil
  end

  def empty?
    @cup.nil?
  end

  def has?(cup)
    super
    @cup == cup
  end
end
