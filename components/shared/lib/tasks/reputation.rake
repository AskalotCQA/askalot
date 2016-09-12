namespace :reputation do
  desc 'Adjusts reputation by handling overflow'
  task adjust: :environment do
    yesterday     = DateTime.now.yesterday
    affected_tags = []

    affected_tags |= Shared::Reputation::Adjuster.tags_by_answers(yesterday)
    affected_tags |= Shared::Reputation::Adjuster.tags_by_votes(yesterday)
    affected_tags |= Shared::Reputation::Adjuster.tags_by_taggings(yesterday)

    changed_tags = Shared::Reputation::Adjuster.changed_tags(affected_tags.uniq)

    Shared::Reputation::Adjuster.update_reputation(changed_tags)
  end

  task recalculate: :environment do
    manager = Shared::Reputation::Manager.new

    ActiveRecord::Base.connection.execute('UPDATE user_profiles SET value = 0, probability = 0')

    Shared::Question.all_answered.each do |q|
      next if q.mode != 'question'

      manager.add_for_asker(q)
      q.answers.each { |a| manager.add_for_answerer(a) }
    end
  end
end
