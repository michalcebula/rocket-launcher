require "rails_helper"

RSpec.describe LaunchesController, type: :routing do
  describe "routing" do
    it "routes to #create" do
      expect(post: "/launches").to route_to("launches#create")
    end
  end
end
