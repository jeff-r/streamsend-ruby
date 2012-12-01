require File.join(Dir.pwd, "lib/streamsend")
require "integration/spec_helper.rb"

describe "user via api" do
  before do
    @account = StreamSend::Api::IntegrationConfiguration.root_account
    StreamSend::Api.configure(@account.api_username, @account.api_password, @account.app_host)
  end

  describe ".all" do
    it "lists all accounts" do
      accounts = StreamSend::Api::Account.all
      accounts.count.should > 0
    end
  end

  describe ".show" do
    it "finds the root account" do
      root_account = StreamSend::Api::Account.show(1)
      root_account.name.should == "EZ Publishing"
    end
  end

  describe ".create" do
    it "creates a new account" do
      create_result = StreamSend::Api::Account.create(
        :name => "account2",
        :automated_email_address => "admin@localhost.com",
        :quota => 100,
        :quota_cap => 100,
        :plan_id => 1,
        :owner => {
          "password" => "password2",
          "password_confirmation" => "password2",
          "email_address" => "joe+#{Time.now.to_i}@gmail.com",
          "first_name" => "Joe",
          "last_name" => "user",
          "may_export" => true,
          "administrator" => true
      })
    end
  end
end
