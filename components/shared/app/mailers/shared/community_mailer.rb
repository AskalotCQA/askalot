module Shared
class CommunityMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  default from: ::Shared::Configuration.mailer.alias

  helper Shared::ActivitiesHelper
  helper Shared::AnswersHelper
  helper Shared::ApplicationHelper
  helper Shared::BootstrapHelper
  helper Shared::CategoriesHelper
  helper Shared::CommentsHelper
  helper Shared::DeletablesHelper
  helper University::DocumentsHelper if Rails.module.university?
  helper Shared::FavoritesHelper
  helper Shared::FollowingsHelper
  helper University::GroupsHelper if Rails.module.university?
  helper Shared::LabelingsHelper
  helper Shared::NotificationsHelper
  helper Shared::QuestionsHelper
  helper Shared::ResourcesHelper
  helper Shared::TagsHelper
  helper Shared::TextHelper
  helper Shared::UsersHelper
  helper Shared::VotesHelper
  helper Shared::WatchingsHelper

  include Shared::MarkdownHelper

  layout 'shared/mailer'

  def community_emails(email, user)
    @user = user

    @content = email[:body]
    @content = render_markdown @content if email[:send_html_email]
    @content = @content.html_safe unless email[:send_html_email]

    mail(to: @user.email, subject: email[:subject], content_type: email[:send_html_email] ? 'text/html' : 'text/plain') do |format|
      format.html if email[:send_html_email]
      format.text unless email[:send_html_email]
    end
  end
end
end
