# frozen_string_literal: true
require 'rails_helper'

RSpec.describe RocketsHandler do
  subject { described_class.new(rockets_data) }

  let(:rockets_data) do
    [
      { 'rocket_id' => 'saturn V', 'cost_per_launch' => 1969 },
      { 'rocket_id' => 'atlas V', 'cost_per_launch' => 2002 }
    ]
  end

  describe '#find_rocket' do
    context 'when rocket_id is valid' do
      let(:rocket_id) { 'saturn V' }

      it 'returns a rocket data' do
        expect(subject.find_rocket(rocket_id)).to include('rocket_id' => 'saturn V', 'cost_per_launch' => 1969)
      end
    end

    context 'when rocket_id is nil' do
      let(:rocket_id) { nil }

      it 'returns nil' do
        expect(subject.find_rocket(rocket_id)).to be_nil
      end
    end
  end

  describe '#cost_per_launch' do
    subject { described_class.new(rockets_data) }

    context 'when cost per launch is available' do
      let(:rocket) { { 'rocket_id' => 'saturn V', 'cost_per_launch' => 1969 } }

      it 'returns a formatted price' do
        expect(subject.cost_per_launch(rocket)).to eq '$1969'
      end
    end

    context 'when cost per launch is not available' do
      let(:rocket) { { 'rocket_id' => 'saturn V' } }

      it 'raises error' do
        expect { subject.cost_per_launch(rocket) }.to raise_error(KeyError)
      end
    end
  end
end
