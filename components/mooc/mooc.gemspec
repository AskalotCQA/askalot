$:.push File.expand_path('../lib', __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'mooc'
  # TODO (huna) dynamic version
  s.version     = '1.0'
  s.authors     = ['team AskEd']
  s.email       = ['askalot@fiit.stuba.sk']
  s.homepage    = 'http://askalot.fiit.stuba.sk'
  s.summary     = 'MOOC version of Askalot'
  s.description = 'This version provides functionality for MOOC domain.'
  s.license     = 'MIT'

  s.files      = Dir['{app,config,lib,vendor}/**/*']
  s.test_files = Dir['spec/**/*']

  # TODO (gallay) list all dependencies
  s.add_dependency 'rails', '~> 4.2.0'
end
