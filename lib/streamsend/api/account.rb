require "active_support/core_ext/hash"
require File.expand_path(__FILE__, "exception")

module StreamSend
  module Api
    class Account < Resource
      def self.all
        response = StreamSend::Api.get("/accounts.xml")

        case response.code
        when 200
          response["accounts"].collect { |data| new(data) }
        else
          raise StreamSend::Api::Exception.new("Could not find any accounts. Make sure your api username and password are correct. (#{response.code})")
        end
      end

      def self.show(id)
        response = StreamSend::Api.get("/accounts/#{id}.xml")
        case response.code
        when 200
          new(response["account"])
        else
          raise StreamSend::Api::Exception.new("Could not find the account. Make sure your account ID is correct. (#{response.code})")
        end
      end

      def self.update(account_hash)
        response = StreamSend::Api.put("/accounts/#{account_hash['account_id']}/users/#{account_hash['user_id']}.xml", :body => account_hash.to_xml)
        case response.code
        when 200
          true
        else
          false
        end
      end

      def self.create(account_hash)
        response = StreamSend::Api.post("/accounts.xml", :body => {:account => account_hash})
        case response.code
        when 201
          response.headers["location"] =~ %r(/accounts/(\d+))
          account_id = $1
          account_id.to_i
        else
          raise StreamSend::Api::Exception.new("Could not create the account. (#{response.code})")
        end
      end

      def self.destroy(id)
        id = id.to_i
        response = StreamSend::Api.delete("/accounts/#{id}.xml")
        case response.code
        when 200
          true
        else
          raise StreamSend::Api::Exception.new("Could not delete the account. (#{response.code})")
        end
      end
    end
  end
end
