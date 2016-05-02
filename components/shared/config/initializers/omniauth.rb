OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ::Shared::Configuration.facebook.application.id, ::Shared::Configuration.facebook.application.secret, scope: 'public_profile,user_likes,user_friends', display: 'popup'
end

OmniAuth.config.on_failure = Proc.new do |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
end
