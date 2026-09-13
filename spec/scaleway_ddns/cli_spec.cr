require "../spec_helper"

describe ScalewayDDNS::CLI do
  it "shows help with -h" do
    status, output = CLIHelper.run_cli("-h")
    status.exit_code.should eq(0)
    output.should contain("Usage: scaleway-ddns")
  end

  it "shows help with --help" do
    status, output = CLIHelper.run_cli("--help")
    status.exit_code.should eq(0)
    output.should contain("Usage: scaleway-ddns")
  end

  it "shows version with -v" do
    status, output = CLIHelper.run_cli("-v")
    status.exit_code.should eq(0)
    output.should contain("version")
  end

  it "shows version with --version" do
    status, output = CLIHelper.run_cli("--version")
    status.exit_code.should eq(0)
    output.should contain("version")
  end

  it "exits with an explicit error when the secret key is missing" do
    status, output = CLIHelper.run_cli("run")
    status.exit_code.should eq(1)
    output.should contain("Empty secret key")
  end

  it "exits with an explicit error when the domain list is empty" do
    status, output = CLIHelper.run_cli("run", env: {"SCW_SECRET_KEY" => "dummy_secret"})
    status.exit_code.should eq(1)
    output.should contain("Empty domain list")
  end

  it "shows error for invalid option" do
    status, output = CLIHelper.run_cli("--notarealoption")
    status.exit_code.should eq(1)
    output.should contain("not a valid option")
  end
end
