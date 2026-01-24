module StudyCards
  class Card < Data.define(:id, :front, :back)
    def self.try_parse(raw)
      lines = raw.lines.map(&:strip).reject(&:empty?)
      id = raw.start_with?("#ID:") ? lines.shift.split(":").last : StudyCards.gen_id
      front = lines.join("\n")

      side_boundary_index = lines.find_index { it == "---" }
      if side_boundary_index
        front = lines[0...side_boundary_index].join("\n")
        back = lines[side_boundary_index+1..].join("\n")
      end

      self.new(id:, front:, back:)
    end

    def to_mochi
      StudyCards::Mochi::Card.new(id:, **as_mochi_attrs)
    end

    def as_mochi_attrs
      content = ["\n", front, "\n"]
      content += ["---\n", back, "\n"] if back

      {
        content: content.join,
      }
    end
  end
end

