require "../../spec_helper"

describe Isot::Parser do
  context "with a WSDL defining xs:schema without targetNamespace" do
    xml = <<-XML
      <definitions xmlns="http://schemas.xmlsoap.org/wsdl/"
        xmlns:xs="http://www.w3.org/2001/XMLSchema"
        targetNamespace="http://def.example.com">
        <types>
          <xs:schema elementFormDefault="qualified">
            <xs:element name="Save">
              <xs:complexType></xs:complexType>
            </xs:element>
          </xs:schema>
        </types>
      </definitions>
    XML

    subject = Isot::Parser.new(XML.parse(xml))
    subject.parse

    # Don"t know if real WSDL files omit targetNamespace from xs:schema,
    # but I suppose we should do something reasonable if they do.

    # it "defaults to the target namespace from xs:definitions" do
    #   subject.types["Save"][:namespace].should eq("http://def.example.com")
    # end

  end
end
