module University
class UserMailer < ActionMailer::Base
  default from: ::Shared::Configuration.mailer.alias, css: 'university/mailers/layout'

  helper Shared::ActivitiesHelper
  helper Shared::AnswersHelper
  helper Shared::ApplicationHelper
  helper Shared::BootstrapHelper
  helper Shared::CategoriesHelper
  helper Shared::CommentsHelper
  helper Shared::DeletablesHelper
  helper Shared::DocumentsHelper
  helper Shared::FavoritesHelper
  helper Shared::GroupsHelper
  helper Shared::LabelingsHelper
  helper Shared::NotificationsHelper
  helper Shared::QuestionsHelper
  helper Shared::ResourcesHelper
  helper Shared::TagsHelper
  helper Shared::TextHelper
  helper Shared::UsersHelper
  helper Shared::VotesHelper
  helper Shared::WatchingsHelper

  layout 'university/mailer'

  def notifications(user, from:)
    @from = from
    @user = user
    @notifications = @user.notifications.where('created_at >= ?', @from)

    return if @notifications.empty?

    mail to: @user.email, subject: "[Askalot] Nové notifikácie", content_type: 'text/html'
  end
end
end
