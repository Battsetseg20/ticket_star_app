# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.5"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.6"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Authentication and User Management
gem "devise"

# Ruby Code Style Enforcement
gem "rubocop", require: false

# HTML Slim Templates
gem "slim-rails"

# Date format
gem "date_validator"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
# gem "sassc-rails"

gem "cancan"
gem "flash"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "html2slim"
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

# group :test do
# Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
#  gem "capybara"
#  gem "selenium-webdriver"
#  gem "webdrivers"
# end

# Testing for development and style guide enforcement
group :development, :test do
  gem "capybara", "~> 2.7", ">= 2.7.1" # Integration testing tool for simulating user interactions with the application
  gem "codeclimate-test-reporter", require: false # Code coverage reporting tool for tracking test coverage
  gem "factory_bot_rails" # Fixture replacement for generating test data
  gem "faker" # Library for generating fake data
  gem "rspec-rails" # Testing framework for writing and executing tests
  gem "rubocop-capybara", require: false # RuboCop extension for Capybara-specific linting rules
  gem "rubocop-factory_bot", require: false # RuboCop extension for FactoryBot-specific linting rules
  gem "rubocop-rails", require: false # RuboCop extension for Rails-specific linting rules
  gem "rubocop-rspec", require: false # RuboCop extension for RSpec-specific linting rules
  gem "simplecov", require: false # Code coverage analysis tool
end

group :test do
  gem "database_cleaner" # Library for cleaning databases between test runs
  gem "fakeredis" # Mock Redis connection library for testing Redis interactions
  gem "rails-controller-testing" # Support for controller testing, including the `assert_template` method
  gem "shoulda-callback-matchers" # Matchers for testing model callbacks
  gem "shoulda-matchers" # Collection of matchers for testing common Rails functionality
end
