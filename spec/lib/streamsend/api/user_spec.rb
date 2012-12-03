require File.join(File.dirname(__FILE__), "../../../spec_helper")
require "active_support/core_ext/hash"

module StreamSend
  module Api
    describe "User" do
      let(:app_host) { "http://test.host" }

      before do
        WebMock.enable!
        @username = "jeff"
        @password = "topsecret"
        @host = "test.host"
        StreamSend::Api.configure(@username, @password, @host)
      end

      after do
        WebMock.disable!
      end

      describe "#all" do
        describe "with two users" do
          before do
            users = <<-XML
<?xml version="1.0" encoding="UTF-8"?>
<users type="array">
  <user>
    <administrator type="boolean">true</administrator>
    <title>Administrator</title>
    <last-name>User</last-name>
    <updated-at type="datetime">2012-11-29T17:14:55-08:00</updated-at>
    <may-export type="boolean">true</may-export>
    <id type="integer">1</id>
    <email-address>admin@streamsend.com</email-address>
    <first-name>Admin</first-name>
    <company-name>Not Random BS</company-name>
    <created-at type="datetime">2012-11-29T17:14:55-08:00</created-at>
  </user>

  <user>
    <administrator type="boolean">false</administrator>
    <title>regular user</title>
    <last-name>User2</last-name>
    <updated-at type="datetime">2012-11-29T17:14:55-08:00</updated-at>
    <may-export type="boolean">true</may-export>
    <id type="integer">1</id>
    <email-address>joe@streamsend.com</email-address>
    <first-name>Joe</first-name>
    <company-name>Not Random BS</company-name>
    <created-at type="datetime">2012-11-29T17:14:55-08:00</created-at>
  </user>
</users>
            XML

            stub_http_request(:get, "http://#{@username}:#{@password}@#{@host}/users.xml").to_return(:body => users)
          end

          it "should return an array of two users" do
            users = StreamSend::Api::User.all
            users.size.should == 2
          end

          it "should return an array with the two users" do
            users = StreamSend::Api::User.all
            users.first.id.should == 1
          end
        end

        describe "with no users" do
          before do
            stub_http_request(:get, "http://#{@username}:#{@password}@#{@host}/users.xml").to_return(:body => "Page not found.", :status => 404)
          end

          it "should raise an error" do
            lambda do
              users = StreamSend::Api::User.all
            end.should raise_error
          end

        end
      end

      describe "#show" do
        describe "with a single user" do
          before do
            xml = <<-XML
  <?xml version="1.0" encoding="UTF-8"?>
    <user>
      <id>2</id>
      <email-address>john2@example.com</email-address>
      <first-name>John2</first-name>
      <last-name>Doe</last-name>
    </user>
            XML
            stub_http_request(:get, "http://#{@username}:#{@password}@#{@host}/users/2.xml").to_return(:body => xml)
          end

          it "returns the user" do
            user = StreamSend::Api::User.show(2)
            user.id.should == "2"
            user.first_name.should == "John2"
          end
        end

        describe "with an invalid user" do
          before do
            stub_http_request(:post, "http://#{@username}:#{@password}@#{@host}/users/2.xml").to_return(:body => "Page not found.")
          end

          it "should raise an error" do
            lambda do
              user = StreamSend::Api::User.show(30)
            end.should raise_error
          end
        end
      end

      describe ".update" do
        before do
          @user_hash = {
            "first-name" => "Jerry",
            "account_id" => 1,
            "user_id" => 2
          }
          stub_http_request(:put, "http://#{@username}:#{@password}@#{@host}/accounts/1/users/2.xml").with(:body => @user_hash.to_xml).to_return(:body => nil, :status => 200)
        end

        describe "with a valid user" do
          it "should be successful" do
            response = StreamSend::Api::User.update(@user_hash)
            response.should be_true
          end
        end
      end

      describe ".create" do
        describe "with valid user parameters" do
          describe "with an existing users" do
            before(:each) do
              stub_http_request(:post, /accounts\/1\/users.xml/).with(:person => {"email_address" => "foo@bar.com", "first_name" => "JoeBob"}).to_return(:body => "", :headers => {"location" => "http://test.host/accounts/2/users/1"}, :status => 201)
            end

            it "should return the new user's id" do
              user_id = StreamSend::Api::User.create({"account_id" => 1, "email_address" => "foo@bar.com", "first_name" => "JoeBob"})

              user_id.should_not be_nil
              user_id.should == 1
            end
          end
        end

        describe "with invalid user parameters" do
          before(:each) do
            stub_http_request(:post, "/account/1/users.xml").with(:person => {"email_address" => "foo@bar.com", "first_name" => "JoeBob"}).to_return(:status => 422)
          end

          it "should raise an error" do
            lambda do
              user_id = StreamSend::Api::User.create({"account_id" => 1, "email_address" => "foo@bar.com", "first_name" => "JoeBob"})
            end.should raise_error
          end
        end
      end
    end
  end
end
