module Nihongo
  module Mochi
    class Review
      def initialize(date:, due:, interval:, remembered:)
        @date = date
        @due = due
        @interval = interval
        @remembered = remembered
      end
    end
  end
end
