require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TankBackend
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'http://localhost:3000'
        resource '/api/signup',
          methods: [:post],
          headers: :any,
          credentials: true
        resource '/api/login',
          methods: [:post],
          headers: :any,
          credentials: true
        resource '/api/users',
          methods: [:get],
          headers: :any,
          credentials: true
        resource '/api/handshake',
          methods: [:get],
          headers: :any,
          credentials: true
        resource '/api/username-check',
          methods: [:post],
          headers: :any,
          credentials: true
        resource '/api/authenticate',
          methods: [:get],
          headers: :any,
          credentials: true
        resource '/api/users/current-user/games/tank_games',
          methods: [:get, :post],
          headers: :any,
          credentials: true
        resource '/api/users/current-user/games/tank_games/*',
          methods: [:get, :post, :patch],
          headers: :any,
          credentials: true
        resource '/api/logout',
          methods: [:delete],
          headers: :any,
          credentials: true
        resource '*', headers: :any, methods: [:get, :options]
      end
    end


    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
