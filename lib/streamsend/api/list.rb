require File.expand_path(__FILE__, "exception")

module StreamSend
  module Api
    class List < Resource
      def self.all
        response = StreamSend::Api.get("/audiences/#{audience_id}/lists.xml")

        case response.code
        when 200
          response["lists"].collect { |data| new(data) }
        else
          raise StreamSend::Api::Exception.new("Could not find any lists. (#{response.code})")
        end
      end

      def self.find(list_id)
        response = StreamSend::Api.get("/audiences/#{audience_id}/lists/#{list_id}.xml")

        case response.code
        when 200
          new(response["list"])
        else
          raise StreamSend::Api::Exception.new("Could not find any lists. (#{response.code})")
        end
      end

      def self.create(list_name)
        response = StreamSend::Api.post("/audiences/#{audience_id}/lists.xml", :query => {:list => {:name => list_name}})

        if response.code == 201
          response.headers["location"] =~ /audiences\/\d\/lists\/(\d+)$/
          new_list_id = $1.to_i
        else
          raise StreamSend::Api::Exception.new("Could not create a list. (#{response.body})")
        end
      end

      def destroy
        self.class.destroy( id )
      end

      def self.destroy( id )
        id_as_integer = id.to_i
        response = StreamSend::Api.delete("/audiences/#{audience_id}/lists/#{id_as_integer}.xml")
        case response.code
        when 200
          true
        else
          raise StreamSend::Api::Exception.new "Could not delete list (#{response.code})."
        end
      end
    end
  end
end
