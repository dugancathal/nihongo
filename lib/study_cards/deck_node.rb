module StudyCards
  class DeckNode
    attr_reader :deck, :children

    def initialize(deck:, children: [])
      @deck = deck
      @children = children
    end

    def add_child(node)
      @children << node
    end

    def each_deck_with_parent(parent = nil, &block)
      return enum_for(:each_deck_with_parent, parent) unless block

      yield deck, parent if parent

      children.each do |child|
        child.each_deck_with_parent(deck, &block)
      end
    end
  end
end
