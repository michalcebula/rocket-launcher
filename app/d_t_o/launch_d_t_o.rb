# frozen_string_literal: true

class LaunchDTO
  MIN_PERIAPSIS_DISTANCE = 150.freeze

  attr_reader :full, :rocket_id, :launch_time, :periapsis_km

  def initialize(launch_params)
    @full = launch_params
    @rocket_id = launch_params.fetch(:rocket_id)
    @launch_time = launch_params.fetch(:launch_time)
    @periapsis_km = launch_params.fetch(:periapsis_km)
  end

  def periapsis_distance_valid?
    return false unless periapsis_km

    periapsis_km > MIN_PERIAPSIS_DISTANCE
  end
end