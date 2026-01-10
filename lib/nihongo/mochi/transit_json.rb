require "date"

module Nihongo
  module Mochi
    class TransitJson
      def self.arrayify(maybe_list)
        case maybe_list
        when Hash then maybe_list["~#list"]
        when Array then maybe_list
        else Array(maybe_list)
        end
      end

      def self.timestampify(maybe_timestamp)
        case maybe_timestamp
        when /^~t\d{4}-/ then Time.parse(maybe_timestamp).utc
        when /^~t\d+$/ then Time.at(maybe_timestamp[2..].to_i / 1000).utc
        when Hash then Time.at(maybe_timestamp["~#dt"] / 1000).utc
        else 
          raise Exception.new("Unable to timestamptify #{maybe_timestamp}")
        end
      end
    end
  end
end

