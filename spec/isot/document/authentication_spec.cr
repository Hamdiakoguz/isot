require "../../spec_helper"

describe Isot::Document do
  context "with: authentication.wsdl" do
    document = Isot::Document.new fixture(:authentication).read

    describe "#namespace" do
      it "returns namespace" { document.namespace.should eq "http://v1_0.ws.auth.order.example.com/" }
    end

    describe "#endpoint" do
      it "returns endpoint" { should_be_same_uri(document.endpoint, URI.parse("http://example.com/validation/1.0/AuthenticationService")) }
    end

    describe "#element_form_default" do
      it "returns element_form_default" { document.element_form_default.should eq "unqualified" }
    end

    it "has 1 operation" do
      document.operations.size.should eq(1)
    end

    describe "#operations" do
      it "returns operations" do
        operation = document.operations.first_value
        operation.name.should eq("authenticate")
        operation.action.should eq("authenticate")
        operation.namespace_identifier.should eq("tns")

        operation.inputs.first.name.should eq("authenticate")
        operation.outputs.not_nil!.first.name.should eq("authenticateResponse")
      end
    end
  end
end
