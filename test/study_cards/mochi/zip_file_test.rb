require "test_helper"

# TODO: id validation

class StudyCards::Mochi::ZipFileTest < Minitest::Test
  def test_merge_empty_markdowns_returns_same
    deck = StudyCards::Mochi::Deck.new(id: "~:initial", name: "Initial")
    zipfile = StudyCards::Mochi::ZipFile.new(decks: [deck])

    assert_equal [deck], zipfile.merge([]).decks
  end

  def test_merge_single_card_uses_markdown_as_source_of_truth
    deck = StudyCards::Mochi::Deck.new(
      id: "~:initial",
      name: "Initial",
      parent_id: "~:parent",
      cards: [
        StudyCards::Mochi::Card.new(
          id: "~:card1234",
          content: "\nmisspelled happiness\n---\n幸せ\n",
          deck_id: "~:initial",
          reviews: [
            StudyCards::Mochi::Review.new(
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
    zipfile = StudyCards::Mochi::ZipFile.new(decks: [deck])

    markdown_decks = StudyCards::MarkdownDecks.new(decks: [
      StudyCards::Deck.new(id: "~:initial", name: "Initial", cards: [
        StudyCards::Card.new(id: "~:card1234", front: "corrected happiness", back: "幸せ"),
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

  def test_merge_with_root_deck_sets_parent_id_and_merges_root_deck_in
    deck = StudyCards::Mochi::Deck.new(
      id: "~:initial",
      name: "Initial",
      parent_id: "~:originalparent"
    )
    zipfile = StudyCards::Mochi::ZipFile.new(decks: [deck])

    markdown_decks = StudyCards::MarkdownDecks.new(decks: [
      StudyCards::Deck.new(id: "~:initial", name: "Initial", cards: []),
    ])

    root_deck = StudyCards::Deck.new(
      id: "~:newrootid",
      name: "New Root"
    )

    expected_deck = deck.with(
      parent_id: "~:newrootid"
    )

    assert_equal [root_deck.to_mochi, expected_deck], zipfile.merge(markdown_decks, root_deck:).decks
  end

  def test_dump_to_generates_valid_mochi_file
    deck = StudyCards::Mochi::Deck.new(
      id: "~:initial",
      name: "Initial",
      cards: [
        StudyCards::Mochi::Card.new(
          id: "~:card1234",
          content: "\nmisspelled happiness\n---\n幸せ\n",
          deck_id: "~:initial",
          reviews: [
            StudyCards::Mochi::Review.new(
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
    zipfile = StudyCards::Mochi::ZipFile.new(decks: [deck])

    dumped_decks = nil
    Dir.mktmpdir do |dir|
      outpath = dir + "/dumped.mochi"
      zipfile.dump_to(path: outpath)

      parsed = StudyCards::Mochi::ZipFile.parse(path: outpath)
      dumped_decks = parsed.decks
    end

    assert_equal [deck], dumped_decks
  end

  def test_merge_cloze_card
    deck = StudyCards::Mochi::Deck.new(
      id: "~:initial",
      name: "Initial",
      cards: [
        StudyCards::Mochi::Card.new(
          id: "~:cloze123",
          content: "\nThis is a {{cloze}}.\n",
          deck_id: "~:initial"
        )
      ]
    )
    zipfile = StudyCards::Mochi::ZipFile.new(decks: [deck])

    markdown_decks = StudyCards::MarkdownDecks.new(decks: [
      StudyCards::Deck.new(id: "~:initial", name: "Initial", cards: [
        StudyCards::Card.new(id: "~:cloze123", front: "This is a {{cloze}}.", back: nil),
      ]),
    ])

    expected_deck = deck.with(
      cards: [
        deck.cards[0].with(
          content: "\nThis is a {{cloze}}.\n",
        )
      ]
    )

    assert_equal [expected_deck], zipfile.merge(markdown_decks).decks
  end

  def test_dump_markdown
    deck_alpha = StudyCards::Mochi::Deck.new(
      id: "~:alpha",
      name: "Alpha",
      cards: [
        StudyCards::Mochi::Card.new(
          id: "~:card1234",
          content: "\na\n---\nalpha\n",
          deck_id: "~:alpha",
          reviews: []
        )
      ]
    )
    deck_bravo = StudyCards::Mochi::Deck.new(
      id: "~:bravo",
      name: "Bravo",
      cards: [
        StudyCards::Mochi::Card.new(
          id: "~:card5678",
          content: "\nb\n---\nbravo\n",
          deck_id: "~:bravo",
          reviews: []
        )
      ]
    )
    zipfile = StudyCards::Mochi::ZipFile.new(decks: [deck_alpha, deck_bravo])

    dumped_markdown_decks = nil
    Dir.mktmpdir do |dir|
      dir = Pathname(dir)
      zipfile.dump_markdown_to(path: dir, name: 'nato')
      dumped_markdown_decks = StudyCards::MarkdownDecks.load(data_dir: dir, root_deck: 'nato')
    end

    assert_equal ['nato', deck_alpha.name, deck_bravo.name], dumped_markdown_decks.map(&:name)
    assert_equal 0, dumped_markdown_decks.root_deck.cards.size

    dumped_decks = dumped_markdown_decks.map(&:itself)

    alpha_card = StudyCards::Card.new(id: "card1234", front: "a", back: "alpha")
    assert_equal alpha_card, dumped_decks[1].cards[0]

    bravo_card = StudyCards::Card.new(id: "card5678", front: "b", back: "bravo")
    assert_equal bravo_card, dumped_decks[2].cards[0]
  end
end
