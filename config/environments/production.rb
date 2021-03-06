Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Enable Rack::Cache to put a simple HTTP cache in front of your application
  # Add `rack-cache` to your Gemfile before enabling this.
  # For large-scale production use, consider using a caching reverse proxy like nginx, varnish or squid.
  # config.action_dispatch.rack_cache = true

  # Disable Rails's static asset server (Apache or nginx will already do this).
  config.serve_static_assets = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Generate digests for assets URLs.
  config.assets.digest = true

  # `config.assets.precompile` and `config.assets.version` have moved to config/initializers/assets.rb
  config.assets.precompile += %w( application.js application.css )

  files = Dir[Rails.root.join('app', 'assets', 'javascripts', 'i18n', '*.js')]
  files.map! {|file| file.sub(%r(#{Rails.root}/app/assets/javascripts/), '') }
  config.assets.precompile += files

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Set to :debug to see everything in the log.
  config.log_level = :info

  # Prepend all log lines with the following tags.
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups.
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = "http://assets.example.com"

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Disable automatic flushing of the log to improve performance.
  # config.autoflush_log = false

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Redis
  config.cache_store = :redis_store, {
      host: ENV['REDIS_PRODUCTION_SERVER'],
      port: ENV['REDIS_PRODUCTION_PORT'],
      password: ENV['REDIS_PRODUCTION_PASS'],
      db: ENV['REDIS_PRODUCTION_DBNUM'],
      namespace: 'cache'
  }
  config.session_store :redis_store, {
      servers: {
          host: ENV['REDIS_PRODUCTION_SERVER'],
          port: ENV['REDIS_PRODUCTION_PORT'],
          password: ENV['REDIS_PRODUCTION_PASS'],
          db: ENV['REDIS_PRODUCTION_DBNUM'],
          namespace: 'session'
      },
      :expire_after => 1.month
  }

  # FIXME:
  #config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  # # passengerの場合
  # if defined?(PhusionPassenger)
  #   PhusionPassenger.on_event(:starting_worker_process) do |forked|
  #     Rails.cache.reset if forked
  #
  #     ObjectSpace.each_object(ActionDispatch::Session::DalliStore) { |obj| obj.reset }
  #   end
  # end
  #
  # # unicornの場合
  # after_fork do |server, worker|
  #   if defined?(ActiveSupport::Cache::DalliStore) && Rails.cache.is_a?(ActiveSupport::Cache::DalliStore)
  #     Rails.cache.reset
  #
  #     ObjectSpace.each_object(ActionDispatch::Session::DalliStore) { |obj| obj.reset }
  #   end
  # end

  # iframe許可
  config.action_dispatch.default_headers = {
      'X-Frame-Options' => 'ALLOWALL'
  }

  # Devise
  config.to_prepare do
    Devise::SessionsController.layout "user"
    Devise::RegistrationsController.layout "user"
    Devise::ConfirmationsController.layout "user"
    Devise::UnlocksController.layout "user"
    Devise::PasswordsController.layout "user"
  end

  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.action_mailer.raise_delivery_errors = false

end
