require "yaml"
require "ostruct"

module StreamSend
  module Api
    class IntegrationConfiguration
      def self.config
        @config ||= YAML.load(ERB.new(IO.read("spec/integration/integration.yml")).result)
      end

      def self.root_account
        OpenStruct.new(config["root_account"])
      end
    end
  end
end
