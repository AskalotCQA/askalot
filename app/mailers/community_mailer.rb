class CommunityMailer < ActionMailer::Base
  default from: ::Configuration.mailer.alias, css: 'mailers/layout'

  helper ActivitiesHelper
  helper AnswersHelper
  helper ApplicationHelper
  helper BootstrapHelper
  helper CategoriesHelper
  helper CommentsHelper
  helper DeletablesHelper
  helper DocumentsHelper
  helper FavoritesHelper
  helper GroupsHelper
  helper LabelingsHelper
  helper NotificationsHelper
  helper QuestionsHelper
  helper ResourcesHelper
  helper TagsHelper
  helper TextHelper
  helper UsersHelper
  helper VotesHelper
  helper WatchingsHelper

  layout 'mailer'

  def community_emails(body, subject, user, send_html_email=false)
    @user = user

    @content = body

    mail(to: @user.email, subject: subject, content_type: 'text/html') do |format|
      format.html if send_html_email
      format.text
    end
  end
end
