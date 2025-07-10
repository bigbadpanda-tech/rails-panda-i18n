$LOAD_PATH.push File.expand_path('lib', __dir__)

require "definerails_i18n/version"

Gem::Specification.new do |s|
  s.required_ruby_version = '>= 3.2'

  s.name        = "definerails_i18n"
  s.version     = DefineRails::Internationalization::VERSION
  s.authors     = [ "DefineScope" ]
  s.email       = [ "info@definescope.com" ]
  s.homepage    = "https://www.definescope.com"
  s.summary     = "Code that Rails applications use for dealing with internationalization (i18n)."
  s.description = "Code that Rails applications use for dealing with internationalization (i18n)."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile"]
  # s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"# , ">= 5.1.2"

  # Get the HTTP ACCEPT-LANGUAGE header
  s.add_dependency "http_accept_language"

  s.metadata["rubygems_mfa_required"] = "true"
end
