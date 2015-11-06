FactoryGirl.define do
  factory :email do
    user nil
subject "MyText"
body "MyText"
status false
send_html_email false
  end

end
