unless [:development, :test].include?(Rails.env_type.to_sym)
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    address:              'smtp.mandrillapp.com',
    port:                 587,
    enable_starttls_auto: true,
    user_name:            Shared::Configuration.mailer.username,
    password:             Shared::Configuration.mailer.password,
    authentication:       'login',
    domain:               'askalot.fiit.stuba.sk'
  }
end
