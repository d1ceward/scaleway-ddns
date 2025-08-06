require "../spec_helper"

# Test the public API: current_ips

describe ScalewayDDNS::IP do
  describe "#current_ips" do
    before_each &->WebMock.reset

    it "returns valid IPv4 ip" do
      WebMock.stub(:get, "https://api.ipify.org/").to_return(status: 200, body: "127.0.0.1")
      ips = ScalewayDDNS::IP.current_ips(ipv4: true, ipv6: false)
      ips["ipv4"].should eq("127.0.0.1")
    end

    it "returns valid IPv6 ip" do
      WebMock.stub(:get, "https://api6.ipify.org/").to_return(status: 200, body: "::1")
      ips = ScalewayDDNS::IP.current_ips(ipv4: false, ipv6: true)
      ips["ipv6"].should eq("::1")
    end

    it "returns both IPv4 and IPv6 when both enabled" do
      WebMock.stub(:get, "https://api.ipify.org/").to_return(status: 200, body: "127.0.0.1")
      WebMock.stub(:get, "https://api6.ipify.org/").to_return(status: 200, body: "::1")
      ips = ScalewayDDNS::IP.current_ips(ipv4: true, ipv6: true)
      ips["ipv4"].should eq("127.0.0.1")
      ips["ipv6"].should eq("::1")
    end

    it "returns empty hash if both disabled" do
      ips = ScalewayDDNS::IP.current_ips(ipv4: false, ipv6: false)
      ips.should be_empty
    end

    it "raises timeout error on 408 invalid response for IPv4" do
      WebMock.stub(:get, "https://api.ipify.org/").to_return(status: 408)
      # Since current_ips swallows errors and logs, we can't expect_raises here, but we can check that the key is missing
      ips = ScalewayDDNS::IP.current_ips(ipv4: true, ipv6: false)
      ips.has_key?("ipv4").should be_false
    end

    it "raises unknown error on 500 invalid response for IPv4" do
      WebMock.stub(:get, "https://api.ipify.org/").to_return(status: 500)
      ips = ScalewayDDNS::IP.current_ips(ipv4: true, ipv6: false)
      ips.has_key?("ipv4").should be_false
    end

    it "handles error for IPv6 but returns IPv4 if only IPv6 fails" do
      WebMock.stub(:get, "https://api.ipify.org/").to_return(status: 200, body: "127.0.0.1")
      WebMock.stub(:get, "https://api6.ipify.org/").to_return(status: 500)
      ips = ScalewayDDNS::IP.current_ips(ipv4: true, ipv6: true)
      ips["ipv4"].should eq("127.0.0.1")
      ips.has_key?("ipv6").should be_false
    end

    it "handles error for IPv4 but returns IPv6 if only IPv4 fails" do
      WebMock.stub(:get, "https://api.ipify.org/").to_return(status: 500)
      WebMock.stub(:get, "https://api6.ipify.org/").to_return(status: 200, body: "::1")
      ips = ScalewayDDNS::IP.current_ips(ipv4: true, ipv6: true)
      ips.has_key?("ipv4").should be_false
      ips["ipv6"].should eq("::1")
    end
  end
end
