require "active_support/core_ext/hash"

module StreamSend
  class Account < Resource
    def self.all
      response = StreamSend.get("/accounts.xml")

      case response.code
      when 200
        response["accounts"].collect { |data| new(data) }
      else
        raise "Could not find any accouns. Make sure your api username and password are correct. (#{response.code})"
      end
    end

    def self.show(id)
      response = StreamSend.get("/accounts/#{id}.xml")
      case response.code
      when 200
      new(response["account"])
      else
        raise "Could not find the account. Make sure your account ID is correct. (#{response.code})"
      end
    end

    def self.update(account_hash)
      response = StreamSend.put("/accounts/#{account_hash['account_id']}/users/#{account_hash['user_id']}.xml", :body => account_hash.to_xml)
      case response.code
      when 200
        true
      else
        false
      end
    end

    def self.create(account_hash)
      response = StreamSend.post("/accounts.xml", :body => {:account => account_hash})
      debugger
      case response.code
      when 201
        response.headers["location"] =~ %r(/accounts/(\d+))
        account_id = $1
        account_id.to_i
      else
        raise "Could not create the account. (#{response.code})"
      end
    end
  end
end
