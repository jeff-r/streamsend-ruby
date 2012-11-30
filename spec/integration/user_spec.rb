require File.join(Dir.pwd, "lib/streamsend")
require "integration/spec_helper.rb"
require "ruby-debug"

describe "user via api" do
  before do
    account = StreamSend::IntegrationConfiguration.root_account
    StreamSend.configure(account.api_username, account.api_password, account.app_host)
  end

  it "exists" do
    the_user = StreamSend::User.all.first
    the_user.first_name.should == "Admin"
  end

  it "gets created" do
    the_user = StreamSend::User.create(
      "password" => "password2",
      "password_confirmation" => "password2",
      "email_address" => "joe@gmail.com",
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
    the_user = StreamSend::User.show(1)
  end

  it "allows us to change the last name" do
    the_user = StreamSend::User.all.last
    response = StreamSend::User.update("account_id" => StreamSend::IntegrationConfiguration.root_account.account_id, "last-name" => "smithy", "user_id" => the_user.id)
    new_user = StreamSend::User.all.last
    0
  end

  def find_by_email_address(email_address)
    the_user = StreamSend::User.all.each do |user|
      return user if user.email_address == email_address
    end
  end

end
