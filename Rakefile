require "minitest/test_task"

Minitest::TestTask.create(:test) do |t|
  t.libs << "test"
  t.libs << "test/support"
  t.libs << "lib"
  t.test_globs = "test/**/*_test.rb"
end

task :default => :test

task :environment do
  require_relative './lib/nihongo'
end

task :sync, [:file] => [:environment] do |t, args|
  Nihongo::Sync.call(path: args[:file])
end

task :dump, [:file] => [:environment] do |t, args|
  Nihongo::Sync.dump(to: args[:file])
end
