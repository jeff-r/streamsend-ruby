require "spec_helper"
require File.join(Dir.pwd, "lib/streamsend")
require "integration/spec_helper"
require File.expand_path(__FILE__, "../../exception")

describe "List API" do
  let( :test_list_prefix ) { "Ruby Gem Client API List #" }
  let( :test_list_name ) { test_list_prefix }

  before do
    account = StreamSend::Api::IntegrationConfiguration.root_account
    StreamSend::Api.configure(account.api_username, account.api_password, account.app_host)
  end

  after do
    VCR.use_cassette('streamsend') do
      StreamSend::Api::List.all.select do | list |
        list.name == test_list_name
      end.each do | list |
        list.destroy
      end
    end
  end

  context "#create" do
    it "creates a list when given a unique name" do
      VCR.use_cassette('streamsend') do
        expect {
          StreamSend::Api::List.create test_list_name
        }.not_to raise_error
      end
    end

    it "returns the list id" do
      VCR.use_cassette('streamsend') do
        id = StreamSend::Api::List.create test_list_name
        id.should_not be_nil
      end
    end

    it "creating a new list with an existing name raises an error" do
      VCR.use_cassette('streamsend') do
        StreamSend::Api::List.create test_list_name
        expect {
          StreamSend::Api::List.create test_list_name
        }.to raise_error
      end
    end

    it "name is properly set on the list" do
      VCR.use_cassette('streamsend') do
        id = StreamSend::Api::List.create test_list_name
        list = StreamSend::Api::List.find id
        list.name.should == test_list_name
      end
    end
  end

  context "#delete" do
    it "removes the list" do
      VCR.use_cassette('streamsend') do
        list_id = StreamSend::Api::List.create test_list_name
        list = StreamSend::Api::List.find list_id
        list.destroy.should be_true
      end
    end
  end
end
