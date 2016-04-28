require "../../spec_helper"

describe Isot::Parser do
  context "with: brand.wsdl" do
    subject = fixture(:brand).parse

    it "parses the operations" do
      create_object_input = subject.operations["create_object"].inputs.first
      create_object_input.should eq(Isot::Message.new("templateObject", type: "tns:SoftLayer_Brand"))

      create_customer_account_input = subject.operations["create_customer_account"].inputs
      create_customer_account_input[0].should eq(Isot::Message.new("account", type: "tns:SoftLayer_Account"))
      create_customer_account_input[1].should eq(Isot::Message.new("bypassDuplicateAccountCheck", type: "xsd:boolean"))
    end
  end
end
