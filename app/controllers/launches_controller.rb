# frozen_string_literal: true
require 'net/http'

class LaunchesController < ApplicationController
  # See the https://docs.spacexdata.com/#intro for more information about SpaceX API
  def create
    launch_attributes = params.fetch('launch', {}).slice(
      *["rocket_id", "site_name", "customer", "periapsis_km", "launch_time"]
    )

    uri = URI('https://api.spacexdata.com/v3/rockets')
    all_available_rockets = JSON.parse(Net::HTTP.get(uri))
    all_available_rockets_ids = all_available_rockets.map { |rocket| rocket.fetch("rocket_id")}

    rocket_id = launch_attributes.fetch(:rocket_id)
    if !all_available_rockets_ids.include?(rocket_id)
      render json: { error: 'Invalid rocket_id' }, status: :unprocessable_entity
    elsif launch_attributes.fetch(:launch_time).blank?
      render json: { error: 'launch_time must be present' }, status: :unprocessable_entity
    elsif launch_attributes.fetch(:periapsis_km) < 150
      render json: { error: 'periapsis_km is too small' }, status: :unprocessable_entity
    else
      cost_per_launch = all_available_rockets.find { |rocket| rocket['rocket_id'] == rocket_id }.fetch("cost_per_launch")
      cost_per_launch = "$#{cost_per_launch}"

      launch_attributes.merge!(cost_per_launch: cost_per_launch)

      render json: launch_attributes, status: :created
    end
  end
end
