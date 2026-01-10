module Nihongo
  class Card < Data.define(:id, :front, :back)
    def self.try_parse(raw)
      lines = raw.lines.map(&:strip).reject(&:empty?)
      id = raw.start_with?("#ID:") ? lines.shift.split(":").last : Nihongo.gen_id
      side_boundary_index = lines.find_index { it == "---" }
      front = lines[0...side_boundary_index].join("\n")
      back = lines[side_boundary_index+1..].join("\n")

      self.new(id:, front:, back:)
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

