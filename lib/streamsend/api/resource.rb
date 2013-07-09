require File.expand_path(__FILE__, "exception")

module StreamSend
  module Api
    class Resource
      def initialize(data)
        @data = data
      end

      def method_missing(method, *args, &block)
        if @data.include?(method.to_s)
          @data[method.to_s]
        else
          super
        end
      end

      def id
        @data["id"]
      end

      def self.clear_audience
        @audience_id = nil
      end

      def self.audience_id
        if @audience_id.nil?
          audiences_repsonse = StreamSend::Api.get("/audiences.xml")
          audiences_entity = audiences_repsonse.parsed_response
          audiences = audiences_entity["audiences"]
          if audiences_entity["audiences"].nil?
            raise StreamSend::Api::Exception.new("Invalid response when fetching audience. Are your credentials valid?")
          end
          audience = audiences.first
          @audience_id = audience["id"]
        end
        @audience_id
      end
    end
  end
end
