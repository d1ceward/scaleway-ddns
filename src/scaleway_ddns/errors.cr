module ScalewayDDNS
  class GlobalError < Exception; end
  class IPError < Exception; end

  # Raised when the Scaleway API returns an error.
  class RequestError < Exception
    def initialize(@http_status : Int32)
      super("Scaleway API: #{error_message_by_http_status}")
    end

    private def error_message_by_http_status : String
      case @http_status
      when 401 then "Unauthorized, please check configuration variables."
      when 408 then "Timeout error, please check your internet connection."
      else
        "Unknown error, please check configuration variables or report to the project issue tracker."
      end
    end
  end
end
