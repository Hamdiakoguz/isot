require "../../spec_helper"

describe Isot::Parser do
  context "with: no_namespace.wsdl" do

    subject = fixture(:no_namespace).parse

    # it "lists the types" do
    #   subject.types.keys.sort.should eq(["McContact", "McContactArray", "MpUser", "MpUserArray"])
    # end

    # it "ignores xsd:all" do
    #   keys =  subject.types["MpUser"].keys
    #   keys.size.should eq(2)

    #   keys.includes?(:namespace).should be_true
    #   keys.includes?(:order!).should be_true
    # end
  end
end
