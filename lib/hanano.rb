require "parslet"

class Hanano < Parslet::Parser
  rule(:new_line) { str("\n") }
  rule(:spaces) { match(/\s/).repeat(1) }
  rule(:spaces?) { spaces.maybe }
  rule(:reserved_annotations) {
    heading_annotation |
    list_annotation |
    blockquote_begin_annotation |
    blockquote_end_annotation |
    pre_begin_annotation |
    pre_format_specification_annotation
  }
  rule(:plain_character) { reserved_annotations.absent? >> match(/[^\n]/) }
  rule(:plain_text) { plain_character.repeat }

  rule(:heading_annotation) { str('*') }
  rule(:heading_annotations) {
    heading_annotation.
    repeat(1, 3).
    as(:heading_annotations)
  }
  rule(:heading) {
    (
      heading_annotations >>
      spaces? >>
      plain_text >>
      new_line
    ).as(:heading)
  }

  rule(:unordered_list_annotation) { str('-') }
  rule(:ordered_list_annotation) { str('+') }
  rule(:list_annotation) { unordered_list_annotation | ordered_list_annotation }
  rule(:list_annotations) { list_annotation.repeat(1) }
  rule(:list_item) {
    (
      list_annotations.as(:annotations) >>
      spaces? >>
      plain_text >>
      new_line
    ).as(:list_item)
  }
  rule(:list) { list_item.repeat(1).as(:list) }

  rule(:blockquote_begin_annotation) { str(">") }
  rule(:blockquote_begin) {
    blockquote_begin_annotation >>
    spaces? >>
    plain_text.as(:cite) >>
    spaces? >>
    blockquote_begin_annotation >>
    new_line
  }
  rule(:blockquote_end_annotation) { str("<") }
  rule(:blockquote_end) { blockquote_end_annotation.repeat(2, 2) >> new_line }
  rule(:blockquote) {
    blockquote_begin >>
    block_nodes.repeat.as(:content) >>
    blockquote_end
  }

  rule(:pre_begin) {
    pre_begin_annotation >>
    pre_format_specification >>
    new_line
  }
  rule(:pre_begin_annotation) { str(">") }
  rule(:pre_format_specification_annotation) { str("|") }
  rule(:pre_format_specification) {
    pre_format_specification_annotation >>
    pre_format.maybe >>
    pre_format_specification_annotation
  }
  rule(:pre_format) {
    match(/[\w\-]/).
    repeat(1).
    as(:format)
  }
  rule(:pre_end_annotation) { str("||<") }
  rule(:pre_end) { pre_end_annotation >> new_line }
  rule(:pre) {
    pre_begin >>
    (plain_text >> new_line).repeat.as(:content) >>
    pre_end
  }

  rule(:paragraph) { (plain_text >> new_line).repeat(1) }

  rule(:block_nodes) {
    heading |
    list |
    blockquote |
    pre |
    paragraph
  }
  rule(:expression) { block_nodes.repeat(1) }

  root(:expression)
end
