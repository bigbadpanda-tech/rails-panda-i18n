source "https://rubygems.org"

gemspec path: __dir__

group :development do
  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
  gem "rubocop-performance", require: false
end

group :test do
  gem "diffy"
  gem "equivalent-xml"
  gem "mocha"
end

group :ci do
  gem "danger"
end
