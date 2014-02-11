require 'slido/questions/parser'
require 'slido/wall/parser'
require 'slido/scraper'

# TODO (smolnar) use Squire, resolve why fails in stub_const
module Slido
  def self.base
    'https://www.sli.do'
  end
end
