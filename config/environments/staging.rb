# frozen_string_literal: true

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

  # Ensures that a master key has been made available in either ENV["RAILS_MASTER_KEY"]
  # or in config/master.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Compress JavaScripts and CSS.
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # `config.assets.precompile` and `config.assets.version` have moved to config/initializers/assets.rb

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :local

  # Mount Action Cable outside main process or domain
  # config.action_cable.mount_path = nil
  # config.action_cable.url = 'wss://example.com/cable'
  # config.action_cable.allowed_request_origins = [ 'http://example.com', /http:\/\/example.*/ ]

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :debug

  # Prepend all log lines with the following tags.
  config.log_tags = [:request_id]

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store
  Rails.application.configure do
    config.cache_store = :redis_cache_store, { url: ENV.fetch('REDIS_URL', nil) }
  end

  # Use a real queuing backend for Active Job (and separate queues per environment)
  # config.active_job.queue_adapter     = :resque
  # config.active_job.queue_name_prefix = "touchpoints_#{Rails.env}"
  config.active_job.queue_adapter = :sidekiq

  config.action_mailer.default_options = { reply_to: 'feedback-analytics@gsa.gov' }
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = [I18n.default_locale]

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Use a different logger for distributed setups.
  # require 'syslog/logger'
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')

  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger           = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # For Devise
  config.action_mailer.default_url_options = { host: ENV.fetch('TOUCHPOINTS_WEB_DOMAIN'), port: 443 }
  # TODO: For temporary redirect (March 2025)
  config.action_controller.default_url_options = { host: ENV.fetch('TOUCHPOINTS_WEB_DOMAIN'), port: 443 }

  # Prevent host header injection
  # Reference: https://github.com/ankane/secure_rails
  config.action_controller.asset_host = ENV.fetch('TOUCHPOINTS_WEB_DOMAIN')

  config.action_mailer.delivery_method = :ses_v2
  config.action_mailer.ses_v2_settings = {
    region: ENV.fetch("AWS_SES_REGION"),
    access_key_id: ENV.fetch("AWS_SES_ACCESS_KEY_ID", nil),
    secret_access_key: ENV.fetch("AWS_SES_SECRET_ACCESS_KEY", nil)
  }
  config.action_mailer.perform_deliveries = true

  config.active_record.encryption.primary_key = ENV.fetch("RAILS_ACTIVE_RECORD_PRIMARY_KEY")
  config.active_record.encryption.deterministic_key = ENV.fetch("RAILS_ACTIVE_RECORD_DETERMINISTIC_KEY")
  config.active_record.encryption.key_derivation_salt = ENV.fetch("RAILS_ACTIVE_RECORD_KEY_DERIVATION_SALT")
  config.active_record.encryption.support_unencrypted_data = true

  config.hosts = [
    ENV.fetch("TOUCHPOINTS_WEB_DOMAIN")
  ]
  if ENV["TOUCHPOINTS_WEB_DOMAIN2"].present?
    config.hosts << ENV.fetch("TOUCHPOINTS_WEB_DOMAIN2")
  end
end
