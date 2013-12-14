# encoding: utf-8

require 'text/hatena'

describe Text::Hatena do
  subject(:parser) { Text::Hatena.new }

  it "matches a heading" do
    expect(parser).to parse("* a\n")
  end

  describe "Inline nodes" do
    describe "Text" do
      subject(:parser) { Text::Hatena.new.plain_text }

      it "parses empty string" do
        expect(parser).to parse("")
      end

      it "parses ascii characters" do
        expect(parser).to parse("yunocchi")
      end

      it "parses unicode characters" do
        expect(parser).to parse("ゆのっち")
      end

      it "parses whitespaces" do
        expect(parser).to parse("\t ")
      end

      it "parses URL" do
        expect(parser).to parse("http://example.com/")
      end

      it "can not parse that ends with new line" do
        expect(parser).not_to parse("aa\n")
      end
    end
  end

  describe "Block nodes" do
    describe "Heading" do
      subject(:parser) { Text::Hatena.new.heading }

      it "parses ascii characters" do
        expect(parser).to parse("* yunocchi\n")
      end

      it "can not parse with too many annotations" do
        expect(parser).not_to parse("**** yunocchi\n")
      end

      it "can not parse that start with no annotations" do
        expect(parser).not_to parse("aaa\n")
      end
    end
  end
end
