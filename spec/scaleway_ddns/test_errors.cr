require "../spec_helper"

describe ScalewayDDNS::RequestError do
  it "should raise an exception with the correct error message" do
    error = ScalewayDDNS::RequestError.new(401)
    error.message.should eq("Scaleway API: Unauthorized, please check configuration variables.")
  end

  it "should raise an exception with the correct error message for a timeout error" do
    error = ScalewayDDNS::RequestError.new(408)
    error.message.should eq("Scaleway API: Timeout error, please check your internet connection.")
  end

  it "should raise an exception with the correct error message for an unknown error" do
    error = ScalewayDDNS::RequestError.new(500)
    error.message.should eq("Scaleway API: Unknown error, please check configuration variables or report " \
                            "to the project issue tracker.")
  end
end
