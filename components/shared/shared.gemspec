$:.push File.expand_path('../lib', __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'shared'
  # TODO(huna) dynamic version
  s.version     = '1.0'
  s.authors     = ['team naRuby', 'team AskEd']
  s.email       = ['askalot@fiit.stuba.sk']
  s.homepage    = 'http://askalot.fiit.stuba.sk'
  s.summary     = 'Shared functionality between Askalot versions'
  s.description = 'This engine contains code that is shared between various Askalot versions.'
  s.license     = 'MIT'

  s.files         = Dir['{app,config,lib}/**/*']
  s.test_files    = Dir['spec/**/*']
  s.require_paths = Dir['lib']

  # TODO(huna) list all dependencies
  s.add_dependency 'rails', '~> 4.2.0'
  s.add_dependency 'devise', '~> 3.5.0'

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
end
