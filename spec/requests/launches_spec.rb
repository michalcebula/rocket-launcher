require 'rails_helper'

RSpec.describe "/launches", type: :request do
  describe "POST /create" do
    let(:valid_attributes) do
      {
        rocket_id: 'falconheavy',
        site_name: 'KSC LC 39A',
        customer: 'Iridium',
        periapsis_km: 190,
        launch_time: '2022-12-13 09:24:38 UTC'
      }
    end

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
      let(:error_message) { JSON.parse(response.body)['error'] }
      context "with invalid rocket id" do
        let(:invalid_attributes) { valid_attributes.merge(rocket_id: 'invalid_rocket_name') }

        it "renders a JSON response with errors for the new launch" do
          post launches_url, params: { launch: invalid_attributes }, as: :json

          expect(response).to have_http_status(:unprocessable_entity)
          expect(error_message).to eq 'Invalid rocket_id'
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end

      context "with invalid periapsis distance" do
        let(:invalid_attributes) { valid_attributes.merge(periapsis_km: 100) }

        it "renders a JSON response with errors for the new launch" do
          post launches_url, params: { launch: invalid_attributes }, as: :json

          expect(response).to have_http_status(:unprocessable_entity)
          expect(error_message).to eq 'periapsis_km is too small'
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end

      context "without launch time" do
        let(:invalid_attributes) { valid_attributes.merge(launch_time: nil) }

        it "renders a JSON response with errors for the new launch" do
          post launches_url, params: { launch: invalid_attributes }, as: :json

          expect(response).to have_http_status(:unprocessable_entity)
          expect(error_message).to eq 'launch_time must be present'
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
    end
  end
end
