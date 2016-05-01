require "../../spec_helper"

describe Isot::Document do
  context "with: encoded_endpoint.wsdl" do
    document = Isot::Document.new fixture(:encoded_endpoint).read

    describe "#endpoint" do
      it "returns endpoint" {
        uri = URI.parse("http://localhost/soapservice/execute?path=/base/includes/Test+Soap/Return+Rows")
        should_be_same_uri(document.endpoint, uri)
      }
    end
  end
end
