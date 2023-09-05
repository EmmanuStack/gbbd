# frozen_string_literal: true
#new gem file updated dsfdgfdgdfd
source "https://rubygems.org/"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
gem "rails", "~> 7.2.6"
gem "active_storage_validations"
gem "bcrypt"
gem "bootsnap", require: true
gem "image_processing"

gem "inline_svg"

gem "puma"

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem "webpacker"

gem "will_paginate-bootstrap-style"
gem "will_paginate"

# Use Redis adaptsadsaer to run Actionn Cable in production
# gem 'redis', '~> 5.0'
# Build JSON APIss with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "factory_bot_rails"
  gem "faker"
  gem "net-smtp", require: false
  gem "rspec_junit_formatter"
  gem "rspec-rails", "~> "3.8.7"

  gem "selenium-webdriver"
  gem "simplecov", require: false
end
gem "pg"
gem "mysql2"
group :development do
  gem "bullet"
  gem "listen"
  gem "rack-mini-profiler"
  gem "web-console"
end

group :rubocop do
  gem "rubocop-rails_config"
  gem "rubocop"
end

gem 'brakeman', '~> 3.3', '>= 3.3.2'
