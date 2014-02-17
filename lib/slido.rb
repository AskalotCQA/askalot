require 'slido/questions/parser'
require 'slido/wall/parser'
require 'slido/scraper'

module Slido
  include Squire

  config do |config|
    config.base = 'https://www.sli.do'
  end
end
