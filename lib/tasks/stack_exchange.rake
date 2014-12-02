# Usage:
#
# rake stack_exchange:import

namespace :stack_exchange do
  desc "Import Stack Exchange data"
  task import: :environment do
    StackExchange.config.document.from = Time.parse(ENV['FROM']) if ENV['FROM']
    StackExchange.config.document.to   = Time.parse(ENV['TO']) if ENV['TO']

    processor = StackExchange::Processor::Tags.new
    processor.process("#{ENV['PATH']}/Tags.xml")

    processor = StackExchange::Processor::Users.new
    processor.process("#{ENV['PATH']}/Users.xml")

    processor = StackExchange::Processor::Posts.new
    processor.process("#{ENV['PATH']}/Posts.xml")

    processor = StackExchange::Processor::Comments.new
    processor.process("#{ENV['PATH']}/Comments.xml")

    processor = StackExchange::Processor::Votes.new
    processor.process("#{ENV['PATH']}/Votes.xml")

    processor = StackExchange::Processor::PostHistory.new
    processor.process("#{ENV['PATH']}/PostHistory.xml")
  end
end
