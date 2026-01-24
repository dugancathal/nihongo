module StudyCards
  module Sync
    ROOT_DECK = StudyCards::Mochi::Deck.new(
      id: "~:nihongo123",
      name: "Nihongo",
      review_reverse: true
    )

    def self.call(path:)
      app_data = StudyCards::Mochi::ZipFile.parse(path:)
      source_of_truth = StudyCards::MarkdownDecks.load
      app_data.merge(source_of_truth, root_deck: ROOT_DECK).dump_to(path: path + ".#{Time.now.to_i}.mochi")
    end

    def self.stream(from:, to:)
      app_data = StudyCards::Mochi::ZipFile.parse_stream(stream: from)
      source_of_truth = StudyCards::MarkdownDecks.load

      outstream = StringIO.new
      app_data.merge(source_of_truth, root_deck: ROOT_DECK).stream_to(to: outstream)

      outstream.rewind
      outstream.each { to << it }
    end

    def self.dump(to:)
      app_data = StudyCards::Mochi::ZipFile.new

      source_of_truth = StudyCards::MarkdownDecks.load
      app_data.merge(source_of_truth, root_deck: ROOT_DECK).dump_to(path: to)
    end
  end
end
