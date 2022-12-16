require 'rails_helper'

RSpec.describe "/launches", type: :request do
  let(:valid_attributes) do
    {
      rocket_id: 'falconheavy',
      site_name: 'KSC LC 39A',
      customer: 'Iridium',
      periapsis_km: 190,
      launch_time: '2022-12-13 09:24:38 UTC'
    }
  end

  let(:invalid_attributes) { valid_attributes.merge(rocket_id: 'invalid_rocket_name') }

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Launch" do
        post launches_url, params: { launch: valid_attributes }, as: :json

        expect(JSON.parse(response.body)).to eq(
          'rocket_id' => 'falconheavy',
          'site_name' => 'KSC LC 39A',
          'customer' => 'Iridium',
          'periapsis_km' => 190,
          'launch_time' => "2022-12-13 09:24:38 UTC",
          'cost_per_launch' => '$90000000'
        )
      end

      it "renders a JSON response with the new launch" do
        post launches_url,
             params: { launch: valid_attributes }, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the new launch" do
        post launches_url, params: { launch: invalid_attributes }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end
end
