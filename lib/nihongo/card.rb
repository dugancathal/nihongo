module Nihongo
  class Card < Data.define(:id, :front, :back)
    # TODO: md files should define the ID ... somewhere
    def initialize(front:, back:, id: nil)
      super(id: id || rand, front:, back:)
    end

    def to_mochi
      Nihongo::Mochi::Card.new(id:, **as_mochi_attrs)
    end

    def as_mochi_attrs
      {
        content: "\n#{front}\n---\n#{back}\n",
        deck_id: "~:initial",
      }
    end
  end
end

