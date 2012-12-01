require "yaml"
require "ostruct"

module StreamSend
  module Api
    class IntegrationConfiguration
      def self.config
        @config ||= YAML.load_file("spec/integration/integration.yml")
      end

      def self.root_account
        OpenStruct.new(config["root_account"])
      end
    end
  end
end
