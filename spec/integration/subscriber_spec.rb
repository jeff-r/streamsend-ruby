require "spec_helper"

require File.join(Dir.pwd, "lib/streamsend")
require "integration/spec_helper"
require File.expand_path(__FILE__, "../../exception")

module StreamSend
  module Api
    describe "Subscriber" do
      before do
        @account = StreamSend::Api::IntegrationConfiguration.root_account
        StreamSend::Api.configure(@account.api_username, @account.api_password, @account.app_host)
      end

      describe "with no matching subscriber" do
        it "returns nil" do
          VCR.use_cassette('streamsend') do
            expect(StreamSend::Api::Subscriber.find("bad.email@gmail.com")).to be_nil
          end
        end
      end
    end
  end
end
