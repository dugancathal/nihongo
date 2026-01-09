module Nihongo
  module Mochi
    class Card
      def initialize(content:, deck_id:, id: nil, name: nil, pos: nil, reviews: [])
        @content = content
        @deck_id = deck_id
        @id = id
        @name = name
        @pos = pos
        @reviews = reviews
      end
    end
  end
end

