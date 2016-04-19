require "../../spec_helper"

describe Isot::Parser do
  context "with: multiple_namespaces.wsdl" do

    subject = fixture(:multiple_namespaces).parse

    # it "lists the types" do
    #   subject.types.keys.sort.should eq(["Article", "Save"])
    # end

    # it "records the namespace for each type" do
    #   subject.types["Save"][:namespace].should eq("http://example.com/actions")
    # end

    # it "records the fields under a type" do
    #   subject.types["Save"].keys.should match_array(["article", :namespace, :order!])
    # end

    # it "records multiple fields when there are more than one" do
    #   subject.types["Article"].keys.should match_array(["Title", "Author", :namespace, :order!])
    # end

    # it "records the type of a field" do
    #   subject.types["Save"]["article"][:type].should eq("article:Article")
    #   subject.namespaces["article"].should eq("http://example.com/article")
    # end

    # it "lists the order of the type elements" do
    #   subject.types["Article"][:order!].should eq(["Author", "Title"])
    # end

  end
end
