module University
class UserMailer < ActionMailer::Base
  default from: ::Shared::Configuration.mailer.alias, css: 'shared/mailers/layout'

  helper Shared::ActivitiesHelper
  helper Shared::AnswersHelper
  helper Shared::ApplicationHelper
  helper Shared::BootstrapHelper
  helper Shared::CategoriesHelper
  helper Shared::CommentsHelper
  helper Shared::DeletablesHelper
  helper University::DocumentsHelper
  helper Shared::EvaluationsHelper
  helper Shared::FavoritesHelper
  helper Shared::FollowingsHelper
  helper University::GroupsHelper
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

  def notifications(user)
    @user          = user
    @from          = Shared::Notifications::Utility.notifications_since(user)
    @notifications = Shared::Notifications::Utility.unread_notifications(user)

    return if @notifications.empty?

    Shared::Notifications::Utility.update_delay(user)

    return unless Shared::Notifications::Utility.send_notification_email?(user)

    Shared::Notifications::Utility.update_last_notification_sent_at(user)

    mail to: @user.email, subject: t('user_mailer.subject'), content_type: 'text/html'
  end
end
end
