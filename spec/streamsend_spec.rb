require File.join(File.dirname(__FILE__), "spec_helper")

describe StreamSend::Api do
  describe ".configure" do
    let( :test_host ) { "http://host.example.com" }
    let( :test_user ) { "John+Carter@example.com" }
    let( :test_password ) { "this-is-a-really-secure-password" }

    it "should set username" do
      StreamSend::Api.configure( test_user, test_password )
      StreamSend::Api.default_options[:basic_auth][:username].should == test_user
    end

    it "should set password" do
      StreamSend::Api.configure( test_user, test_password )
      StreamSend::Api.default_options[:basic_auth][:password].should == test_password
    end

    context "host" do
      it "sets the host when specified" do
        StreamSend::Api.configure( test_user, test_password, test_host )
        StreamSend::Api.base_uri.should == test_host
      end

      it "uses the default host when not specified" do
        StreamSend::Api.configure( test_user, test_password )
        StreamSend::Api.base_uri.should == "http://app.streamsend.com"
      end
    end
  end
end
