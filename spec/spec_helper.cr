require "spec"
require "webmock"
require "../src/scaleway_ddns"

module DummyConfig
  def self.empty_env
    ENV["SCW_SECRET_KEY"] = nil
    ENV["IDLE_MINUTES"] = nil
    ENV["DOMAIN_LIST"] = nil
    ENV["ENABLE_IPV4"] = nil
    ENV["ENABLE_IPV6"] = nil
  end
end

module CLIHelper
  def self.run_cli(*args)
    output = IO::Memory.new
    cmd = ["crystal", "run", "./src/scaleway_ddns_run.cr", "--"] + args.to_a
    status = Process.run(cmd[0], cmd[1..], output: output, error: output)
    {status, output.to_s}
  end
end
