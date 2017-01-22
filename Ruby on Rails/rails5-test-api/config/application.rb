require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rails5TestApi
  class Application < Rails::Application
    config.logger = Logger.new(STDOUT)
    config.log_level = :info
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.generators do |g|
      g.test_framework  :rspec,
                        view_specs: false,
                        helper_specs: false,
                        routing_specs: false,
                        controller_specs: false
    end

    config.cache_store = :redis_store, "redis://redis:6379/0/cache", { expires_in: 90.minutes }
    config.middleware.use Rack::Attack
    config.middleware.use Rack::Protection, except: [:remote_token, :session_hijacking]

    config.after_initialize do
      if Rails.env.development? || Rails.env.test?
        Bullet.enable = true
        Bullet.raise = true
      end
    end

    config.active_record.default_timezone = :utc
    config.time_zone = 'UTC'
    config.active_record.lock_optimistically = true

    config.action_dispatch.rescue_responses["Pundit::NotAuthorizedError"] = :forbidden
  end
end
