require 'gemoji'
require 'github/markdown'
require 'nokogiri'
require 'pygments'

require 'redcurtain/markdown'
require 'redcurtain/renderer/gemoji'
require 'redcurtain/renderer/github'
require 'redcurtain/renderer/pygments'

Redcurtain::Markdown.setup!
