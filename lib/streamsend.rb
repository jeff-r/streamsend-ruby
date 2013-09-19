require 'rubygems'
require 'httparty'

require "streamsend/api/resource"
require "streamsend/api/subscriber"
require "streamsend/api/list"
require "streamsend/api/user"
require "streamsend/api/account"
require "streamsend/api/exception"

module StreamSend
  module Api
    include HTTParty
    format :xml

    def self.configure(username, password, host = "app.streamsend.com")
      base_uri host
      basic_auth username, password
      StreamSend::Api::Subscriber.clear_audience
    end
  end
end
