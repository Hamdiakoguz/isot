require "../../spec_helper"

describe Isot::Parser do
  context "with: multiple_parts_in_message.wsdl" do

    subject = fixture(:multiple_parts_in_message).parse

    context "with a parts attribute in soap:body element" do
      it "uses the part specified in parts attribute" do
        request = subject.operations[:some_operation][:input]

        request.should eq("SomeRequestBody")
      end
    end

    context "with no parts attribute in soap:body element" do
      it "uses the first part element in message" do
        request = subject.operations[:other_operation][:input]

        request.should eq("SomeRequest")
      end
    end

  end
end
