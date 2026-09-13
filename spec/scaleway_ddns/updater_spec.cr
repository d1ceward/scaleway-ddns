require "../spec_helper"

private IPIFY_URL = "https://api.ipify.org/"

private def build_config(domains : Array(String), ipv6 = false)
  config = ScalewayDDNS::Config.new
  config.scw_secret_key = "dummy_secret"
  config.domain_list = domains
  config.enable_ipv4 = true
  config.enable_ipv6 = ipv6
  config
end

private def records_url(zone : String, type = "A", page = 1)
  "https://api.scaleway.com/domain/v2beta1/dns-zones/#{zone}/records" \
  "?type=#{type}&page=#{page}&page_size=#{ScalewayDDNS::Request::RECORD_PAGE_SIZE}"
end

private def a_record(name : String, data = "127.0.0.1", id = "1", ttl = 60)
  {"id": id, "data": data, "name": name, "ttl": ttl}
end

private def records_body(*records)
  {"records": records.to_a}.to_json
end

describe ScalewayDDNS::Updater do
  before_each(&->WebMock.reset)

  it "can be initialized with a config" do
    updater = ScalewayDDNS::Updater.new(build_config(["example.com"]))
    updater.should be_a(ScalewayDDNS::Updater)
  end

  describe "#update" do
    it "updates a record whose address changed" do
      WebMock.stub(:get, IPIFY_URL).to_return(status: 200, body: "127.0.0.1")
      WebMock.stub(:get, records_url("example.com"))
        .to_return(status: 200, body: records_body(a_record("home", "127.0.0.2")))
      patched = false
      WebMock.stub(:patch, "https://api.scaleway.com/domain/v2beta1/dns-zones/example.com/records")
        .to_return do |request|
          patched = true
          request.body.to_s.should contain("127.0.0.1")
          HTTP::Client::Response.new(200, body: "{}")
        end

      ScalewayDDNS::Updater.new(build_config(["home.example.com"])).update
      patched.should be_true
    end

    it "does not update a record that already holds the current address" do
      WebMock.stub(:get, IPIFY_URL).to_return(status: 200, body: "127.0.0.1")
      WebMock.stub(:get, records_url("example.com"))
        .to_return(status: 200, body: records_body(a_record("home")))

      # An unexpected PATCH would raise WebMock::NetConnectNotAllowedError.
      ScalewayDDNS::Updater.new(build_config(["home.example.com"])).update
    end

    it "handles an apex domain" do
      WebMock.stub(:get, IPIFY_URL).to_return(status: 200, body: "127.0.0.1")
      WebMock.stub(:get, records_url("example.com"))
        .to_return(status: 200, body: records_body(a_record("")))

      ScalewayDDNS::Updater.new(build_config(["example.com"])).update
    end

    it "does not call the Scaleway API when no IP could be fetched" do
      WebMock.stub(:get, IPIFY_URL).to_return(status: 500)

      # Any Scaleway call would raise WebMock::NetConnectNotAllowedError.
      ScalewayDDNS::Updater.new(build_config(["home.example.com"])).update
    end

    it "only queries the record types matching the enabled IP versions" do
      WebMock.stub(:get, IPIFY_URL).to_return(status: 200, body: "127.0.0.1")
      WebMock.stub(:get, records_url("example.com"))
        .to_return(status: 200, body: records_body(a_record("home")))

      # An AAAA query would raise WebMock::NetConnectNotAllowedError.
      ScalewayDDNS::Updater.new(build_config(["home.example.com"])).update
    end

    it "fetches the record list of a zone only once per cycle" do
      WebMock.stub(:get, IPIFY_URL).to_return(status: 200, body: "127.0.0.1")
      list_calls = 0
      WebMock.stub(:get, records_url("example.com")).to_return do |_request|
        list_calls += 1
        HTTP::Client::Response.new(
          200,
          body: records_body(a_record("home"), a_record("nas", id: "2"))
        )
      end

      ScalewayDDNS::Updater.new(build_config(["home.example.com", "nas.example.com"])).update
      list_calls.should eq(1)
    end

    it "uses the zone given after a colon" do
      WebMock.stub(:get, IPIFY_URL).to_return(status: 200, body: "127.0.0.1")
      WebMock.stub(:get, records_url("example.co.uk"))
        .to_return(status: 200, body: records_body(a_record("home")))

      ScalewayDDNS::Updater.new(build_config(["home.example.co.uk:example.co.uk"])).update
    end

    it "skips a domain with a single label instead of raising" do
      WebMock.stub(:get, IPIFY_URL).to_return(status: 200, body: "127.0.0.1")

      ScalewayDDNS::Updater.new(build_config(["localhost"])).update
    end

    it "skips a domain that does not belong to its zone" do
      WebMock.stub(:get, IPIFY_URL).to_return(status: 200, body: "127.0.0.1")

      ScalewayDDNS::Updater.new(build_config(["home.example.com:other.com"])).update
    end

    it "keeps going when the Scaleway API returns an error" do
      WebMock.stub(:get, IPIFY_URL).to_return(status: 200, body: "127.0.0.1")
      WebMock.stub(:get, records_url("example.com")).to_return(status: 401, body: "")

      ScalewayDDNS::Updater.new(build_config(["home.example.com"])).update
    end

    it "keeps going when no record matches the subdomain" do
      WebMock.stub(:get, IPIFY_URL).to_return(status: 200, body: "127.0.0.1")
      WebMock.stub(:get, records_url("example.com"))
        .to_return(status: 200, body: records_body(a_record("other")))

      ScalewayDDNS::Updater.new(build_config(["home.example.com"])).update
    end
  end
end
