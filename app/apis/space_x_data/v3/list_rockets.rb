# frozen_string_literal: true

module SpaceXData
  module V3
    class ListRockets
      PATH = '/rockets'

      def initialize(client: Client)
        @client = client
      end

      def call
        @response = client.get(PATH)
        
        result.new(
          body: body,
          code: response.code,
          status: response.msg,
        )
      end

      private

      attr_reader :response, :client

      def body
        JSON.parse(response.body)
      end

      def result
        Struct.new(:body, :code, :status, keyword_init: true)
      end
    end
  end
end
