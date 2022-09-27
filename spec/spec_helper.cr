ENV["CRYSTAL_SPEC_CONTEXT"] = "true"

require "spec"
require "../src/scaleway_ddns"

module DummyConfig
  def self.empty_env
    ENV["SCW_SECRET_KEY"] = nil
    ENV["IDLE_MINUTES"] = nil
    ENV["DOMAIN_LIST"] = nil
  end
end
