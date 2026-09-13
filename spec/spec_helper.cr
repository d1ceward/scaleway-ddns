require "spec"
require "webmock"
require "../src/scaleway_ddns"

module CLIHelper
  # Environment variables read by the program, cleared so that the ambient
  # environment cannot influence the specs.
  PROGRAM_ENV_KEYS = %w[SCW_SECRET_KEY IDLE_MINUTES DOMAIN_LIST ENABLE_IPV4 ENABLE_IPV6]

  # Runs the CLI in a subprocess and returns its exit status and output.
  def self.run_cli(
    *args,
    env : Hash(String, String?) = {} of String => String?,
  ) : Tuple(Process::Status, String)
    output = IO::Memory.new
    cmd = ["crystal", "run", "./src/scaleway_ddns_run.cr", "--"] + args.to_a
    process_env = PROGRAM_ENV_KEYS.to_h { |key| {key, nil.as(String?)} }.merge(env)
    status = Process.run(cmd[0], cmd[1..], env: process_env, output: output, error: output)
    {status, output.to_s}
  end
end
