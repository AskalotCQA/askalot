# TODO (smolnar) consider decreasing the value
Rack::Timeout.timeout = 60 if Rails.env_type.production?
