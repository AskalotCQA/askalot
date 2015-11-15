require 'slido/questions/parser'
require 'slido/wall/parser'
require 'slido/scraper'

module Slido
  mattr_accessor :config

  self.config ||= University::Configuration.slido
end
