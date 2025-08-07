require "../spec_helper"

describe ScalewayDDNS::Config do
  around_each do |example|
    original_env = ENV.to_h.dup
    example.run
    ENV.clear
    original_env.each { |k, v| ENV[k] = v }
  end

  describe "#scw_secret_key" do
    context "when SCW_SECRET_KEY is set" do
      it "returns the value from env" do
        ENV["SCW_SECRET_KEY"] = "123456789"
        config = ScalewayDDNS::Config.new
        config.scw_secret_key.should eq("123456789")
      end
    end

    context "when SCW_SECRET_KEY is not set" do
      it "returns an empty string" do
        ENV.delete("SCW_SECRET_KEY")
        config = ScalewayDDNS::Config.new
        config.scw_secret_key.should eq("")
      end
    end

    it "prefers the setter value over env" do
      ENV["SCW_SECRET_KEY"] = "123456789"
      config = ScalewayDDNS::Config.new
      config.scw_secret_key = "FBISurveillanceVan"
      config.scw_secret_key.should eq("FBISurveillanceVan")
    end
  end

  describe "#idle_minutes" do
    context "when IDLE_MINUTES is valid" do
      it "returns the value from env" do
        ENV["IDLE_MINUTES"] = "10"
        config = ScalewayDDNS::Config.new
        config.idle_minutes.should eq(10)
      end
    end

    context "when IDLE_MINUTES is not set" do
      it "returns the default value" do
        ENV.delete("IDLE_MINUTES")
        config = ScalewayDDNS::Config.new
        config.idle_minutes.should eq(60)
      end
    end

    it "prefers the setter value over env" do
      ENV["IDLE_MINUTES"] = "21"
      config = ScalewayDDNS::Config.new
      config.idle_minutes = 42
      config.idle_minutes.should eq(42)
    end

    it "limits the minimum of idle minutes" do
      ENV["IDLE_MINUTES"] = "-1"
      config = ScalewayDDNS::Config.new
      config.idle_minutes.should eq(60)
    end

    it "limits the maximum of idle minutes" do
      ENV["IDLE_MINUTES"] = "1441"
      config = ScalewayDDNS::Config.new
      config.idle_minutes.should eq(60)
    end

    it "handles non-integer values gracefully" do
      ENV["IDLE_MINUTES"] = "notanumber"
      config = ScalewayDDNS::Config.new
      config.idle_minutes.should eq(60)
    end
  end

  describe "#domain_list" do
    context "when DOMAIN_LIST is set" do
      it "returns the parsed array" do
        ENV["DOMAIN_LIST"] = "nogoogle.com, scaleway.com"
        config = ScalewayDDNS::Config.new
        config.domain_list.should eq(["nogoogle.com", "scaleway.com"])
      end
    end

    context "when DOMAIN_LIST is not set" do
      it "returns an empty array" do
        ENV.delete("DOMAIN_LIST")
        config = ScalewayDDNS::Config.new
        config.domain_list.should eq([] of String)
      end
    end

    it "prefers the setter value over env" do
      ENV["DOMAIN_LIST"] = "nogoogle.com, scaleway.com"
      config = ScalewayDDNS::Config.new
      config.domain_list = ["ddns.com", "wowsuch.com"]
      config.domain_list.should eq(["ddns.com", "wowsuch.com"])
    end

    it "ignores whitespace and blank entries" do
      ENV["DOMAIN_LIST"] = "  ,foo.com,   , bar.com ,"
      config = ScalewayDDNS::Config.new
      config.domain_list.should eq(["foo.com", "bar.com"])
    end
  end

  describe "#enable_ipv4" do
    it "defaults to true if unset" do
      ENV.delete("ENABLE_IPV4")
      config = ScalewayDDNS::Config.new
      config.enable_ipv4?.should be_true
    end

    it "parses falsy values as false" do
      ["false", "no", "0", "off", "disabled", "none", "null", "nil", ""].each do |val|
        ENV["ENABLE_IPV4"] = val
        config = ScalewayDDNS::Config.new
        config.enable_ipv4?.should be_false
      end
    end

    it "parses truthy values as true" do
      ["true", "yes", "1", "on", "enabled"].each do |val|
        ENV["ENABLE_IPV4"] = val
        config = ScalewayDDNS::Config.new
        config.enable_ipv4?.should be_true
      end
    end
  end

  describe "#enable_ipv6" do
    it "defaults to true if unset" do
      ENV.delete("ENABLE_IPV6")
      config = ScalewayDDNS::Config.new
      config.enable_ipv6?.should be_true
    end

    it "parses falsy values as false" do
      ["false", "no", "0", "off", "disabled", "none", "null", "nil", ""].each do |val|
        ENV["ENABLE_IPV6"] = val
        config = ScalewayDDNS::Config.new
        config.enable_ipv6?.should be_false
      end
    end

    it "parses truthy values as true" do
      ["true", "yes", "1", "on", "enabled"].each do |val|
        ENV["ENABLE_IPV6"] = val
        config = ScalewayDDNS::Config.new
        config.enable_ipv6?.should be_true
      end
    end
  end
end
