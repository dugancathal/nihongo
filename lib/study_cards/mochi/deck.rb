module StudyCards
  module Mochi
    class Deck < Data.define(
      :id,
      :cards,
      :cards_view,
      :forgetting_multiplier,
      :max_interval,
      :multiplier_noise,
      :name,
      :new_cards_limit,
      :parent_id,
      :remembering_multiplier,
      :retire_cards,
      :review_reverse,
      :show_sides,
      :sort,
      :sort_by
    )
      def self.parse(transit_json)
        cards = TransitJson.arrayify(transit_json["~:cards"]).map { Mochi::Card.parse(_1) }
        self.new(
          id: transit_json["~:id"],
          name: transit_json["~:name"],
          cards:,
          parent_id: transit_json["~:parent-id"],
          remembering_multiplier: transit_json["~:remembering-multiplier"],
          show_sides: transit_json["~:show-sides?"],
          max_interval: transit_json["~:max-interval"],
          multiplier_noise: transit_json["~:multiplier-noise?"],
          cards_view: transit_json["~:cards-view"],
          review_reverse: transit_json["~:review-reverse?"],
          retire_cards: transit_json["~:retire-cards?"],
          sort_by: transit_json["~:sort-by/quick-study"],
          forgetting_multiplier: transit_json["~:forgetting-multiplier"],
          sort: transit_json["~:sort"],
          new_cards_limit: transit_json["~:new-cards-limit"]
        )
      end

      def initialize(
        id:,
        name:,
        cards: [],
        parent_id: nil,
        remembering_multiplier: nil,
        show_sides: true,
        max_interval: nil,
        multiplier_noise: nil,
        cards_view: "~:list",
        review_reverse: nil,
        retire_cards: nil,
        sort_by: "~:random",
        forgetting_multiplier: nil,
        sort: 2,
        new_cards_limit: nil
      )
        super
      end

      def as_transit_json
        {
          "~:id": TransitJson.keywordify(id),
          "~:name": name,
          "~:cards": cards.map(&:as_transit_json),
          "~:parent-id": parent_id,
          "~:remembering-multiplier": remembering_multiplier,
          "~:show-sides?": show_sides,
          "~:max-interval": max_interval,
          "~:multiplier-noise?": multiplier_noise,
          "~:cards-view": cards_view,
          "~:review-reverse?": review_reverse,
          "~:retire-cards?": retire_cards,
          "~:sort-by/quick-study": sort_by,
          "~:forgetting-multiplier": forgetting_multiplier,
          "~:sort": sort,
          "~:new-cards-limit": new_cards_limit,
        }
      end
    end
  end
end
