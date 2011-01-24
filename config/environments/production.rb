Sms::Application.configure do
# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
#config.action_view.cache_template_loading            = true
#config.cache_store = :mem_cache_store, Memcached::Rails.new
# See everything in the log (default is :info)
# config.log_level = :debug

# Heroku requires we serve static assets
config.serve_static_assets = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Use a different cache store in production
# config.cache_store = :mem_cache_store
config.cache_store = :dalli_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# Enable threaded mode
# config.threadsafe!

# Enable locale fallbacks for I18n (makes lookups for any locale fall back to
# the I18n.default_locale when a translation can not be found)
config.i18n.fallbacks = true

# Send deprecation notices to registered listeners
config.active_support.deprecation = :notify
end