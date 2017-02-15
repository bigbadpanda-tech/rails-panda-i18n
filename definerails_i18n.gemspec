$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'definerails_i18n/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'definerails_i18n'
  s.version     = DefineRails::Internationalization::VERSION
  s.authors     = ['DefineScope']
  s.email       = ['info@definescope.com']
  s.homepage    = 'http://www.definescope.com'
  s.summary     = 'Code that DefineScope\'s Rails applications usefor dealing with internationalization (i18n).'
  s.description = 'Code that DefineScope\'s Rails applications usefor dealing with internationalization (i18n).'
  s.license     = 'This code is the intellectual property of DefineScope.'

  s.files = Dir["{app,config,db,lib}/**/*", 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir["test/**/*"]

  #s.add_dependency 'rails', '>= 5.0.0.1'

  # Get the HTTP ACCEPT-LANGUAGE header
  s.add_dependency 'http_accept_language'

end
