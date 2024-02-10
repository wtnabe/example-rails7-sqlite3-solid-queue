class StoreRandomContentsJob < ApplicationJob
  queue_as :default

  KILO = 1024
  MEGA = KILO ** 2

  #
  # @param [Integer] length
  # @param [Symbol] unit
  #
  def perform(length, *rest, unit: :kilo)
    random_contents(length * parse_unit(unit))
    Content.create(blob: 'done')
  end

  #
  # @param [Symbol|String] unit
  # @return [Number] 
  #
  def parse_unit(unit)
    self.class.const_get(unit.upcase)
  end   
  
  # @param [Integer] length
  # @return [String]
  #
  def random_contents(length)
    (1..length).to_a.map { |e|
      Random.rand(32..126).chr
    }.join
  end
end
