OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '308609915963601', '9d4459184d7a61afec6d216eda49f69d', scope: 'email,read_stream,user_likes,user_friends', display: 'page'
end

OmniAuth.config.on_failure = Proc.new do |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
end