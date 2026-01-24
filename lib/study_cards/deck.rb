module StudyCards
  class Deck < Data.define(:name, :id, :cards)
    def initialize(name:, id: nil, cards: [])
      super(name:, id: id || StudyCards.gen_id, cards:)
    end

    def add_cards(*cards)
      self.cards.push(*cards.flatten)
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

