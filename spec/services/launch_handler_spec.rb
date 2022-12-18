# frozen_string_literal: true
require 'rails_helper'

RSpec.describe LaunchHandler do
  subject { described_class.new(params, rockets_data).call }

  describe '#call' do
    let(:rocket) { { 'rocket_id' => rocket_id, 'cost_per_launch' => cost_per_launch } }
    let(:rockets_data) { [rocket] }
    let(:launch_d_t_o) do
      double(
        :launch_d_t_o,
        full: params,
        rocket_id: params[:rocket_id],
        launch_time: params[:launch_time]
      )
    end
    let(:rockets_handler) { double(:rockets_handler) }
    
    before(:each) do
      allow(LaunchDTO).to receive(:new).with(params).and_return(launch_d_t_o)
      allow(launch_d_t_o).to receive(:periapsis_distance_valid?).and_return(true)
      allow(RocketsHandler).to receive(:new).with(rockets_data).and_return(rockets_handler)
      allow(rockets_handler).to receive(:find_rocket).with(rocket_id).and_return(rocket)
      allow(rockets_handler).to receive(:cost_per_launch).with(rocket).and_return(cost_per_launch)
    end

    context 'with valid params and rockets_data' do
      let(:rocket_id) { 'saturn V' }
      let(:cost_per_launch) { 1969 }
      let(:params) do
        { rocket_id: rocket_id, launch_time: '2022-12-13 09:24:38 UTC', periapsis_km: 160 }
      end
      let(:expected_attributes) { params.merge(cost_per_launch: cost_per_launch)}

      before { allow(launch_d_t_o).to receive(:periapsis_distance_valid?).and_return(true) }

      it 'returns result with attributes' do
        result = subject

        expect(result).to include(:attributes, :error)
        expect(result[:error]).to be_nil
        expect(result[:attributes]).to eq expected_attributes
      end
    end

    context 'with invalid params' do
      context 'when params has invalid rocket_id' do
        let(:rocket_id) { 'invalid_rocket_id' }
        let(:rocket) { nil }
        let(:cost_per_launch) { 1969 }
        let(:params) do
          { rocket_id: rocket_id, launch_time: '2022-12-13 09:24:38 UTC', periapsis_km: 160 }
        end

        it 'returns result with error message' do
          result = subject

          expect(result).to include(:attributes, :error)
          expect(result[:error]).to eq 'Invalid rocket_id'
          expect(result[:attributes]).to be_nil
        end
      end

      context 'when params has invalid launch time' do
        let(:rocket_id) { 'saturn V' }
        let(:cost_per_launch) { 1969 }
        let(:params) do
          { rocket_id: rocket_id, launch_time: nil, periapsis_km: 160 }
        end

        it 'returns result with error message' do
          result = subject

          expect(result).to include(:attributes, :error)
          expect(result[:error]).to eq 'launch_time must be present'
          expect(result[:attributes]).to be_nil
        end
      end

      context 'when params has invalid rocket_id' do
        let(:rocket_id) { 'saturn V' }
        let(:cost_per_launch) { 1969 }
        let(:params) do
          { rocket_id: rocket_id, launch_time: '2022-12-13 09:24:38 UTC', periapsis_km: 100 }
        end

        before { allow(launch_d_t_o).to receive(:periapsis_distance_valid?).and_return(false) }

        it 'returns result with error message' do
          result = subject

          expect(result).to include(:attributes, :error)
          expect(result[:error]).to eq 'periapsis_km is too small'
          expect(result[:attributes]).to be_nil
        end
      end
    end
  end
end

   