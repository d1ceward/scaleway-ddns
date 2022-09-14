require "yaml"
require "./spec_helper"

describe ScalewayDDNS::VERSION do
  it "should match shard.yml" do
    version = YAML.parse(File.read(Path[__DIR__, "..", "shard.yml"]))["version"].as_s
    version.should eq(ScalewayDDNS::VERSION)
  end
end
