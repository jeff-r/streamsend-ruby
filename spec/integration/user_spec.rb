require File.join(Dir.pwd, "lib/streamsend")
require "integration/spec_helper.rb"

describe "user via api" do
  before do
    account = StreamSend::Api::IntegrationConfiguration.root_account
    StreamSend::Api.configure(account.api_username, account.api_password, account.app_host)
  end

  it "exists" do
    the_user = StreamSend::Api::User.all.first
    the_user.first_name.should == "Admin"
  end

  it "gets created" do
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
    saved_user.id.should > 1
  end

  it "can be found" do
    the_user = StreamSend::Api::User.show(1)
  end

  it "allows us to change the last name" do
    the_user = StreamSend::Api::User.all.last
    response = StreamSend::Api::User.update("account_id" => StreamSend::Api::IntegrationConfiguration.root_account.account_id, "last-name" => "smithy", "user_id" => the_user.id)
    new_user = StreamSend::Api::User.all.last
    0
  end

  def find_by_email_address(email_address)
    the_user = StreamSend::Api::User.all.each do |user|
      return user if user.email_address == email_address
    end
  end
end
