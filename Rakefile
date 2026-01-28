require "minitest/test_task"

Minitest::TestTask.create(:test) do |t|
  t.libs << "test"
  t.libs << "test/support"
  t.libs << "lib"
  t.test_globs = "test/**/*_test.rb"
end

task :default => :test

task :environment do
  require_relative './lib/study_cards'
end

task :sync, [:root_deck, :file] => [:environment] do |t, args|
  root_deck = args[:root_deck]
  file = args[:file] || root_deck
  root_deck = nil if args[:file].nil?
  StudyCards::Sync.call(root_deck_dir: root_deck, path: file)
end

task :mochify, [:root_deck, :file] => [:environment] do |t, args|
  root_deck = args[:root_deck]
  file = args[:file] || root_deck
  root_deck = nil if args[:file].nil?
  StudyCards::Sync.mochify(root_deck_dir: root_deck, to: file)
end

task :markdownify, [:root_deck, :file] => [:environment] do |t, args|
  root_deck = args[:root_deck]
  file = args[:file] || root_deck
  root_deck = nil if args[:file].nil?
  StudyCards::Sync.markdownify(root_deck:, from: file)
end
