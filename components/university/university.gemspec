$:.push File.expand_path('../lib', __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'university'
  # TODO(huna) dynamic version
  s.version     = '1.0'
  s.authors     = ['team naRuby', 'team AskEd']
  s.email       = ['askalot@fiit.stuba.sk']
  s.homepage    = 'http://askalot.fiit.stuba.sk'
  s.summary     = 'University version of Askalot'
  s.description = 'This version provides functionality for university domain.'
  s.license     = 'MIT'

  s.files      = Dir['{app,config,lib,vendor}/**/*']
  s.test_files = Dir['spec/**/*']

  # TODO(huna) list all dependencies
  s.add_dependency 'rails', '~> 4.1.0'
end
