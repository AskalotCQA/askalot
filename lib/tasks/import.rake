# Usage:
#
# rake import:stack_overflow:users
# rake import:stack_overflow:posts
# rake import:stack_overflow:comments
# rake import:stack_overflow:votes

namespace :import do
  namespace :stack_exchange do
    desc "Import Stack Exchange users"
    task :users, [:url] => :environment do |_, args|
      processor = StackExchange::Processor::Users.new

      processor.process('data/android_dump/Users.xml')
    end

    desc "Import Stack Exchange posts"
    task :posts, [:url] => :environment do |_, args|
      processor = StackExchange::Processor::Posts.new

      processor.process('data/android_dump/Posts.xml')
    end

    desc "Import Stack Exchange comments"
    task :comments, [:url] => :environment do |_, args|
      processor = StackExchange::Processor::Comments.new

      processor.process('data/android_dump/Comments.xml')
    end

    desc "Import Stack Exchange votes"
    task :votes, [:url] => :environment do |_, args|
      processor = StackExchange::Processor::Votes.new

      processor.process('data/android_dump/Votes.xml')
    end

    desc "Import Stack Exchange votes"
    task :post_history, [:url] => :environment do |_, args|
      processor = StackExchange::Processor::PostHistory.new

      processor.process('data/android_dump/PostHistory.xml')
    end

    desc "Import Stack Exchange data"
    task :all, [:url] => :environment do |_, args|
      Rake::Task['import:stack_overflow:users'].invoke
      Rake::Task['import:stack_overflow:posts'].invoke
      Rake::Task['import:stack_overflow:comments'].invoke
      Rake::Task['import:stack_overflow:votes'].invoke
      Rake::Task['import:stack_overflow:post_history'].invoke
    end
  end
end



