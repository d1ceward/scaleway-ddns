module ScalewayDDNS
  class Request
    SCW_API_HOST = "api.scaleway.com"

    # Creates a new instance of `ScalewayDDNS::Request` with given Scaleway secret key.
    def initialize(@scw_secret_key : String); end

    # Get a list of A (address) record from the Scaleway API for a given domain.
    #
    # ```
    # ScalewayDDNS::Request.address_record_list("example.com")
    # # => [{ :id => 1, :name => "" :ttl => 60 }, { :id => 2, :name => "mail" :ttl => 120 }]
    #
    # ScalewayDDNS::Request.address_record_list("invalid.com")
    # # => Scaleway API: Unauthorized, please check configuration variables.
    # ```
    def address_record_list(domain : String) : Array(Hash(Symbol, String | Int32))
      Log.info { "Scaleway API: Getting A record for #{domain}" }

      response = execute_request("GET", "/domain/v2beta1/dns-zones/#{domain}/records?type=A")
      records = parse_response(response)["records"]?.try(&.as_a?) || [] of Hash(String, JSON::Any)

      records.map do |record|
        {
          :id => record["id"]?.to_s,
          :data => record["data"]?.to_s,
          :name => record["name"]?.to_s,
          :ttl => record["ttl"]?.try(&.as_i) || 60
        }
      end
    end

    def update_address_record(domain : String, ip : String, record : Hash(Symbol, String | Int32))
      Log.info { "Scaleway API: Updating A record for #{domain}" }

      body_string = {
        "changes": [
          {
            "set": {
              "id": "#{record[:id]}",
              "records": [
                {
                  "data": "#{ip}",
                  "name": "#{record[:name]}",
                  "ttl": "#{record[:ttl]}",
                  "type": "A"
                }
              ]
            }
          }
        ]
      }.to_json

      parse_response(execute_request("PATCH", "/domain/v2beta1/dns-zones/#{domain}/records", body_string))
    end

    private def execute_request(
      method : String,
      endpoint : String,
      body : String? = nil
    ) : HTTP::Client::Response
      headers = HTTP::Headers{"X-Auth-Token" => @scw_secret_key}
      client = HTTP::Client.new(URI.new("https", SCW_API_HOST))
      client.connect_timeout = 10

      client.exec(method, endpoint, headers, body)
    rescue IO::TimeoutError | Socket::Addrinfo::Error | Socket::ConnectError
      HTTP::Client::Response.new(408)
    end

    private def parse_response(response : HTTP::Client::Response) : JSON::Any
      return JSON.parse(response.body) if response.status_code == 200

      raise RequestError.new(response.status_code)
    end
  end
end
