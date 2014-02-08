# Usage:
#
# rake import:stack_overflow:users
# rake import:stack_overflow:posts
# rake import:stack_overflow:comments
# rake import:stack_overflow:votes

namespace :import do
  namespace :stack_overflow do
    desc "Import Stack Overflow users"
    task :users, [:url] => :environment do |_, args|
      processor = StackOverflow::Processor::Users.new

      processor.process('data/android_dump/Users.xml')
    end

    desc "Import Stack Overflow posts"
    task :posts, [:url] => :environment do |_, args|
      processor = StackOverflow::Processor::Posts.new

      processor.process('data/android_dump/Posts.xml')
    end

    desc "Import Stack Overflow comments"
    task :comments, [:url] => :environment do |_, args|
      processor = StackOverflow::Processor::Comments.new

      processor.process('data/android_dump/Comments.xml')
    end

    desc "Import Stack Overflow votes"
    task :votes, [:url] => :environment do |_, args|
      processor = StackOverflow::Processor::Votes.new

      processor.process('data/android_dump/Votes.xml')
    end
  end
end



