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

  def community_emails(email, user)
    @user = user

    @content = email[:body].html_safe

    mail(to: @user.email, subject: email[:subject], content_type: email[:send_html_email] ? 'text/html' : 'text/plain') do |format|
      format.html if email[:send_html_email]
      format.text
    end
  end
end
