require "../spec_helper"

describe ScalewayDDNS::IP do
  describe "#current_ip" do
    before_each &->WebMock.reset

    it "return valid ip" do
      WebMock.stub(:get, "https://api.ipify.org/").to_return(status: 200, body: "127.0.0.1")

      ScalewayDDNS::IP.current_ip.should eq("127.0.0.1")
    end

    it "raises tiemout error on 408 invalid response" do
      WebMock.stub(:get, "https://api.ipify.org/").to_return(status: 408)

      expect_raises(ScalewayDDNS::IPError, /Timeout error/) do
        ScalewayDDNS::IP.current_ip
      end
    end

    it "raises unknown error on 500 invalid response" do
      WebMock.stub(:get, "https://api.ipify.org/").to_return(status: 500)

      expect_raises(ScalewayDDNS::IPError, /Unknown error/) do
        ScalewayDDNS::IP.current_ip
      end
    end
  end
end
