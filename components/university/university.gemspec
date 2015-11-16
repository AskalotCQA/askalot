$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
# require 'university/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'university'
  # TODO(huna) dynamic version
  s.version     = '1.0'
  s.authors     = ['FIIT STU']
  s.email       = ['askalot@fiit.stuba.sk']
  s.homepage    = 'http://askalot.fiit.stuba.sk'
  s.summary     = 'University version of Askalot'
  s.description = 'This version provides functionality for university domain.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'LICENSE.md', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']

  # TODO(huna) list all dependencies
  s.add_dependency 'rails', '4.1.0'
  s.add_dependency 'devise', '3.1.2'
end
