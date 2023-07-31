require_relative "boot"

require "rails/all"
require 'open-uri'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Load environment variables from .env file, only needed in local env because in production env, we set env variables in heroku
# ex: heroku config:set SENGRID_KEY=***********
unless Rails.env.production?
  require 'dotenv/load'
  Dotenv::Railtie.load
end

module TicketStarApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
   
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
