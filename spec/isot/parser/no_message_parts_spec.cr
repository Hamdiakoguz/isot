require "../../spec_helper"

describe Isot::Parser do
  context "with: no_message_parts.wsdl" do

    subject = fixture(:no_message_parts).parse

    it "falls back to using the message type in the port element" do
      # Operation"s input has no part element in the message, so using the message type.
      subject.operations["save"].inputs.first.should eq(Isot::Message.new("Save"))

      # Operation"s output has part element in the message, so using part element"s type.
      subject.operations["save"].outputs.not_nil!.first.should eq(Isot::Message.new("SaveSoapOut", "SaveResponse"))
    end

    it "falls back to using the namespace ID in the port element" do
      subject.operations["save"].namespace_identifier.should eq("actions")
    end

    it "gracefully handles port messages without a colon" do
      subject.operations["delete"].inputs.first.should eq(Isot::Message.new("Delete"))
      subject.operations["delete"].outputs.not_nil!.first.should eq(Isot::Message.new("DeleteSoapOut", "DeleteResponse"))
      subject.operations["delete"].namespace_identifier.should be_nil
    end
  end
end
