require 'stack_exchange/mapper'
require 'stack_exchange/processor'
require 'stack_exchange/document'
require 'stack_exchange/processor/tags'
require 'stack_exchange/document/tags'
require 'stack_exchange/processor/posts'
require 'stack_exchange/document/posts'
require 'stack_exchange/processor/comments'
require 'stack_exchange/document/comments'
require 'stack_exchange/processor/users'
require 'stack_exchange/document/users'
require 'stack_exchange/processor/votes'
require 'stack_exchange/document/votes'
require 'stack_exchange/processor/post_history'
require 'stack_exchange/document/post_history'

module StackExchange
  include Squire

  def self.import_from(path)
    processor = StackExchange::Processor::Tags.new
    processor.process("#{path}/Tags.xml")

    processor = StackExchange::Processor::Users.new
    processor.process("#{path}/Users.xml")

    processor = StackExchange::Processor::Posts.new
    processor.process("#{path}/Posts.xml")

    processor = StackExchange::Processor::Comments.new
    processor.process("#{path}/Comments.xml")

    processor = StackExchange::Processor::Votes.new
    processor.process("#{path}/Votes.xml")

    processor = StackExchange::Processor::PostHistory.new
    processor.process("#{path}/PostHistory.xml")
  end
end

StackExchange.config do |config|
  config.document do |document|
    document.from = nil
    document.to   = nil
  end
end
