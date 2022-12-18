# frozen_string_literal: true
require 'net/http'

class LaunchesController < ApplicationController
  # See the https://docs.spacexdata.com/#intro for more information about SpaceX API
  def create
    launch_attributes = launch_params(params)
    launch_time = launch_attributes.fetch(:launch_time)
    periapsis_km = launch_attributes.fetch(:periapsis_km)

    response = SpaceXData::V3::ListRockets.new.call
    rockets_handler = RocketsHandler.new(response.body)

    rocket = rockets_handler.find_rocket(launch_attributes.fetch(:rocket_id))

    return render json: { error: 'Invalid rocket_id' }, status: :unprocessable_entity unless rocket
    return render json: { error: 'launch_time must be present' }, status: :unprocessable_entity if launch_time.blank?
    return render json: { error: 'periapsis_km is too small' }, status: :unprocessable_entity if periapsis_km < 150

    cost_per_launch = rockets_handler.cost_per_launch(rocket)
    launch_attributes.merge!(cost_per_launch: cost_per_launch)

    render json: launch_attributes, status: :created
  end

  private

  def launch_params(params)
    params.require(:launch).permit(:rocket_id, :site_name, :customer, :periapsis_km, :launch_time)
  end
end
