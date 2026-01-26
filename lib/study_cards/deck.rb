module StudyCards
  class Deck < Data.define(:name, :id, :cards, :children)
    def initialize(name:, id: nil, cards: [], children: [])
      super(name:, id: id || StudyCards.gen_id, cards:, children:)
    end

    def add_cards(*cards)
      self.cards.push(*cards.flatten)
    end

    def add_subdeck(deck)
      self.children << deck
    end

    def to_mochi
      StudyCards::Mochi::Deck.new(
        id:,
        **as_mochi_attrs
      )
    end

    def as_mochi_attrs
      {
        name:,
        cards: cards.map(&:to_mochi)
      }
    end
  end
end

