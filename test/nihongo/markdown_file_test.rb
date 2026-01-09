require 'test_helper'

class TestMarkdownFile < Minitest::Test
  def test_parse_file
    file = Nihongo::MarkdownFile.parse(content: <<~MARKDOWN, filename: "vocab-1")
    Translate: happiness
    ---
    幸せ
    MARKDOWN

    assert_equal 1, file.cards.size

    card = file.cards.first
    assert_equal "Translate: happiness", card.front
    assert_equal "幸せ", card.back
  end

  def test_parse_file_multiple_cards
    file = Nihongo::MarkdownFile.parse(content: <<~MARKDOWN, filename: "vocab-2")
    Translate: happiness
    ---
    幸せ
    -------
    Translate: to go
    ---
    行く
    -------
    MARKDOWN

    assert_equal 2, file.cards.size
    assert_equal ["幸せ", "行く"], file.cards.map(&:back)
  end

  def test_deck_name_comes_from_filename
    file = Nihongo::MarkdownFile.parse(content: "", filename: "vocab")
    assert_equal "vocab", file.deck_name
  end

  def test_deck_name_is_filename_without_number
    file = Nihongo::MarkdownFile.parse(content: "", filename: "vocab-1999")
    assert_equal "vocab", file.deck_name
  end
end
