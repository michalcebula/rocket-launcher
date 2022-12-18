# frozen_string_literal: true
require 'rails_helper'

RSpec.describe LaunchDTO do
  describe '#periapsis_distance_valid?' do
    subject { described_class.new(launch_params) }

    let(:launch_params) do
      {
        rocket_id: 'saturn V',
        launch_time: '2022-12-13 09:24:38 UTC',
        periapsis_km: 160
      }
    end

    context 'when periapsis distance is valid' do
      it 'returns true' do
        expect(subject.periapsis_distance_valid?).to be_truthy
      end  
    end

    context 'when periapisis distance is too small' do
      before { launch_params.merge!({ periapsis_km: 100 }) }

      it 'returns false' do
        expect(subject.periapsis_distance_valid?).to be_falsey
      end
    end

    context 'when periapsis distance is nil' do
      before { launch_params.merge!({ periapsis_km: nil }) }

      it 'returns false' do
        expect(subject.periapsis_distance_valid?).to be_falsey
      end
    end
  end
end