source "https://rubygems.org"

ruby "3.1.4"

gem "rails", "~> 7.1.2"

gem "puma", ">= 5.0"
gem "sprockets-rails"
gem "sqlite3", "~> 1.4"
gem "bootsnap", require: false

gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"

gem "jbuilder"


gem 'wit'
gem "simple_form", "~> 5.1.0"
gem "ruby-openai"
gem "chronic"
gem 'dotenv-rails'

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem 'rspec-rails'

end

group :development do
  gem "web-console"
  gem "error_highlight", ">= 0.4.0", platforms: [:ruby]
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
