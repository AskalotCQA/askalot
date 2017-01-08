module Shared::QuestionRouting
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
        `python scripts/python/UpdateUserProfile.py #{resource.id} >> recommendation/update-profile.log 2>&1`
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
  user = answer.author
  update_feature(user, 'AnswersCount')

  week_category = answer.question.category.parent.parent
  update_feature_with_targetable(user, week_category, 'AnswersCountCategory')

  topic_category = answer.question.category.parent
  update_feature_with_targetable(user, topic_category, 'AnswersCountCategory')
end

def update_comment_features(comment)
  update_feature(comment.author, 'CommentsCount')
end

def update_question_features(question)
  update_feature(question.author, 'QuestionCount')
end

def update_vote_features(vote)
  if vote.votable is_a? Shared::Question
    if vote.positive
      update_feature(vote.votable.author, 'QuestionVotesCount')
    else
      if Shared::User::Profile.exists? ({user: vote.votable.author, targetable_id: -1, targetable_type: 'QuestionVotesCount', property: 'QuestionVotesCount'})
        Shared::User::Profile.where(user: vote.votable.author, targetable_id: -1, targetable_type: 'QuestionVotesCount',
                                    property: 'QuestionVotesCount').first.decrement!(:value)
      else
        Shared::User::Profile.create(user: vote.votable.author, targetable_id: -1, targetable_type: 'QuestionVotesCount',
                                     property: 'QuestionVotesCount', value: -1)
      end
    end
  end
  if vote.votable is_a? Shared::Answer
    if vote.positive
      update_feature(vote.votable.author, 'AnswersVotesCount')
    else
      if Shared::User::Profile.exists? ({user: vote.votable.author, targetable_id: -1, targetable_type: 'AnswersVotesCount', property: 'AnswersVotesCount'})
        Shared::User::Profile.where(user: vote.votable.author, targetable_id: -1, targetable_type: 'AnswersVotesCount',
                                    property: 'AnswersVotesCount').first.decrement!(:value)
      else
        Shared::User::Profile.create(user: vote.votable.author, targetable_id: -1, targetable_type: 'AnswersVotesCount',
                                     property: 'AnswersVotesCount', value: -1)
      end
    end
  end

  voted_for_user = vote.votable.author
  category = vote.votable.to_question.category

  week_category = category.parent.parent
  unless week_category.nil?
    update_feature_with_targetable(voted_for_user, week_category, 'VotesCountCategory')
  end

  topic_category = category.parent
  unless topic_category.nil?
    update_feature_with_targetable(voted_for_user, topic_category, 'VotesCountCategory')
  end
end

def add_user_knowledge(user)
  update_feature(user, 'Knowledge')
end

def update_last_answer_time(user)
  update_feature_time(user, 'LastAnswerTime')
end

def update_seen_units(list)
  category = list.category
  user = list.lister
  if user.lists_count > 0 && !category.nil? && category.depth == 3
    update_feature_with_targetable_and_time(user, category, 'FreshUnitTime')
  end
end

def update_questions_in_category(view)
  category = view.question.category
  user = view.viewer

  if !category.nil? && category.depth == 3
    topic_category = category.parent
    week_category = topic_category.parent
    update_feature_with_targetable(user, topic_category, 'CategorySeenQuestions')
    update_feature_with_targetable(user, week_category, 'CategorySeenQuestions')
  end
end

def user_created(user)
  update_feature_time(user, 'RegistrationDate')
end

def update_seen_units_in_category(list)
  category = list.category
  user = list.lister

  if !category.nil? && category.depth == 3
    topic_category = category.parent
    week_category = topic_category.parent
    update_feature_with_targetable(user, week_category, 'SeenUnits')
    update_feature_with_targetable(user, topic_category, 'SeenUnits')
  end
end




# Helpers
def update_feature(user, property)
  if Shared::User::Profile.exists? ({user: user, targetable_id: -1, targetable_type: property, property: property})
    Shared::User::Profile.where(user: user, targetable_id: -1, targetable_type: property,
                                property: property).first.increment!(:value)
  else
    Shared::User::Profile.create(user: user, targetable_id: -1, targetable_type: property,
                                 property: property, value: 1)
  end
end

def update_feature_time(user, property)
  if Shared::User::Profile.exists? ({user: user, targetable_id: -1, targetable_type: property, property: property})
    Shared::User::Profile.where(user: user, targetable_id: -1, targetable_type: property,
                                property: property).first.touch
  else
    Shared::User::Profile.create(user: user, targetable_id: -1, targetable_type: property,
                                 property: property, updated_at: Time.now)
  end
end

def update_feature_with_targetable(user, targetable, property)
  if Shared::User::Profile.exists? ({user: user, targetable: targetable, property: property})
    Shared::User::Profile.where(user: user,
                                targetable: targetable,
                                property: property).first.increment!(:value)
  else
    Shared::User::Profile.create(user: user,
                                 targetable: targetable,
                                 property: property, value: 1)
  end
end

def update_feature_with_targetable_and_time(user, targetable, property)
  if Shared::User::Profile.exists? ({user: user, targetable: targetable, property: property})
    Shared::User::Profile.where(user: user,
                                targetable: targetable,
                                property: property).first.touch
  else
    Shared::User::Profile.create(user: user,
                                 targetable: targetable,
                                 property: property, updated_at: Time.now)
  end
end