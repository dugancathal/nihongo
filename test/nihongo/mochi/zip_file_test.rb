require "test_helper"

# TODO: id validation

class Nihongo::Mochi::ZipFileTest < Minitest::Test
  def test_merge_empty_markdowns_returns_same
    deck = Nihongo::Mochi::Deck.new(id: "~:initial", name: "Initial")
    zipfile = Nihongo::Mochi::ZipFile.new(decks: [deck])

    assert_equal [deck], zipfile.merge([]).decks
  end

  def test_merge_single_card_uses_markdown_as_source_of_truth
    deck = Nihongo::Mochi::Deck.new(
      id: "~:initial",
      name: "Initial",
      parent_id: "~:parent",
      cards: [
        Nihongo::Mochi::Card.new(
          id: "~:card1234",
          content: "\nmisspelled happiness\n---\n幸せ\n",
          deck_id: "~:initial",
          reviews: [
            Nihongo::Mochi::Review.new(
              date: Time.parse("2021-03-04T00:00:00Z"),
              due: Time.parse("2021-03-05T00:00:00Z"),
              duration: 1,
              remembered: true,
              interval: 1
            ),
          ]
        )
      ]
    )
    zipfile = Nihongo::Mochi::ZipFile.new(decks: [deck])

    markdown_decks = Nihongo::MarkdownDecks.new(decks: [
      Nihongo::Deck.new(id: "~:initial", name: "Initial", cards: [
        Nihongo::Card.new(id: "~:card1234", front: "corrected happiness", back: "幸せ"),
      ]),
    ])

    expected_deck = deck.with(
      cards: [
        deck.cards[0].with(
          content: "\ncorrected happiness\n---\n幸せ\n",
        )
      ]
    )

    assert_equal [expected_deck], zipfile.merge(markdown_decks).decks
  end

  def test_dump_to_generates_valid_mochi_file
    deck = Nihongo::Mochi::Deck.new(
      id: "~:initial",
      name: "Initial",
      cards: [
        Nihongo::Mochi::Card.new(
          id: "~:card1234",
          content: "\nmisspelled happiness\n---\n幸せ\n",
          deck_id: "~:initial",
          reviews: [
            Nihongo::Mochi::Review.new(
              date: Time.parse("2021-03-04T00:00:00Z"),
              due: Time.parse("2021-03-05T00:00:00Z"),
              duration: 1,
              remembered: true,
              interval: 1
            ),
          ]
        )
      ]
    )
    zipfile = Nihongo::Mochi::ZipFile.new(decks: [deck])

    dumped_decks = nil
    Dir.mktmpdir do |dir|
      outpath = dir + "/dumped.mochi"
      zipfile.dump_to(path: outpath)

      parsed = Nihongo::Mochi::ZipFile.parse(path: outpath)
      dumped_decks = parsed.decks
    end

    assert_equal [deck], dumped_decks
  end
end
