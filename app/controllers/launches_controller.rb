# frozen_string_literal: true
require 'net/http'

class LaunchesController < ApplicationController
  # See the https://docs.spacexdata.com/#intro for more information about SpaceX API
  def create
    launch_attributes = LaunchDTO.new(launch_params(params))

    response = SpaceXData::V3::ListRockets.new.call
    rockets_handler = RocketsHandler.new(response.body)
    rocket = rockets_handler.find_rocket(launch_attributes.rocket_id)

    unless rocket
      return render  json: { error: 'Invalid rocket_id' }, status: :unprocessable_entity; end
    unless launch_attributes.launch_time
      return render json: { error: 'launch_time must be present' }, status: :unprocessable_entity; end
    unless launch_attributes.periapsis_distance_valid?
      return render json: { error: 'periapsis_km is too small' }, status: :unprocessable_entity; end

    cost_per_launch = rockets_handler.cost_per_launch(rocket)
    launch_attributes = launch_attributes.full.merge!(cost_per_launch: cost_per_launch)
    
    return render json: launch_attributes, status: :created if Launch.create(launch_attributes)

    render json: { error: 'Something went wrong. Please, try again'}, status: :unprocessable_entity
  end

  private

  def launch_params(params)
    params.require(:launch).permit(:rocket_id, :site_name, :customer, :periapsis_km, :launch_time)
  end
end
