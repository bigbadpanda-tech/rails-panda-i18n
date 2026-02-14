$LOAD_PATH.push File.expand_path("lib", __dir__)

require "rails_panda_i18n/version"

Gem::Specification.new do |spec|
  spec.name = "rails-panda-i18n"
  spec.version = RailsPanda::I18n::VERSION
  spec.authors = ["João Saraiva"]
  spec.email = ["panda@bigbadpanda.com"]

  spec.summary = "Code that Rails applications use for dealing with internationalization (i18n)."
  spec.description = "Code that Rails applications use for dealing with internationalization (i18n)."
  spec.homepage = "https://github.com/bigbadpanda-tech/rails-panda-i18n"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2"

  spec.metadata["rubygems_mfa_required"] = "true"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/develop/CHANGELOG.md"

  spec.files = Dir[
    "lib/**/*",
    "rails_panda_i18n.gemspec",
    "Gemfile",
    # "Rakefile",
    "LICENSE",
    "CHANGELOG.md",
    "README.md"
  ]

  spec.add_dependency "rails", ">= 7.0.0"
  spec.add_dependency "http_accept_language" # Get the HTTP ACCEPT-LANGUAGE header

  # spec.add_development_dependency "combustion"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-rails"
  spec.add_development_dependency "rubocop-rspec"
  spec.add_development_dependency "rubocop-rspec_rails"
  spec.add_development_dependency "rubocop-rake"
  spec.add_development_dependency "rubocop-performance"
  spec.add_development_dependency "standard"
  spec.add_development_dependency "standard-rails"
end
