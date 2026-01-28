module StudyCards
  module Sync
    def self.call(root_deck: "nihongo", path:)
      app_data = StudyCards::Mochi::ZipFile.parse(path:)
      source_of_truth = StudyCards::MarkdownDecks.load(root_deck:)
      app_data.merge(source_of_truth, root_deck: source_of_truth.root_deck).dump_to(path: path + ".#{Time.now.to_i}.mochi")
    end

    def self.stream(root_deck: "nihongo", from:, to:)
      app_data = StudyCards::Mochi::ZipFile.parse_stream(stream: from)
      source_of_truth = StudyCards::MarkdownDecks.load(root_deck:)

      outstream = StringIO.new
      app_data.merge(source_of_truth, root_deck: source_of_truth.root_deck).stream_to(to: outstream)

      outstream.rewind
      outstream.each { to << it }
    end

    def self.mochify(root_deck: "nihongo", to:)
      app_data = StudyCards::Mochi::ZipFile.new

      source_of_truth = StudyCards::MarkdownDecks.load(root_deck:)
      app_data.merge(source_of_truth, root_deck: source_of_truth.root_deck).dump_to(path: to)
    end

    def self.markdownify(root_deck: "nihongo", from:)
      app_data = StudyCards::Mochi::ZipFile.parse(path: from)
      app_data.dump_markdown_to(path: StudyCards.default_data_dir, name: root_deck)
    end
  end
end
