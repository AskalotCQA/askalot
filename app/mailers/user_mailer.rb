class UserMailer < ActionMailer::Base
  default from: ::Configuration.mailer.alias, css: 'mailers/layout'

  helper ActivitiesHelper
  helper AnswersHelper
  helper ApplicationHelper
  helper BootstrapHelper
  helper CategoriesHelper
  helper CommentsHelper
  helper DeletablesHelper
  helper DocumentsHelper
  helper EvaluationsHelper
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

  def notifications(user, from:)
    @from = from
    @user = user
    @notifications = @user.notifications.where('created_at >= ?', @from)

    return if @notifications.empty?

    mail to: @user.email, subject: "[Askalot] Nové notifikácie", content_type: 'text/html'
  end
end
