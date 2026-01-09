module Nihongo
  module Mochi
    class Card
      def self.parse(transit_json)
        reviews = Array(transit_json["~:reviews"]).map { Mochi::Review.parse(_1) }
        binding.irb
        self.new(
          content: transit_json["~:content"],
          deck_id: transit_json["~:deck_id"],
          id: transit_json["~:id"],
          created_at: TransitJson.timestampify(transit_json["~:created-at"]),
          name: transit_json["~:name"],
          pos: transit_json["~:pos"],
          reviews:,
        )
      end

      attr_reader :content, :deck_id, :id, :name, :pos, :reviews, :created_at

      def initialize(content:, deck_id:, id: nil, name: nil, pos: nil, reviews: [], created_at: nil)
        @content = content
        @deck_id = deck_id
        @id = id
        @name = name
        @pos = pos
        @reviews = reviews
        @created_at = created_at || Time.now
      end

      def as_transit_json
        {
          "~:content": content,
          "~:deck_id": deck_id,
          "~:id": id,
          "~:name": name,
          "~:pos": pos,
          "~:reviews": reviews.map(&:as_transit_json),
          "~:created-at": { "~#dt": created_at.to_i * 1000 },
        }
      end
    end
  end
end

