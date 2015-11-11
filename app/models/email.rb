class Email < ActiveRecord::Base
  belongs_to :user

  validates :user,            presence: true
  validates :subject,         presence: true
  validates :body,            presence: true
  validates :send_html_email, presence: true
end
