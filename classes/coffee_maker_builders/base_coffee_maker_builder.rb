require_relative '../../coffee_maker'
require_relative '../resource_containers/water_container'
require_relative '../resource_containers/coffee_bean_container'
require_relative '../resource_containers/milk_container'
require_relative '../resource_containers/single_cup_container'
require_relative '../coffee_recipe'
require_relative '../validator'

class BaseCoffeeMakerBuilder
  # TODO: Make TOKEN private. Somehow.
  TOKEN = '57f6d568241f187200cd6071b5f495fe1b2d7d8400562ef807777d40871b35ae'.freeze # SHA256("CoffeeMakerSecret")

  def build
    @coffee_maker = CoffeeMaker.new(token: TOKEN)
  end

  private

  def set_water_container(min: 0, max:)
    Validator.integer?(min)
    Validator.integer?(max)
    Validator.non_negative?(min)
    Validator.non_negative?(max)

    container = WaterContainer.new(min: min, max: max, frozen: true)
    @coffee_maker.add_container(container, token: TOKEN)
  end

  def set_coffee_beans_container(min: 0, max:, autogrind: false)
    Validator.integer?(min)
    Validator.integer?(max)
    Validator.non_negative?(min)
    Validator.non_negative?(max)
    Validator.boolean?(autogrind)

    container = CoffeeBeanContainer.new(min: min, max: max)
    container.autogrind = autogrind
    container.freeze_bounds
    @coffee_maker.add_container(container, token: TOKEN)
  end

  def set_milk_container(min: 0, max:)
    Validator.integer?(min)
    Validator.integer?(max)
    Validator.non_negative?(min)
    Validator.non_negative?(max)

    container = MilkContainer.new(min: min, max: max, frozen: true)

    @coffee_maker.add_container(container, token: TOKEN)
  end

  def set_cup_container
    container = SingleCupContainer.new
    @coffee_maker.add_container(container, token: TOKEN)
  end

  def add_recipe(recipe)
    @coffee_maker.add_recipe(recipe, token: TOKEN)
  end

  def finish
    begin
      @coffee_maker.finish_construction(token: TOKEN)
    rescue StandardError => e
      puts 'Failed to finish construction:'
      puts e.cause
      raise e
    else
      result = @coffee_maker
      @coffee_maker = nil
      result
    end
  end
end
