require "active_support/core_ext/hash"

module StreamSend
  module Api
    class User < Resource
      def self.all
        response = StreamSend::Api.get("/users.xml")

        case response.code
        when 200
          response["users"].collect { |data| new(data) }
        else
          raise StreamSend::Api::Exception.new("Could not find any users. Make sure your account ID is correct. (#{response.code})")
        end
      end

      def self.show(id)
        response = StreamSend::Api.get("/users/#{id}.xml")
        case response.code
        when 200
          new(response["user"])
        else
          raise StreamSend::Api::Exception.new("Could not find the user. Make sure your account ID and user ID are correct. (#{response.code})")
        end
      end

      def self.update(user_hash)
        response = StreamSend::Api.put("/accounts/#{user_hash['account_id']}/users/#{user_hash['user_id']}.xml", :body => user_hash.to_xml)
        case response.code
        when 200
          true
        else
          false
        end
      end

      def self.create(user_hash)
        response = StreamSend::Api.post("/accounts/#{user_hash['account_id']}/users.xml", :body => {:user => user_hash})
        case response.code
        when 201
          response.headers["location"] =~ /\/accounts\/\d+\/users\/(\d+)/
          user_id = $1
          user_id.to_i
        else
          raise StreamSend::Api::Exception.new("Could not create the user. (#{response.code})")
        end
      end
    end
  end
end
