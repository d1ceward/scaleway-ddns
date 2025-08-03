module ScalewayDDNS
  # The IP class provides methods to retrieve the current external IP address using an API.
  class IP
    IP_API_HOST_V4 = "api.ipify.org"
    IP_API_HOST_V6 = "api6.ipify.org"

    # Returns a hash of enabled IP versions and their addresses, e.g. {"ipv4" => "1.2.3.4", "ipv6" => "::1"}
    def self.current_ips(ipv4 : Bool = true, ipv6 : Bool = false) : Hash(String, String)
      [
        {"ipv4", ipv4, false},
        {"ipv6", ipv6, true}
      ].select { |_, enabled, _| enabled }
       .each_with_object({} of String => String) do |(label, _, v6), result|
        begin
          result[label] = current_ip(v6)
        rescue IPError
          Log.warn { "Could not fetch #{label.upcase} address" }
        end
      end
    end

    # Returns current IP address from external API as string
    private def self.current_ip(ipv6 : Bool = false) : String
      version = ipv6 ? "IPv6" : "IPv4"
      Log.info { "IP API: Getting current #{version}..." }

      ip_string = ""
      elapsed_time = Time.measure do
        ip_string = parse_response(execute_request(ipv6))
      end

      ip_address = Socket::IPAddress.new(ip_string, 0)
      Log.info { "IP API: Current IP is #{ip_address.address} and took #{elapsed_time.total_seconds}s" }
      ip_address.address
    rescue Socket::Error
      raise IPError.new("IP API: Invalid IP from #{ipv6 ? IP_API_HOST_V6 : IP_API_HOST_V4}")
    end

    private def self.execute_request(ipv6 : Bool = false) : HTTP::Client::Response
      host = ipv6 ? IP_API_HOST_V6 : IP_API_HOST_V4
      client = HTTP::Client.new(URI.new("https", host))
      client.connect_timeout = 10.seconds
      client.get("/")
    rescue IO::TimeoutError | Socket::Addrinfo::Error | Socket::ConnectError
      HTTP::Client::Response.new(408)
    end

    private def self.parse_response(response : HTTP::Client::Response) : String
      return response.body if response.status_code == 200

      error_message = case response.status_code
                      when 408
                        "IP API: Timeout error, please check your internet connection or IP API status."
                      else
                        "IP API: Unknown error, please report this to the project issue tracker."
                      end
      raise IPError.new(error_message)
    end
  end
end
