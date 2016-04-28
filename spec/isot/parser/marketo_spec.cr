require "../../spec_helper"

describe Isot::Parser do
  context "with: marketo.wsdl" do
    subject = fixture(:marketo).parse

    it "parses the operations" do
      subject.operations["get_lead"].inputs.first.should eq(Isot::Message.new("GetLeadRequest", "paramsGetLead"))
    end
  end
end
