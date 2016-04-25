require "../../spec_helper"

describe Isot::Parser do
  context "with: juniper.wsdl" do

    subject = fixture(:juniper).parse

    it "does not blow up when an extension base element is defined in an import" do
      request = subject.operations["get_system_info_request"]

      request.input.should eq("GetSystemInfoRequest")
      request.action.should eq("urn:#GetSystemInfoRequest")
      request.namespace_identifier.should eq("impl")
    end

  end
end
