require "minitest/test_task"

Minitest::TestTask.create(:test) do |t|
  t.libs << "test"
  t.libs << "test/support"
  t.libs << "lib"
  t.test_globs = "test/**/*_test.rb"
end

task :default => :test

task :sync, [:file] do |t, args|
  require_relative './lib/nihongo'
  Nihongo::Sync.call(path: args[:file])
end
