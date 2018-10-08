require_relative 'boot'

require 'rails/all'
require "conekta"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Impact_mentality
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    Conekta.api_key = ENV['conekta_apikey_privada']
    Conekta.api_version = "2.0.0"
  end
end
