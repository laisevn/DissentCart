require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DissentCart
  class Application < Rails::Application
    config.load_defaults 8.0

    config.autoload_lib(ignore: %w[assets tasks])

    config.api_only = true

    # load not default directories
    config.autoload_paths << Rails.root.join('app/use_cases')
    # config.autoload_paths << Rails.root.join('app/validators')
    # config.autoload_paths << Rails.root.join('app/exceptions')

    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore, key: '_dissent_cart_session'

    config.cache_store = :redis_cache_store, { url: ENV.fetch('REDIS_URL') { 'redis://localhost:6379/0' } }
  end
end
