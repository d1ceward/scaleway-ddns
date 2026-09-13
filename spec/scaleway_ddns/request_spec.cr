require "../spec_helper"

describe ScalewayDDNS::Request do
  secret_key = "dummy_secret"
  domain = "example.com"
  request = ScalewayDDNS::Request.new(secret_key)
  list_url = ->(type : String, page : Int32) : String do
    "https://api.scaleway.com/domain/v2beta1/dns-zones/#{domain}/records" \
    "?type=#{type}&page=#{page}&page_size=#{ScalewayDDNS::Request::RECORD_PAGE_SIZE}"
  end
  record_response = {
    "records": [
      {"id": "1", "data": "127.0.0.1", "name": "@", "ttl": 60},
      {"id": "2", "data": "127.0.0.2", "name": "mail", "ttl": 120},
    ],
  }.to_json

  before_each(&->WebMock.reset)

  describe "#address_record_list" do
    it "returns parsed records for a valid domain" do
      WebMock.stub(:get, list_url.call("A", 1)).to_return(status: 200, body: record_response)
      WebMock.stub(:get, list_url.call("AAAA", 1)).to_return(status: 200, body: "{\"records\":[]}")
      records = request.address_record_list(domain)
      records.size.should eq(2)
      records[0][:id].should eq("1")
      records[0][:data].should eq("127.0.0.1")
      records[0][:name].should eq("@")
      records[0][:ttl].should eq(60)
      records[0][:type].should eq("A")
    end

    it "only queries the requested record types" do
      WebMock.stub(:get, list_url.call("A", 1)).to_return(status: 200, body: record_response)
      records = request.address_record_list(domain, ["A"])
      records.size.should eq(2)
    end

    it "defaults the ttl when the API does not report one" do
      WebMock.stub(:get, list_url.call("A", 1))
        .to_return(status: 200, body: {"records": [{"id": "1", "data": "127.0.0.1", "name": "@"}]}.to_json)
      records = request.address_record_list(domain, ["A"])
      records[0][:ttl].should eq(ScalewayDDNS::Request::DEFAULT_TTL)
    end

    it "walks through every page of records" do
      page_size = ScalewayDDNS::Request::RECORD_PAGE_SIZE
      full_page = {
        "records": Array.new(page_size) do |index|
          {"id": index.to_s, "data": "127.0.0.1", "name": "host#{index}", "ttl": 60}
        end,
      }.to_json
      WebMock.stub(:get, list_url.call("A", 1)).to_return(status: 200, body: full_page)
      last_page = {"records": [{"id": "last", "data": "127.0.0.1", "name": "last", "ttl": 60}]}.to_json
      WebMock.stub(:get, list_url.call("A", 2)).to_return(status: 200, body: last_page)

      records = request.address_record_list(domain, ["A"])
      records.size.should eq(page_size + 1)
      records.last[:name].should eq("last")
    end

    it "raises on unauthorized response" do
      WebMock.stub(:get, list_url.call("A", 1)).to_return(status: 401, body: "")
      expect_raises(ScalewayDDNS::RequestError) do
        request.address_record_list(domain, ["A"])
      end
    end

    it "raises on timeout response" do
      WebMock.stub(:get, list_url.call("A", 1)).to_return(status: 408, body: "")
      expect_raises(ScalewayDDNS::RequestError) do
        request.address_record_list(domain, ["A"])
      end
    end
  end

  describe "#update_address_record" do
    record = {
      :id => "1", :name => "@", :ttl => 60, :data => "127.0.0.1", :type => "A",
    } of Symbol => String | Int32
    ip = "127.0.0.2"
    update_url = "https://api.scaleway.com/domain/v2beta1/dns-zones/#{domain}/records"
    update_body = {
      "changes": [
        {
          "set": {
            "id":      "1",
            "records": [
              {"data": ip, "name": "@", "ttl": 60, "type": "A"},
            ],
          },
        },
      ],
    }.to_json

    it "sends correct PATCH request and parses response" do
      WebMock.stub(:patch, update_url)
        .with(body: update_body)
        .to_return(status: 200, body: "{\"result\": \"ok\"}")
      response = request.update_address_record(domain, ip, record, "A")
      response["result"].should eq("ok")
    end

    it "raises on unauthorized update" do
      WebMock.stub(:patch, update_url)
        .to_return(status: 401, body: "")
      expect_raises(ScalewayDDNS::RequestError) do
        request.update_address_record(domain, ip, record, "A")
      end
    end
  end
end
