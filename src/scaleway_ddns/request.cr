module ScalewayDdns
  class Request
    SCW_API_HOST = "api.scaleway.com"

    def initialize(@config : Config); end

    def address_record_list(domain : String) : Array(Hash(Symbol, String | Int32))
      response = execute_request("GET", "/domain/v2beta1/dns-zones/#{domain}/records?type=A")
      records = parse_response(response)["records"]?.try(&.as_a?) || [] of Hash(String, JSON::Any)

      records.map do |record|
        {
          :id => record["id"]?.to_s,
          :name => record["name"]?.to_s,
          :ttl => record["ttl"]?.try(&.as_i) || 60
        }
      end
    end

    private def execute_request(method : String, endpoint : String) : HTTP::Client::Response
      headers = HTTP::Headers{"X-Auth-Token" => @config.scw_secret_key.to_s}
      client = HTTP::Client.new(URI.new("https", SCW_API_HOST))
      client.connect_timeout = 4

      client.exec(method, endpoint, headers)
    rescue IO::TimeoutError | Socket::Addrinfo::Error | Socket::ConnectError
      HTTP::Client::Response.new(408)
    end

    private def parse_response(response : HTTP::Client::Response)
      return JSON.parse(response.body) if response.status_code == 200

      case response
      when 401 then Log.error { "Unauthorized, please check your environment variable." }
      when 408 then Log.error { "Timeout error, please check your environment variable or internet status." }
      else
        Log.error { "Unknown error, please check your environment variable or report to issue tracker." }
      end

      JSON.parse("{}")
    end
  end
end
