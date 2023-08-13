module ScalewayDDNS
  # The Request class handles interactions with the Scaleway API for managing DNS records.
  class Request
    # The host of the Scaleway API used for DNS record management.
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

      # Execute the API request and parse the response
      response = execute_request("GET", "/domain/v2beta1/dns-zones/#{domain}/records?type=A")
      records = parse_response(response)["records"]?.try(&.as_a?) || [] of Hash(String, JSON::Any)

      # Transform the parsed records into a more structured format
      records.map do |record|
        {
          :id => record["id"]?.to_s,
          :data => record["data"]?.to_s,
          :name => record["name"]?.to_s,
          :ttl => record["ttl"]?.try(&.as_i) || 60
        }
      end
    end

    # Update an A (address) record in the Scaleway API for a given domain.
    #
    # ```
    # ScalewayDDNS::Request.update_address_record("example.com", "127.0.0.1", record)
    # ```
    def update_address_record(domain : String, ip : String, record : Hash(Symbol, String | Int32))
      Log.info { "Scaleway API: Updating A record for #{domain}" }

      # Construct the request body
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

      # Execute the update request and parse the response.
      parse_response(execute_request("PATCH", "/domain/v2beta1/dns-zones/#{domain}/records", body_string))
    end

    private def execute_request(
      method : String,
      endpoint : String,
      body : String? = nil
    ) : HTTP::Client::Response
      # Set headers and create an HTTP client with a timeout for the connection.
      headers = HTTP::Headers{"X-Auth-Token" => @scw_secret_key}
      client = HTTP::Client.new(URI.new("https", SCW_API_HOST))
      client.connect_timeout = 10

      # Execute the API request and return the response
      client.exec(method, endpoint, headers, body)
    rescue IO::TimeoutError | Socket::Addrinfo::Error | Socket::ConnectError
      HTTP::Client::Response.new(408)
    end

    private def parse_response(response : HTTP::Client::Response) : JSON::Any
      # If the response status code is 200, parse and return the response body as JSON
      return JSON.parse(response.body) if response.status_code == 200

      # Raise a RequestError with the response status code
      raise RequestError.new(response.status_code)
    end
  end
end
