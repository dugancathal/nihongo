require "test_helper"
require "rack/test"

class Nihongo::AppTest < Minitest::Test
  include Rack::Test::Methods

  def app = Nihongo::App

  def test_get_index
    get "/"
    assert_equal 200, last_response.status
  end

  def test_sync
    post "/sync", file: Rack::Test::UploadedFile.new("test/fixtures/vocab.mochi", "application/zip")
    assert_equal 200, last_response.status

    response_zip = Nihongo::Mochi::ZipFile.parse_stream(stream: last_response.body)
    actual_decks = Nihongo::MarkdownDecks.load
    actual_deck_names = (actual_decks.map(&:name) + %w[Nihongo]).to_set
    assert_equal actual_deck_names, response_zip.decks.map(&:name).to_set
  end
end