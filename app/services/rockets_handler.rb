# frozen_string_literal: true

class RocketsHandler
  def initialize(rockets_data)
    @rockets_data = rockets_data
  end

  def find_rocket(rocket_id)
    return unless rocket_id

    @rockets_data.find { |rocket| rocket.fetch('rocket_id') == rocket_id }
  end

  def cost_per_launch(rocket)
    price = rocket.fetch('cost_per_launch')
    "$#{price}"
  end
end