require 'pygments'
require 'github/markdown'

require 'redcurtain/markdown'
require 'redcurtain/renderer/github'
require 'redcurtain/highlighter/pygments'

Redcurtain::Markdown.renderer    ||= Redcurtain::Renderer::GitHub
Redcurtain::Markdown.highlighter ||= Redcurtain::Highlighter::Pygments
