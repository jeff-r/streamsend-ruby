require File.join(File.dirname(__FILE__), "../../../spec_helper")

module StreamSend
  module Api
    describe "Resource" do
      describe "with missing method" do
        before(:each) do
          @resource = StreamSend::Api::Resource.new({"name" => "scott"})
        end

        it "should return value" do
          @resource.name.should == "scott"
        end
      end

      describe "#id" do
        it "should return id" do
          StreamSend::Api::Resource.new({"id" => 99}).id.should == 99
        end
      end
    end
  end
end
