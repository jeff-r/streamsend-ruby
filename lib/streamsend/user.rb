require "active_support/core_ext/hash"

module StreamSend
  class User < Resource
    def self.all
      response = StreamSend.get("/users.xml")

      case response.code
      when 200
        response["users"].collect { |data| new(data) }
      else
        raise "Could not find any users. Make sure your account ID is correct. (#{response.code})"
      end
    end

    def self.show(id)
      response = StreamSend.get("/users/#{id}.xml")
      case response.code
      when 200
      new(response["user"])
      else
        raise "Could not find the user. Make sure your account ID and user ID are correct. (#{response.code})"
      end
    end

    def self.update(user_hash)
      response = StreamSend.put("/accounts/#{user_hash['account_id']}/users/#{user_hash['user_id']}.xml", :body => user_hash.to_xml)
      case response.code
      when 200
        true
      else
        false
      end
    end

    def self.create(user_hash)
      response = StreamSend.post("/accounts/#{user_hash['account_id']}/users.xml", :body => {:user => user_hash})

      case response.code
      when 201
        response.headers["location"] =~ /\/accounts\/\d+\/users\/(\d+)/
        user_id = $1
        user_id.to_i
      else
        raise "Could not create the user. (#{response.code})"
      end
    end
  end
end
