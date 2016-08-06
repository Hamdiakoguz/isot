require "../../spec_helper"

describe Isot::Parser do
  context "with: multiple_namespaces.wsdl" do

    subject = fixture(:multiple_namespaces).parse

    it "lists the types" do
      subject.types.keys.sort.should eq(["Article", "Save"])
    end

    it "records the namespace for each type" do
      subject.types["Save"].namespace.should eq("http://example.com/actions")
    end

    it "records the fields under a type" do
      subject.types["Save"].elements.first.should eq(Isot::Element.new("article", "article:Article"))
    end

    it "records multiple fields when there are more than one" do
      subject.types["Article"].elements.map(&.name).should eq(["Author", "Title"])
    end

    it "records the type of a field" do
      article = subject.types["Save"].elements.find {|e| e.name == "article"}
      article.not_nil!.type.should eq("article:Article")
      subject.namespaces["article"].should eq("http://example.com/article")
    end
  end
end
