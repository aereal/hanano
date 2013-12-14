# encoding: utf-8

require 'text/hatena'

describe Text::Hatena do
  subject(:parser) { Text::Hatena.new }

  it "matches a list" do
    expect(parser).to parse("- a\n+ a\n")
  end

  it "matches a heading" do
    expect(parser).to parse("* a\n")
  end

  it "matches a heading and a list" do
    expect(parser).to parse("* a\n- a\n+ a\n** a\n")
  end

  it "matches a paragraph" do
    expect(parser).to parse("a\na\n")
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

      it "can not parse the blockquote begin annotation" do
        expect(parser).not_to parse(">>")
      end

      it "can not parse the blockquote end annotation" do
        expect(parser).not_to parse("<<")
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

    describe "List item" do
      subject(:parser) { Text::Hatena.new.list_item }

      it "parses unordered list item" do
        expect(parser).to parse("- aaa\n")
      end

      it "parses ordered list item" do
        expect(parser).to parse("+ aaa\n")
      end

      it "parses mixed list item" do
        expect(parser).to parse("-+ aaaa\n")
      end

      it "can not parse that starts with no annotations" do
        expect(parser).not_to parse("a\n")
      end

      it "can not parse that starts with invalid annotations" do
        expect(parser).not_to parse("* a\n")
      end
    end

    describe "List" do
      subject(:parser) { Text::Hatena.new.list }

      it "parses a list which has a item" do
        expect(parser).to parse("- aaa\n")
      end

      it "parses a list which has some items" do
        expect(parser).to parse("- aaa\n- aaa\n")
      end

      it "can not parse a list which has a heading" do
        expect(parser).not_to parse("- aaa\n- aaa\n* aaa\n")
      end
    end

    describe "Paragraph" do
      subject(:parser) { Text::Hatena.new.paragraph }

      it "parses a paragraph with a line" do
        expect(parser).to parse("a\n")
      end

      it "parses a paragraph with multi lines" do
        expect(parser).to parse("a\nb\n")
      end

      it "parses a paragraph with blank lines" do
        expect(parser).to parse("\n\n")
      end

      it "parses a line contains ascii characters" do
        expect(parser).to parse("abc\n")
      end

      it "parses a line contains unicode characters" do
        expect(parser).to parse("ゆのっち\n")
      end

      it "parses blank line" do
        expect(parser).to parse("\n")
      end

      it "can not parse a characters that ends with no line breaks" do
        expect(parser).not_to parse("aaa")
      end

      it "can not parse a end of blockquote" do
        expect(parser).not_to parse("<<\n")
      end
    end

    describe "Blockquote" do
      subject(:parser) { Text::Hatena.new.blockquote }

      it "parses with no contents" do
        expect(parser).to parse(">>\n<<\n")
      end

      it "parses with contents" do
        expect(parser).to parse(">>\nhogehoge\nhogehoge\n<<\n")
      end

      it "parses with cite URL" do
        expect(parser).to parse(">http://example.com/>\nhogehoge\n<<\n")
      end

      it "contains some block nodes" do
        expect(parser).to parse(">>\n* hogehoge\n- a\n<<\n")
      end
    end

    describe "Pre" do
      subject(:parser) { Text::Hatena.new.pre }

      it "parses with contents" do
        expect(parser).to parse(">||\n#!/bin/sh\necho bye\n||<\n")
      end

      it "parses with a language specification" do
        expect(parser).to parse(">|sh|\n#!/bin/sh\necho bye\n||<\n")
      end
    end
  end
end
