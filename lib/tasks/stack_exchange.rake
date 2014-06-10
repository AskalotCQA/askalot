# Usage:
#
# rake stack_exchange:users
# rake stack_exchange:posts
# rake stack_exchange:comments
# rake stack_exchange:votes
# rake stack_exchange:all

namespace :stack_exchange do
  desc "Import Stack Exchange data"
  task :import, [:url] => :environment do |_, args|
    StackExchange.config.document.from = Time.parse(ENV['FROM']) if ENV['FROM']
    StackExchange.config.document.to   = Time.parse(ENV['TO']) if ENV['TO']

    processor = StackExchange::Processor::PostHistory.new
    processor.process("#{ENV['PATH']}/PostHistory.xml")
  end
end
