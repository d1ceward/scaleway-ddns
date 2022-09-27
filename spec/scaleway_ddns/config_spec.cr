require "../spec_helper"

describe ScalewayDDNS::Config do
  describe "#scw_secret_key" do
    it "should return correct value from env" do
      ENV["SCW_SECRET_KEY"] = "123456789"
      instance = ScalewayDDNS::Config.new

      instance.scw_secret_key.should eq(ENV["SCW_SECRET_KEY"])
    end

    it "should return default empty string" do
      ENV.delete("SCW_SECRET_KEY")
      instance = ScalewayDDNS::Config.new

      instance.scw_secret_key.should eq("")
    end

    it "should return given secret key by setter in priority" do
      ENV["SCW_SECRET_KEY"] = "123456789"
      instance = ScalewayDDNS::Config.new
      instance.scw_secret_key = "FBISurveillanceVan"

      instance.scw_secret_key.should eq("FBISurveillanceVan")
    end
  end

  describe "#idle_minutes" do
    it "should return correct value from env" do
      ENV["IDLE_MINUTES"] = "10"
      instance = ScalewayDDNS::Config.new

      instance.idle_minutes.should eq(ENV["IDLE_MINUTES"].to_i)
    end

    it "should return default value" do
      ENV.delete("IDLE_MINUTES")
      instance = ScalewayDDNS::Config.new

      instance.idle_minutes.should eq(60)
    end

    it "should return given idle minutes by setter in priority" do
      ENV["IDLE_MINUTES"] = "21"
      instance = ScalewayDDNS::Config.new
      instance.idle_minutes = 42

      instance.idle_minutes.should eq(42)
    end

    it "should limit the minimum of idle minutes" do
      ENV["IDLE_MINUTES"] = "-1"
      instance = ScalewayDDNS::Config.new

      instance.idle_minutes.should eq(60)
    end

    it "should limit the maximum of idle minutes" do
      ENV["IDLE_MINUTES"] = "1441"
      instance = ScalewayDDNS::Config.new

      instance.idle_minutes.should eq(60)
    end
  end

  describe "#domain_list" do
    it "should return correct value from env" do
      ENV["DOMAIN_LIST"] = "nogoogle.com, scaleway.com"
      instance = ScalewayDDNS::Config.new

      instance.domain_list.should eq(["nogoogle.com", "scaleway.com"])
    end

    it "should return default empty array" do
      ENV.delete("DOMAIN_LIST")
      instance = ScalewayDDNS::Config.new

      instance.domain_list.should eq([] of Array(String))
    end

    it "should return given domain array by setter in priority" do
      ENV["DOMAIN_LIST"] = "nogoogle.com, scaleway.com"
      instance = ScalewayDDNS::Config.new
      instance.domain_list = ["ddns.com", "wowsuch.com"]

      instance.domain_list.should eq(["ddns.com", "wowsuch.com"])
    end
  end
end
