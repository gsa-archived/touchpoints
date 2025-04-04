require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot for better performance and memory savings (ignored by Rake tasks).
  config.eager_load = true

  # Full error reports are disabled.
  config.consider_all_requests_local = false

  # Turn on fragment caching in view templates.
  config.action_controller.perform_caching = true

  # Do not fall back to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false
  # Cache assets for far-future expiry since they are all digest stamped.
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Assume all access to the app is happening through a SSL-terminating reverse proxy.
  config.assume_ssl = true

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # Skip http-to-https redirect for the default health check endpoint.
  # config.ssl_options = { redirect: { exclude: ->(request) { request.path == "/up" } } }

  # Log to STDOUT with the current request id as a default log tag.
  config.log_tags = [ :request_id ]
  config.logger   = ActiveSupport::TaggedLogging.logger(STDOUT)

  # Change to "debug" to log everything (including potentially personally-identifiable information!)
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Use a different cache store in production.
  Rails.application.configure do
    config.cache_store = :redis_cache_store, { url: ENV.fetch('REDIS_URL', nil) }
  end
  # Prevent health checks from clogging up the logs.
  config.silence_healthcheck_path = "/up"

  config.active_job.queue_adapter = :sidekiq
  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  config.action_mailer.default_options = { reply_to: 'feedback-analytics@gsa.gov' }
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  # Disable caching for Action Mailer templates even if Action Controller
  # caching is enabled.
  config.action_mailer.perform_caching = false
  # Replace the default in-process memory cache store with a durable alternative.
  # config.cache_store = :mem_cache_store

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Log disallowed deprecations.
  config.active_support.disallowed_deprecation = :log
  # Replace the default in-process and non-durable queuing backend for Active Job.
  # config.active_job.queue_adapter = :resque

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Set host to be used by links generated in mailer templates.
  config.action_mailer.default_url_options = { host: ENV.fetch('TOUCHPOINTS_WEB_DOMAIN'), port: 443 }
  # TODO: For temporary redirect (March 2025)
  config.action_controller.default_url_options = { host: ENV.fetch('TOUCHPOINTS_WEB_DOMAIN'), port: 443 }

  # Specify outgoing SMTP server. Remember to add smtp/* credentials via rails credentials:edit.
  # config.action_mailer.smtp_settings = {
  #   user_name: Rails.application.credentials.dig(:smtp, :user_name),
  #   password: Rails.application.credentials.dig(:smtp, :password),
  #   address: "smtp.example.com",
  #   port: 587,
  #   authentication: :plain
  # }

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

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
  # Only use :id for inspections in production.
  config.active_record.attributes_for_inspect = [:id]

  # Enable DNS rebinding protection and other `Host` header attacks.
  config.hosts = [
    ENV.fetch("TOUCHPOINTS_WEB_DOMAIN")
  ]
  if ENV["TOUCHPOINTS_WEB_DOMAIN2"].present?
    config.hosts << ENV.fetch("TOUCHPOINTS_WEB_DOMAIN2")
  end
  # Skip DNS rebinding protection for the default health check endpoint.
  # config.host_authorization = { exclude: ->(request) { request.path == "/up" } }
end
