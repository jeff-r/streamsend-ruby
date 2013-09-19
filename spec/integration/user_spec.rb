require "spec_helper"
require File.join(Dir.pwd, "lib/streamsend")
require "integration/spec_helper.rb"

describe "user via api" do
  before do
    account = StreamSend::Api::IntegrationConfiguration.root_account
    StreamSend::Api.configure(account.api_username, account.api_password, account.app_host)
  end

  it "exists" do
    VCR.use_cassette('streamsend') do
      the_user = StreamSend::Api::User.all.first
      the_user.first_name.should == "Admin"
    end
  end

  it "gets created" do
    VCR.use_cassette('streamsend') do
      the_user = StreamSend::Api::User.create(
        "password" => "password2",
        "password_confirmation" => "password2",
        "email_address" => "joe#{Time.now.to_i}@gmail.com",
        "first_name" => "Joe",
        "last_name" => "user",
        "account_id" => 1,
        "may_export" => true,
        "administrator" => true
      )

      saved_user = find_by_email_address("joe@gmail.com")
      saved_user.first.id.should > 0
    end
  end

  it "can be found" do
    VCR.use_cassette('streamsend') do
      user = StreamSend::Api::User.show(1)
      expect(user.class).to eq(StreamSend::Api::User)
    end
  end

  it "allows us to change the last name" do
    VCR.use_cassette('streamsend') do
      the_user = StreamSend::Api::User.all.last
      expect(the_user.last_name).to eq("user")
      response = StreamSend::Api::User.update("account_id" => StreamSend::Api::IntegrationConfiguration.root_account.account_id, "last-name" => "smithy", "user_id" => the_user.id)
      new_user = StreamSend::Api::User.show(the_user.id)
      expect(new_user.last_name).to eq("smithy")
    end
  end

  def find_by_email_address(email_address)
    the_user = StreamSend::Api::User.all.each do |user|
      return user if user.email_address == email_address
    end
  end
end
