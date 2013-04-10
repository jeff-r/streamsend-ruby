require File.join(Dir.pwd, "lib/streamsend")
require "integration/spec_helper"
require File.expand_path(__FILE__, "../../exception")

describe "List API" do
  let( :test_list_prefix ) { "Ruby Gem Client API List #" }
  let( :seed ) { Time.now.to_i.to_s + SecureRandom.random_number( 1000 ).to_s }
  let( :test_list_name ) { test_list_prefix + seed.to_s }

  before do
    account = StreamSend::Api::IntegrationConfiguration.root_account
    StreamSend::Api.configure(account.api_username, account.api_password, account.app_host)
  end

  after do
    StreamSend::Api::List.all.select do | list |
      list.name == test_list_name
    end.each do | list |
      list.destroy
    end
  end

  context "#create" do
    it "creates a list when given a unique name" do
      expect {
        StreamSend::Api::List.create test_list_name
      }.not_to raise_error
    end

    it "returns the list id" do
      id = StreamSend::Api::List.create test_list_name
      id.should_not be_nil
    end

    it "creating a new list with an existing name raises an error" do
      StreamSend::Api::List.create test_list_name
      expect {
        StreamSend::Api::List.create test_list_name
      }.to raise_error
    end

    it "name is properly set on the list" do
      id = StreamSend::Api::List.create test_list_name
      list = StreamSend::Api::List.find id
      list.name.should == test_list_name
    end
  end

  context "#delete" do
    it "removes the list" do
      list_id = StreamSend::Api::List.create test_list_name
      list = StreamSend::Api::List.find list_id
      list.destroy.should be_true
    end
  end
end
