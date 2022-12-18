# frozen_string_literal: true

class LaunchHandler
  def initialize(params, rockets_data)
    @error = nil
    @params = params
    @launch_attributes = LaunchDTO.new(params)
    @rockets_handler = RocketsHandler.new(rockets_data)
  end

  def call
    collect_error

    attributes = launch_attributes.full.merge!(cost_per_launch: cost_per_launch) unless error

    result(attributes)
  end

  private

  attr_accessor :error
  attr_reader :params, :launch_attributes, :rockets_handler

  def result(attributes)
    {
      attributes: attributes,
      error: error
    }
  end

  def rocket
    rockets_handler.find_rocket(launch_attributes.rocket_id)
  end

  def cost_per_launch
    return unless rocket

    rockets_handler.cost_per_launch(rocket)
  end

  def collect_error
    return @error = 'Invalid rocket_id' unless rocket
    return @error = 'launch_time must be present' unless launch_attributes.launch_time
    return @error = 'periapsis_km is too small' unless launch_attributes.periapsis_distance_valid?
  end
end