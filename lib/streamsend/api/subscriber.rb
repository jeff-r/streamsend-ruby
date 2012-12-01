module StreamSend
  module Api
    class Subscriber < Resource
      def self.all
        response = StreamSend::Api.get("/audiences/#{audience_id}/people.xml")

        case response.code
        when 200
          response["people"].collect { |data| new(data) }
        else
          raise "Could not find any subscribers. Make sure your audience ID is correct. (#{response.code})"
        end
      end

      def self.find(email_address)
        response = StreamSend::Api.get("/audiences/#{audience_id}/people.xml?email_address=#{email_address}")

        case response.code
        when 200
          if subscriber = response["people"].first
            new(subscriber)
          else
            nil
          end
        else
          raise "Could not find the subscriber. Make sure your audience ID is correct. (#{response.code})"
        end
      end

      def self.create(person_hash)
        response = StreamSend::Api.post("/audiences/#{audience_id}/people.xml", :query => {:person => person_hash})

        case response.code
        when 201
          response.headers["location"] =~ /audiences\/\d+\/people\/(\d+)$/
          subscriber_id = $1
          unless subscriber_id.nil?
            subscriber_id.to_i
          end
        else
          raise "Could not create the subscriber. (#{response.code})"
        end
      end

      def show
        response = StreamSend::Api.get("/audiences/#{audience_id}/people/#{id}.xml")

        case response.code
        when 200
          if subscriber = response["person"]
            self.class.new(subscriber)
          else
            nil
          end
        else
          raise "Could not show the subscriber. (#{response.code})"
        end
      end

      def activate
        response = StreamSend::Api.post("/audiences/#{audience_id}/people/#{id}/activate.xml")

        case response.code
        when 200
          true
        else
          raise "Could not activate the subscriber. (#{response.code})"
        end
      end

      def unsubscribe
        response = StreamSend::Api.post("/audiences/#{audience_id}/people/#{id}/unsubscribe.xml")

        case response.code
        when 200
          true
        else
          raise "Could not subscribe the subscriber. (#{response.code})"
        end
      end
    end
  end
end
