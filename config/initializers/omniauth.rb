OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '308609915963601' , '2c38cdee881763cedffe006d86a73c39' , :scope => 'email,user_birthday,read_stream,user_likes', :display => 'page'
end