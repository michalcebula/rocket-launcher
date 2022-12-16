# frozen_string_literal: true
require 'net/http'

module SpaceXData
  module V3
    class Client
      BASE_URL = 'https://api.spacexdata.com/v3'.freeze

      def self.get(path)
        Net::HTTP.send(:get_response, uri(path))
      end

      private

      def self.uri(path)
        URI(BASE_URL + path)
      end
    end
  end
end
