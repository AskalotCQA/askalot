module Shared::Yeast
  module FeaturesWeightsUpdater
    extend self

    def publish(action, initiator, resource, options = {})
      #puts "Feeding for #{action} '#{action}' on #{resource} by #{initiator.try(:nick) || 'no one'} ..."

      # Only for development
      #@current_date ||= resource.created_at.to_date
      #if action == :create && resource.created_at.to_date != @current_date
      #  @current_date = resource.created_at.to_date
      #  Rake::Task['recommendation:update_features'].invoke
      #  Rake::Task['recommendation:update_features'].reenable
      #  Rake::Task['recommendation:append_expertise_dataset'].invoke
      #  Rake::Task['recommendation:append_expertise_dataset'].reenable
      #  Rake::Task['recommendation:append_willingness_dataset'].invoke
      #  Rake::Task['recommendation:append_willingness_dataset'].reenable
      #  #Rake::Task['recommendation:train'].invoke
      #  #Rake::Task['recommendation:train'].reenable
      #end
      # Only for development

      if resource.is_a? Shared::Answer
        update_answer_features(resource)
        add_user_knowledge(resource.author)
        update_last_answer_time(resource.author)
        `python scripts/python/UpdateUserProfile.py #{resource.id}`
      end

      if resource.is_a? Shared::Comment
        update_comment_features(resource)
        add_user_knowledge(resource.author)
      end

      if resource.is_a? Shared::Vote
        update_vote_features(resource)
        add_user_knowledge(resource.votable.author)
      end

      if resource.is_a? Shared::Question
        update_question_features(resource)
      end

      if resource.is_a? Shared::List
        update_seen_units(resource)
        update_seen_units_in_category(resource)
      end

      if resource.is_a? Shared::View
        update_questions_in_category(resource)
      end

      if resource.is_a? Shared::User
        user_created(resource)
      end
    end
  end
end


def update_answer_features(answer)
  answers_count = answer.author.profiles.get_feature('AnswersCount')
  answers_count.value = answers_count.value.to_i + 1

  answers_count.save

  user = answer.author
  week_category = answer.question.category.parent.parent
  Shared::User::Profile.of('AnswersCountCategory').where(user: user,
                                                       targetable: week_category,
                                                       property: 'AnswersCountCategory')
      .first_or_create.increment!(:value)

  topic_category = answer.question.category.parent
  Shared::User::Profile.of('AnswersCountCategory').where(user: user,
                                                        targetable: topic_category,
                                                        property: 'AnswersCountCategory')
                              .first_or_create.increment!(:value)
end

def update_comment_features(comment)
  comment.author.profiles.get_feature('CommentsCount').increment!(:value)
end

def update_question_features(question)
  question.author.profiles.get_feature('QuestionCount').increment!(:value)
end

def update_vote_features(vote)
  if vote.votable is_a? Shared::Question
    if vote.positive
      vote.votable.author.profiles.get_feature('QuestionVotesCount').increment!(:value)
    else
      vote.votable.author.profiles.get_feature('QuestionVotesCount').decrement!(:value)
    end
  end
  if vote.votable is_a? Shared::Answer
    if vote.positive
      vote.votable.author.profiles.get_feature('AnswersVotesCount').increment!(:value)
    else
      vote.votable.author.profiles.get_feature('AnswersVotesCount').decrement!(:value)
    end
  end

  voted_for_user = vote.votable.author
  category = vote.votable.try(:category) || vote.votable.question.category

  week_category = category.parent.parent
  Shared::User::Profile.of('VotesCountCategory').where(user: voted_for_user,
                                                     targetable: week_category,
                                                     property: 'VotesCountCategory')
      .first_or_create.increment!(:value)

  topic_category = category.parent
  Shared::User::Profile.of('VotesCountCategory').where(user: voted_for_user,
                                                     targetable: topic_category,
                                                     property: 'VotesCountCategory')
      .first_or_create.increment!(:value)
end

def add_user_knowledge(user)
  knowledge = user.profiles.get_feature('Knowledge').increment!(:value)
end

def update_last_answer_time(user)
  user.profiles.get_feature('LastAnswerTime').touch
end

def update_seen_units(list)
  category = list.category
  user = list.lister
  if user.views_count > 0
    Shared::User::Profile.of('FreshUnitTime').where(user: user,
                                                  targetable: category,
                                                  property: 'FreshUnitTime').first_or_create.touch
  end
end

def update_questions_in_category(view)
  topic_category = view.question.category.parent
  week_category = view.question.category.parent.parent

  user = view.viewer

  Shared::User::Profile.of('CategorySeenQuestions').where(user: user,
                                                         targetable: topic_category,
                                                         property: 'CategorySeenQuestions')
      .first_or_create.increment!(:value)
#      .first_or_create.update(value: @manager.seen_questions_in_category(topic_category, user))


  Shared::User::Profile.of('CategorySeenQuestions').where(user: user,
                                                        targetable: week_category,
                                                        property: 'CategorySeenQuestions')
      .first_or_create.increment!(:value)
#      .first_or_create.update(value: @manager.seen_questions_in_category(week_category, user))
end

def user_created(user)
  user.profiles.get_feature('RegistrationDate').touch
end

def update_seen_units_in_category(list)
  category = list.category
  user = list.lister

  if category.depth == 3
    topic_category = category.parent
    week_category = topic_category.parent
    Shared::User::Profile.of('SeenUnits').where(user: user,
                                                targetable: week_category,
                                                property: 'SeenUnits')
        .first_or_create.increment!(:value)
    Shared::User::Profile.of('SeenUnits').where(user: user,
                                                targetable: topic_category,
                                                property: 'SeenUnits')
        .first_or_create.increment!(:value)
  end
end
