# frozen_string_literal: true
require 'rails_helper'

RSpec.describe SpaceXData::V3::Client do
  describe '#get' do
    let(:client) { described_class }

    context 'when path is valid' do
      let(:path) { '/info' }

      it 'returns object with successful response' do
        response = client.get(path)
        body = JSON.parse(response.body).with_indifferent_access

        expect(response.code).to eq '200'
        expect(body).to include(name: 'SpaceX', founder: 'Elon Musk')
      end
    end

    context 'when path is invalid' do
      let(:path) { '/some-invalid-path' }

      it 'returns object with failure response' do
        response = client.get(path)

        expect(response.code).to eq '404'
        expect(response.body).to eq 'Not Found'
      end
    end
  end
end
