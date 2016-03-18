require 'shared/stack_exchange/mapper'
require 'shared/stack_exchange/processor'
require 'shared/stack_exchange/document'
require 'shared/stack_exchange/processor/tags'
require 'shared/stack_exchange/document/tags'
require 'shared/stack_exchange/processor/posts'
require 'shared/stack_exchange/document/posts'
require 'shared/stack_exchange/processor/comments'
require 'shared/stack_exchange/document/comments'
require 'shared/stack_exchange/processor/users'
require 'shared/stack_exchange/document/users'
require 'shared/stack_exchange/processor/votes'
require 'shared/stack_exchange/document/votes'
require 'shared/stack_exchange/processor/post_history'
require 'shared/stack_exchange/document/post_history'

module Shared::StackExchange
  include Squire

  def self.import_from(path)
    processor = Shared::StackExchange::Processor::Tags.new
    processor.process("#{path}/Tags.xml")

    processor = Shared::StackExchange::Processor::Users.new
    processor.process("#{path}/Users.xml")

    processor = Shared::StackExchange::Processor::Posts.new
    processor.process("#{path}/Posts.xml")

    processor = Shared::StackExchange::Processor::Comments.new
    processor.process("#{path}/Comments.xml")

    processor = Shared::StackExchange::Processor::Votes.new
    processor.process("#{path}/Votes.xml")

    processor = Shared::StackExchange::Processor::PostHistory.new
    processor.process("#{path}/PostHistory.xml")
  end
end

Shared::StackExchange.config do |config|
  config.document do |document|
    document.from = nil
    document.to   = nil
  end
end
