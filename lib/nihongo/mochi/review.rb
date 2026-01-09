module Nihongo
  module Mochi
    class Review
      def self.parse(transit_json)
        self.new(
          date: TransitJson.timestampify(transit_json["~:date"]),
          due: TransitJson.timestampify(transit_json["~:due"]),
          interval: transit_json["~:interval"],
          remembered: transit_json["~:remembered?"],
          duration: transit_json["~:duration"],
        )
      end

      attr_reader :date, :due, :interval, :remembered, :duration

      def initialize(date:, due:, interval:, remembered:, duration:)
        @date = date
        @due = due
        @interval = interval
        @remembered = remembered
        @duration = duration
      end

      def as_transit_json
        {
          "~:date": "~t#{date.to_i * 1000}",
          "~:due": "~t#{due.to_i * 1000}",
          "~:interval": interval,
          "~:remembered?": remembered,
          "~:duration": duration,
        }
      end
    end
  end
end
