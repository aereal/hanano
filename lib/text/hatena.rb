require "parslet"

module Text
  class Hatena < Parslet::Parser
    rule(:new_line) { str("\n") }
    rule(:spaces) { match(/\s/).repeat(1) }
    rule(:spaces?) { spaces.maybe }
    rule(:reserved_annotations) {
      heading_annotation
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

    rule(:block_nodes) {
      heading
    }
    rule(:expression) { block_nodes.repeat(1) }

    root(:expression)
  end
end
