# TODO (smolnar) consider decreasing the value
Rails.application.config.middleware.insert_before Rack::Runtime, Rack::Timeout, service_timeout: 60 if Rails.env_type.production?
