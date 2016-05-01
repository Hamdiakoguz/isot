require "../../spec_helper"

describe Isot::Document do
  context "with: savon295.wsdl" do
    document = Isot::Document.new fixture(:savon295).read

    describe "#operations" do
      it "returns operations" do
        sendsms = document.operations["sendsms"]
        sendsms.name.should eq("sendsms")
        sendsms.action.should eq("sendsms")
        sendsms.namespace_identifier.should eq("tns")
        sendsms.outputs.not_nil!.first.name.should eq("body")
        sendsms.outputs.not_nil!.first.type.not_nil!.should eq("xsd:string")

        expected = {
          "sender"      => "xsd:string",
          "cellular"    => "xsd:string",
          "msg"         => "xsd:string",
          "smsnumgroup" => "xsd:string",
          "emailaddr"   => "xsd:string",
          "udh"         => "xsd:string",
          "datetime"    => "xsd:string",
          "format"      => "xsd:string",
          "dlrurl"      => "xsd:string",
        }
        sendsms.inputs.each do |input|
          expected[input.name].should eq input.type
        end
      end
    end
  end
end
