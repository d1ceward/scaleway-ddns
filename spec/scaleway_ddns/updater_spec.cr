require "../spec_helper"

describe ScalewayDDNS::Updater do
  it "can be initialized with a config" do
    config = ScalewayDDNS::Config.new
    updater = ScalewayDDNS::Updater.new(config)
    updater.should be_a(ScalewayDDNS::Updater)
  end
end
