module StreamSend
  module Api
    class Exception < StandardError
    end

    class ApiException < Exception
    end

    class SemanticException < ApiException
      def initialize(other_errors)
       @errors = [other_errors].flatten
      end

      def errors
        @errors
      end
    end

    class LockedError <  ApiException
    end

    class UnexpectedResponse < ApiException
    end
  end
end
