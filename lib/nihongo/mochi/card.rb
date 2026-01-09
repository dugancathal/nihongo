module Nihongo
  module Mochi
    class Card < Data.define(:content, :deck_id, :id, :name, :pos, :reviews, :created_at)
      def self.parse(transit_json)
        reviews = Array(transit_json["~:reviews"]).map { Mochi::Review.parse(_1) }
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

      def initialize(content:, deck_id:, id: nil, name: nil, pos: nil, reviews: [], created_at: Time.now)
        super(content:, deck_id:, id:, name:, pos:, reviews:, created_at:)
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

