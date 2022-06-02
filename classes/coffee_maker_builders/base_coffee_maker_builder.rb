require_relative '../../coffee_maker'
require_relative '../resource_containers/water_container'
require_relative '../resource_containers/coffee_bean_container'
require_relative '../resource_containers/milk_container'
require_relative '../resource_containers/single_cup_container'
require_relative '../coffee_recipe'

class BaseCoffeeMakerBuilder
  TOKEN = '57f6d568241f187200cd6071b5f495fe1b2d7d8400562ef807777d40871b35ae'.freeze # SHA256("CoffeeMakerSecret")
  @coffee_maker = nil

  def build
    @coffee_maker = CoffeeMaker.new(token: TOKEN)
  end

  private

  def water_container(min: 0, max:)
    container = WaterContainer.new.set_bounds(min, max)
    @coffee_maker._set_water_container(container.freeze_bounds)
  end

  def coffee_beans_container(min: 0, max:, autogrind: false)
    container = CoffeeBeanContainer.new.set_bounds(min, max)
    container.autogrind = autogrind
    @coffee_maker._set_coffee_bean_container(container.freeze_bounds)
  end

  def milk_container(min: 0, max:)
    container = MilkContainer.new.set_bounds(min, max)
    @coffee_maker._set_milk_container(container.freeze_bounds)
  end

  def cup_container
    container = SingleCupContainer.new
    @coffee_maker._set_cup_container(container)
  end

  def finish
    begin
      @coffee_maker.finish_construction
    rescue StandardError => e
      puts "Failed to finish construction:"
      puts e.cause
    else
      result = @coffee_maker
      @coffee_maker = nil
      return result
    end
  end
end
