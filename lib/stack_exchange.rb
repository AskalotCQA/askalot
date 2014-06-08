require 'stack_exchange/processor'
require 'stack_exchange/document'
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
end

StackExchange.config do |config|
  config.document do |document|
    document.from = nil
    document.to   = nil
  end
end
