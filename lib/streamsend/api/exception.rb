module StreamSend
  module Api
    class Exception < StandardError
    end

    class ApiException < Exception
    end

    class LockedError <  ApiException
    end

    class UnexpectedResponse < ApiException
    end
  end
end
