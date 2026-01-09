module Nihongo
  module Mochi
    class Deck
      def initialize(id:, cards: [], parent_id: nil)
        @id = id
        @cards = cards
        @parent_id = parent_id
      end
    end
  end
end
