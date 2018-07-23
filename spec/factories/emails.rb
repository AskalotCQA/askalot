FactoryBot.define do
  factory :email, class: Shared::Email do
    user nil
    subject "MyText"
    body "MyText"
    status false
    send_html_email false
  end

end
