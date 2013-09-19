require File.expand_path(__FILE__, "exception")

module StreamSend
  module Api
    class Subscriber < Resource
      def self.all
        options = { :per_page => 1_000, :page => 0 }
        last_gathered_count = 1
        sbuscribers = []

        until last_gathered_count == 0
          gathered = self.index( options )
          subscribers.concat( gathered )
          options[:page] = options[:page]+1
          last_gathered_count = gatehred.count
        end
        subscribers
      end

      def self.index(options = {})
        response = StreamSend::Api.get("/audiences/#{audience_id}/people.xml", :query => options)

        case response.code
        when 200
          response["people"].collect { |data| new(data) }
        else
          raise StreamSend::Api::ApiException.new("Error response (#{response.code}), Make sure your audience ID is correct. (audience_id => #{audience_id})")
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
          raise StreamSend::Api::Exception.new("Could not find the subscriber. Make sure your audience ID is correct. (#{response.code})")
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
          raise StreamSend::Api::Exception.new("Could not create the subscriber. (#{response.code})")
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
          raise StreamSend::Api::Exception.new("Could not show the subscriber. (#{response.code})")
        end
      end

      def activate
        response = StreamSend::Api.post("/audiences/#{audience_id}/people/#{id}/activate.xml")

        case response.code
        when 200
          true
        else
          raise StreamSend::Api::Exception.new("Could not activate the subscriber. (#{response.code})")
        end
      end

      def unsubscribe
        response = StreamSend::Api.post("/audiences/#{audience_id}/people/#{id}/unsubscribe.xml")

        case response.code
        when 200
          true
        else
          raise StreamSend::Api::Exception("Could not subscribe the subscriber. (#{response.code})")
        end
      end

      def destroy
        response = StreamSend::Api.delete("/audiences/#{audience_id}/people/#{id}.xml")
        case response.code
        when 200
          true
        when 423
          raise LockedError, "Can not delete"
        else
          raise UnexpectedResponse, response.code
        end
      end
    end
  end
end
