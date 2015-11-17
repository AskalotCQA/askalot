module University
class CommunityMailer < ActionMailer::Base
  default from: ::University::Configuration.mailer.alias, css: 'university/mailers/layout'

  helper University::ActivitiesHelper
  helper University::AnswersHelper
  helper University::ApplicationHelper
  helper University::BootstrapHelper
  helper University::CategoriesHelper
  helper University::CommentsHelper
  helper University::DeletablesHelper
  helper University::DocumentsHelper
  helper University::FavoritesHelper
  helper University::GroupsHelper
  helper University::LabelingsHelper
  helper University::NotificationsHelper
  helper University::QuestionsHelper
  helper University::ResourcesHelper
  helper University::TagsHelper
  helper University::TextHelper
  helper University::UsersHelper
  helper University::VotesHelper
  helper University::WatchingsHelper

  include University::MarkdownHelper

  layout 'university/mailer'

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
