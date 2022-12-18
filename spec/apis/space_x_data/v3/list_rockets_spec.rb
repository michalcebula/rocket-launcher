# frozen_string_literal: true
require 'rails_helper'

RSpec.describe SpaceXData::V3::ListRockets do
  describe '#call' do
    subject { described_class.new(client: fake_client) }

    let(:fake_client) { double(:client) }
    let(:path) { described_class::PATH}
    let(:body) { [{ 'rocket_id' => 'saturn' }, { 'rocket_id' => 'apollo' }] }
    let(:response) { double(:response, body: JSON.dump(body), code: '200', msg: 'OK') }

    before do
      allow(fake_client).to receive(:get).with(path).and_return(response)
    end

    it 'returns object with rockets call result' do
      result = subject.call

      expect(result.body).to eq body
      expect(result.code).to eq '200'
      expect(result.status).to eq 'OK'
    end
  end
end
