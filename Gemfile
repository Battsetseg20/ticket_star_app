source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.5"

# Core
gem "rails", "~> 7.0.6" # The web-application framework that includes everything needed to create database-backed web applications
gem "pg", "~> 1.1" # PostgreSQL database driver
gem "puma", "~> 5.0" # A modern, concurrent web server for Ruby
gem 'active_storage_validations' # ActiveStorage validations
gem 'mini_magick', '>= 4.9.5' # Manipulate images with minimal use of memory via ImageMagick / GraphicsMagick

# Frontend
gem "sprockets-rails" # Asset pipeline for Rails
gem "importmap-rails" # Use JavaScript with ESM import maps
gem "turbo-rails" # Hotwire's SPA-like page accelerator
gem 'jquery-rails' # jQuery JavaScript library
gem "stimulus-rails" # Hotwire's modest JavaScript framework
gem "jbuilder" # Build JSON APIs with ease
gem "slim-rails" # HTML Slim Templates
gem 'bootstrap' # Bootstrap CSS framework
gem 'sass-rails' # Sass adapter for the Rails asset pipeline
gem 'font-awesome-rails' # Font Awesome CSS framework

# Authentication and User Management
gem "devise" # Flexible authentication solution for Rails
gem "cancan" # Authorization Gem for Ruby on Rails

# Mail
gem 'sendgrid-ruby', '~> 5.0' # SendGrid API client for Ruby
gem 'letter_opener' # Preview mail in the browser instead of sending, only in development

# PDF and QR code generation
gem 'prawn' # Fast, Nimble PDF Writer for Ruby
gem 'prawn-table' # Table support for Prawn PDFs
gem 'rqrcode' # Library to encode QR codes

# Stripe Payment Processing
gem 'stripe' # Stripe Ruby bindings

# Others
gem "date_validator" # Date validation for ActiveRecord
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby] # Timezone data
gem "bootsnap", require: false # Speed up boot time by caching expensive operations
gem 'flash' # Easier flash messages
gem "rubocop", require: false # Ruby static code analyzer and formatter
gem 'open-uri' # OpenURI is an easy-to-use wrapper for Net::HTTP, Net::HTTPS and Net::FTP

group :development, :test do
  # Debugging
  gem "debug", platforms: %i[mri mingw x64_mingw] # Debugging tools

  # Code Quality and Test Coverage
  gem "rubocop-rails", require: false # RuboCop extension for Rails-specific linting rules
  gem "rubocop-rspec", require: false # RuboCop extension for RSpec-specific linting rules
  gem "rubocop-capybara", require: false # RuboCop extension for Capybara-specific linting rules
  gem "rubocop-factory_bot", require: false # RuboCop extension for FactoryBot-specific linting rules
  gem "simplecov", require: false # Code coverage analysis tool
  gem "codeclimate-test-reporter", require: false # Code coverage reporting tool for tracking test coverage

  # Testing
  gem "rspec-rails" # Testing framework for writing and executing tests
  gem "factory_bot_rails" # Fixture replacement for generating test data
  gem "faker" # Library for generating fake data including images
  gem "capybara", "~> 2.7", ">= 2.7.1" # Integration testing tool for simulating user interactions with the application
  gem 'dotenv-rails' # Environment variable loader

  # Development Tools
  gem "html2slim" # HTML to Slim converter
  gem "web-console" # Rails console on the browser
end

group :test do
  gem "database_cleaner" # Library for cleaning databases between test runs
  gem "fakeredis" # Mock Redis connection library for testing Redis interactions
  gem "rails-controller-testing" # Support for controller testing, including the `assert_template` method
  gem "shoulda-callback-matchers" # Matchers for testing model callbacks
  gem "shoulda-matchers" # Collection of matchers for testing common Rails functionality
end

gem "cssbundling-rails", "~> 1.2"
