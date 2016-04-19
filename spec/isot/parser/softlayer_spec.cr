require "../../spec_helper"

describe Isot::Parser do
  context "with: brand.wsdl" do
    subject = fixture(:brand).parse

    it "parses the operations" do
      subject.operations[:create_object][:input].should eq({"createObject" => { "templateObject" => ["tns", "SoftLayer_Brand"] }})
      subject.operations[:create_customer_account][:input].should eq({"createCustomerAccount" => {"account" => ["tns", "SoftLayer_Account"], "bypassDuplicateAccountCheck" => ["xsd", "boolean"]}})
    end
  end
end
