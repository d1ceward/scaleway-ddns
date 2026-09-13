module ScalewayDDNS
  # An address record as returned by the Scaleway API.
  alias AddressRecord = Hash(Symbol, String | Int32)

  class Request
    SCW_API_HOST = "api.scaleway.com"

    # Number of records asked per page, the maximum allowed by the Scaleway API.
    RECORD_PAGE_SIZE = 100

    # Address record types handled by the updater.
    ADDRESS_RECORD_TYPES = %w[A AAAA]

    # Time to live used when the API does not report one.
    DEFAULT_TTL = 60

    def initialize(@scw_secret_key : String) : Nil; end

    # Get a list of A and AAAA records from the Scaleway API for a given domain.
    def address_record_list(
      domain : String,
      types : Array(String) = ADDRESS_RECORD_TYPES,
    ) : Array(AddressRecord)
      Log.info { "Scaleway API: Getting #{types.join('/')} records for #{domain}" }

      types.each_with_object([] of AddressRecord) do |type, records|
        each_record(domain, type) { |record| records << build_record(record, type) }
      end
    end

    # Update an address record (A or AAAA) in the Scaleway API for a given domain.
    def update_address_record(
      domain : String,
      ip : String,
      record : AddressRecord,
      record_type : String,
    ) : JSON::Any
      Log.info { "Scaleway API: Updating #{record_type} record for #{domain}" }

      body_string = {
        changes: [
          {
            set: {
              id:      record[:id].to_s,
              records: [
                {
                  data: ip,
                  name: record[:name].to_s,
                  ttl:  record[:ttl],
                  type: record_type,
                },
              ],
            },
          },
        ],
      }.to_json

      parse_response(execute_request("PATCH", "/domain/v2beta1/dns-zones/#{domain}/records", body_string))
    end

    # Yields every record of *type* held by *domain*, walking through every page.
    private def each_record(domain : String, type : String, &)
      page = 1

      loop do
        query = URI::Params.encode({
          "type" => type, "page" => page.to_s, "page_size" => RECORD_PAGE_SIZE.to_s,
        })
        response = execute_request("GET", "/domain/v2beta1/dns-zones/#{domain}/records?#{query}")
        records = parse_response(response)["records"]?.try(&.as_a?) || [] of JSON::Any

        records.each { |record| yield record }
        break if records.size < RECORD_PAGE_SIZE

        page += 1
      end
    end

    private def build_record(record : JSON::Any, type : String) : AddressRecord
      {
        :id   => record["id"]?.to_s,
        :data => record["data"]?.to_s,
        :name => record["name"]?.to_s,
        :ttl  => record["ttl"]?.try(&.as_i?) || DEFAULT_TTL,
        :type => type,
      } of Symbol => String | Int32
    end

    private def execute_request(
      method : String,
      endpoint : String,
      body : String? = nil,
    ) : HTTP::Client::Response
      HTTPHelper.execute(
        SCW_API_HOST,
        method,
        endpoint,
        HTTP::Headers{"X-Auth-Token" => @scw_secret_key},
        body
      )
    end

    private def parse_response(response : HTTP::Client::Response) : JSON::Any
      return JSON.parse(response.body) if response.status_code == 200

      raise RequestError.new(response.status_code)
    end
  end
end
