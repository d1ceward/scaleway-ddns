module ScalewayDDNS
  class IP
    IP_API_HOST = "api.myip.com"

    # Getting current IP address from external API
    def self.current_ip : String
      Log.info { "IP API: Getting current IP" }

      ip_string = parse_response(execute_request)["ip"]?.to_s
      ip_address = Socket::IPAddress.new(ip_string, 0)

      Log.info { "IP API: Current IP is #{ip_address.address}"}

      ip_address.address
    rescue Socket::Error
      raise GlobalError.new("IP API: Invalid IP from #{IP_API_HOST}")
    end

    private def self.execute_request : HTTP::Client::Response
      client = HTTP::Client.new(URI.new("https", IP_API_HOST))
      client.connect_timeout = 10

      client.get("/")
    rescue IO::TimeoutError | Socket::Addrinfo::Error | Socket::ConnectError
      HTTP::Client::Response.new(408)
    end

    private def self.parse_response(response : HTTP::Client::Response) : JSON::Any
      return JSON.parse(response.body) if response.status_code == 200

      error_message = if response.status_code == 408
                        "IP API: Timeout error, please check your internet connection."
                      else
                        "IP API: Unknown error, please report this to the poject issue tracker."
                      end

      raise GlobalError.new(error_message)
    end
  end
end
