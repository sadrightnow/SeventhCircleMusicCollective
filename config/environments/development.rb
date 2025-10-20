require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is reloaded on every request in development, making it perfect for iterative coding.
  config.enable_reloading = true
  config.eager_load = false

  # Show full error reports in development.
  config.consider_all_requests_local = true

  # Server timing for performance tracking.
  config.server_timing = true

  # Caching configuration.
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true
    config.cache_store = :memory_store
    config.public_file_server.headers = { "Cache-Control" => "public, max-age=#{2.days.to_i}" }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  # Active Storage configuration for local development.
  config.active_storage.service = :local

  # Action Mailer configuration for sending emails.
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = { host: "localhost", port: 3000 }

  # Configure the mailer to use SMTP with Gmail for development (example setup).
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              "smtp.gmail.com",
    port:                 587,
    domain:               "localhost",
    user_name:            "donotreplyseventhcircle@gmail.com", # Replace with your email
    password:             "edru xmfs rgmy ulaw ",  # Replace with your email password or app password
    authentication:       "plain",
    enable_starttls_auto: true
  }



  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code triggering database queries in logs.
  config.active_record.verbose_query_logs = true

  # Highlight code that enqueued background jobs in logs.
  config.active_job.verbose_enqueue_logs = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Disable Action Mailer template caching, even if Action Controller caching is enabled.
  config.action_controller.perform_caching = false

  # Enable view annotations to show file names in rendered output.
  config.action_view.annotate_rendered_view_with_filenames = true

  # Raise an error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Raise error when before_action references invalid options.
  config.action_controller.raise_on_missing_callback_actions = true

  # Uncomment to allow Action Cable access from any origin.
  # config.action_cable.disable_request_forgery_protection = true
end
