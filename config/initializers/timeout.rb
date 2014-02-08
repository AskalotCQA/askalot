# TODO (smolnar) consider decreasing the value
Rack::Timeout.timeout = 10 if Rails.env.production?
