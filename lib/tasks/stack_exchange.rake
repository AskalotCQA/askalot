# Usage:
#
# rake stack_exchange:users
# rake stack_exchange:posts
# rake stack_exchange:comments
# rake stack_exchange:votes
# rake stack_exchange:all

namespace :stack_exchange do
  desc "Import Stack Exchange users"
  task :users, [:url] => :environment do |_, args|
    processor = StackExchange::Processor::Users.new

    processor.process("#{ENV['PATH']}/Users.xml")
  end

  desc "Import Stack Exchange posts"
  task :posts, [:url] => :environment do |_, args|
    processor = StackExchange::Processor::Posts.new

    processor.process("#{ENV['PATH']}/Posts.xml")
  end

  desc "Import Stack Exchange comments"
  task :comments, [:url] => :environment do |_, args|
    processor = StackExchange::Processor::Comments.new

    processor.process("#{ENV['PATH']}/Comments.xml")
  end

  desc "Import Stack Exchange votes"
  task :votes, [:url] => :environment do |_, args|
    processor = StackExchange::Processor::Votes.new

    processor.process("#{ENV['PATH']}/Votes.xml")
  end

  desc "Import Stack Exchange votes"
  task :post_history, [:url] => :environment do |_, args|
    processor = StackExchange::Processor::PostHistory.new

    processor.process("#{ENV['PATH']}/PostHistory.xml")
  end

  desc "Import Stack Exchange data"
  task :all, [:url] => :environment do |_, args|
    Rake::Task['stack_exchange:users'].invoke
    Rake::Task['stack_exchange:posts'].invoke
    Rake::Task['stack_exchange:comments'].invoke
    Rake::Task['stack_exchange:votes'].invoke
    Rake::Task['stack_exchange:post_history'].invoke
  end
end
