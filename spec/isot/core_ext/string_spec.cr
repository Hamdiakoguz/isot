require "../../spec_helper"

describe Isot::CoreExt::String do
  describe ".snakecase" do
    it "lowercases one word CamelCase" do
      Isot::CoreExt::String.snakecase("Merb").should eq("merb")
    end

    it "makes one underscore snakecase two word CamelCase" do
      Isot::CoreExt::String.snakecase("MerbCore").should eq("merb_core")
    end

    it "handles CamelCase with more than 2 words" do
      Isot::CoreExt::String.snakecase("SoYouWantContributeToMerbCore").should eq("so_you_want_contribute_to_merb_core")
    end

    it "handles CamelCase with more than 2 capital letter in a row" do
      Isot::CoreExt::String.snakecase("CNN").should eq("cnn")
      Isot::CoreExt::String.snakecase("CNNNews").should eq("cnn_news")
      Isot::CoreExt::String.snakecase("HeadlineCNNNews").should eq("headline_cnn_news")
    end

    it "does NOT change one word lowercase" do
      Isot::CoreExt::String.snakecase("merb").should eq("merb")
    end

    it "leaves snake_case as is" do
      Isot::CoreExt::String.snakecase("merb_core").should eq("merb_core")
    end

    it "converts period characters to underscores" do
      Isot::CoreExt::String.snakecase("User.GetEmail").should eq("user_get_email")
    end
  end
end
