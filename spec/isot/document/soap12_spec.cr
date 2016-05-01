require "../../spec_helper"

describe Isot::Document do
  context "with: soap12.wsdl" do
    document = Isot::Document.new fixture(:soap12).read

    describe "#endpoint" do
      it "returns endpoint" { should_be_same_uri(document.endpoint, URI.parse("http://blogsite.example.com/endpoint12")) }
    end
  end
end
