OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ::Configuration.facebook.application.id, ::Configuration.facebook.application.secret, scope: 'email,read_stream,user_likes,user_friends', display: 'page'
end

OmniAuth.config.on_failure = Proc.new do |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
end
