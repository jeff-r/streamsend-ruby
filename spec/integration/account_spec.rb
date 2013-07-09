require "spec_helper"

require File.join(Dir.pwd, "lib/streamsend")
require "integration/spec_helper"
require File.expand_path(__FILE__, "../../exception")

describe "user via api" do
  before do
    @account = StreamSend::Api::IntegrationConfiguration.root_account
    StreamSend::Api.configure(@account.api_username, @account.api_password, @account.app_host)
  end

  let(:create_account) do
    pending "TODO -> Broken 2013-04-05"
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

  describe ".all" do
    it "lists all accounts" do
      VCR.use_cassette('streamsend') do
        accounts = StreamSend::Api::Account.all
        accounts.count.should > 0
      end
    end
  end

  describe ".show" do
    it "finds the root account" do
      VCR.use_cassette('streamsend') do
        root_account = StreamSend::Api::Account.show(1)
        root_account.name.should == "EZ Publishing"
      end
    end
  end

  describe ".create" do
    it "creates a new account" do
      VCR.use_cassette('streamsend') do
        id = create_account
        StreamSend::Api::Account.destroy(id)
      end
    end
  end

  describe ".destroy" do
    it "deletes an account" do
      VCR.use_cassette('streamsend') do
        id = create_account
        response = StreamSend::Api::Account.destroy(id)
        response.should == true
        expect { StreamSend::Api::Account.show(id) }.to raise_exception(StreamSend::Api::Exception, /could not find/i)
      end
    end
  end
end
