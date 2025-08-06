require "../spec_helper"

describe ScalewayDDNS::Request do
  secret_key = "dummy_secret"
  domain = "example.com"
  request = ScalewayDDNS::Request.new(secret_key)
  record_response = {
    "records": [
      {"id": "1", "data": "127.0.0.1", "name": "@", "ttl": 60},
      {"id": "2", "data": "127.0.0.2", "name": "mail", "ttl": 120}
    ]
  }.to_json

  before_each &->WebMock.reset

  describe "#address_record_list" do
    it "returns parsed records for a valid domain" do
      WebMock.stub(:get, "https://api.scaleway.com/domain/v2beta1/dns-zones/#{domain}/records?type=A")
        .to_return(status: 200, body: record_response)
      records = request.address_record_list(domain)
      records.size.should eq(2)
      records[0][:id].should eq("1")
      records[0][:data].should eq("127.0.0.1")
      records[0][:name].should eq("@")
      records[0][:ttl].should eq(60)
    end

    it "raises on unauthorized response" do
      WebMock.stub(:get, "https://api.scaleway.com/domain/v2beta1/dns-zones/#{domain}/records?type=A")
        .to_return(status: 401, body: "")
      expect_raises(ScalewayDDNS::RequestError) do
        request.address_record_list(domain)
      end
    end

    it "raises on timeout response" do
      WebMock.stub(:get, "https://api.scaleway.com/domain/v2beta1/dns-zones/#{domain}/records?type=A")
        .to_return(status: 408, body: "")
      expect_raises(ScalewayDDNS::RequestError) do
        request.address_record_list(domain)
      end
    end
  end

  describe "#update_address_record" do
    record = { :id => "1", :name => "@", :ttl => 60, :data => "127.0.0.1" } of Symbol => String | Int32
    ip = "127.0.0.2"
    update_url = "https://api.scaleway.com/domain/v2beta1/dns-zones/#{domain}/records"
    update_body = {
      "changes": [
        {
          "set": {
            "id": "1",
            "records": [
              {"data": ip, "name": "@", "ttl": "60", "type": "A"}
            ]
          }
        }
      ]
    }.to_json

    it "sends correct PATCH request and parses response" do
      WebMock.stub(:patch, update_url)
        .with(body: update_body)
        .to_return(status: 200, body: "{\"result\": \"ok\"}")
      response = request.update_address_record(domain, ip, record)
      response["result"].should eq("ok")
    end

    it "raises on unauthorized update" do
      WebMock.stub(:patch, update_url)
        .to_return(status: 401, body: "")
      expect_raises(ScalewayDDNS::RequestError) do
        request.update_address_record(domain, ip, record)
      end
    end
  end
end
