require "../../spec_helper"

describe Isot::Parser do
  context "with: no_namespace.wsdl" do

    subject = fixture(:no_namespace).parse

    it "lists the types" do
      subject.types.keys.should eq(["MpUser", "MpUserArray", "McContact", "McContactArray"])
    end

    it "ignores xsd:all" do
      keys =  subject.types["MpUser"].elements.size.should eq(0)
    end
  end
end
