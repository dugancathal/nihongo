module StudyCards
  module Mochi
    class Card < Data.define(:content, :deck_id, :id, :name, :pos, :reviews, :reverse_reviews, :created_at)
      def self.parse(transit_json)
        reviews = Array(transit_json["~:reviews"]).map { Mochi::Review.parse(_1) }
        reverse_reviews = Array(transit_json["~:reverse-reviews"]).map { Mochi::Review.parse(_1) }
        self.new(
          content: transit_json["~:content"],
          deck_id: transit_json["~:deck_id"],
          id: transit_json["~:id"],
          created_at: TransitJson.timestampify(transit_json["~:created-at"]),
          name: transit_json["~:name"],
          pos: transit_json["~:pos"],
          reviews:,
          reverse_reviews:
        )
      end

      def initialize(
        content:,
        deck_id: nil,
        id: nil,
        name: nil,
        pos: nil,
        reviews: [],
        reverse_reviews: [],
        created_at: Time.now.utc.round(0)
      )
        super
      end

      def as_transit_json
        {
          "~:content": content,
          "~:id": TransitJson.keywordify(id),
          "~:reviews": reviews.map(&:as_transit_json),
          "~:reverse-reviews": reverse_reviews.map(&:as_transit_json),
          "~:created-at": { "~#dt": created_at.to_i * 1000 },
        }.merge({
          "~:deck_id": deck_id,
          "~:name": name,
          "~:pos": pos,
        }.compact)
      end
    end
  end
end

