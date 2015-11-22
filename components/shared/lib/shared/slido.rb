require 'shared/slido/questions/parser'
require 'shared/slido/wall/parser'
require 'shared/slido/scraper'

module Shared::Slido
  mattr_accessor :config

  self.config ||= Shared::Configuration.slido
end
