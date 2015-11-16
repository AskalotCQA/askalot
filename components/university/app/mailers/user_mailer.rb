class UserMailer < ActionMailer::Base
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

  layout 'university/mailer'

  def notifications(user, from:)
    @from = from
    @user = user
    @notifications = @user.notifications.where('created_at >= ?', @from)

    return if @notifications.empty?

    mail to: @user.email, subject: "[Askalot] Nové notifikácie", content_type: 'text/html'
  end
end
