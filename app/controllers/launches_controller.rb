# frozen_string_literal: true
require 'net/http'

class LaunchesController < ApplicationController
  # See the https://docs.spacexdata.com/#intro for more information about SpaceX API
  def create
    response = SpaceXData::V3::ListRockets.new.call
    result = LaunchHandler.new(launch_params(params), response.body).call

    error_message = result[:error]
    return render json: { error: error_message }, status: :unprocessable_entity if error_message

    launch_attributes = result[:attributes]
    return render json: launch_attributes, status: :created if Launch.create(launch_attributes)

    render json: { error: 'Something went wrong. Please, try again'}, status: :unprocessable_entity
  end

  private

  def launch_params(params)
    params.require(:launch).permit(:rocket_id, :site_name, :customer, :periapsis_km, :launch_time)
  end
end
