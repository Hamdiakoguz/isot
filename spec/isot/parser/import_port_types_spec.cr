require "../../spec_helper"

describe Isot::Parser do
  context "with: import_port_types.wsdl" do

    subject = fixture(:import_port_types).parse

    it "does blow up when portTypes are imported" do
      get_customer = subject.operations["get_customer"]

      get_customer.input.should eq("GetCustomer")
      get_customer.namespace_identifier.should be_nil
    end

  end
end
