module Shared::Reputation
  module Adjuster
    extend self

    @manager = Shared::Reputation::Manager.new

    def tags_by_answers(last_update)
      affected_tags = Array.new

      Answer.unscoped.where('created_at >= ? OR deleted_at >= ?', last_update, last_update).each do |a|
        next if already_had_answers?(a.to_question, last_update) || a.to_question.mode != 'question'

        a.to_question.tags.each { |t| affected_tags << t if affected_tags.exclude?(t) }
      end

      affected_tags
    end

    def tags_by_votes(last_update)
      affected_tags = Array.new

      Vote.unscoped.where(votable_type: 'Question').where('updated_at >= ?', last_update).each do |v|
        next if v.to_question.mode != 'question'

        v.votable.tags.each { |t| affected_tags << t if affected_tags.exclude?(t) }
      end

      affected_tags
    end

    def tags_by_taggings(last_update)
      affected_tags = Array.new

      Tagging.unscoped.where('updated_at >= ?', last_update).each do |t|
        next unless t.created_at < t.updated_at || t.created_at > t.to_question.created_at
        next if t.to_question.mode != 'question'

        affected_tags << t.tag if affected_tags.exclude?(t.tag)
      end

      affected_tags
    end

    def changed_tags(tags)
      changed_tags = Array.new

      tags.each { |t| changed_tags << t if time_changed?(t) || score_changed?(t) }

      changed_tags
    end

    def update_reputation(changed_tags)
      question_ids = Array.new

      changed_tags.each { |t| update_tag_statistics(t) }
      changed_tags.each do |t|
        t.questions.all_answered.each do |q|
          next if question_ids.include?(q.id) || q.answers.empty?

          @manager.update_users(q)
          question_ids << q.id
        end
      end
    end

    def update_tag_statistics(tag)
      max_time  = nil
      min_score = tag.questions.all_answered.of_type('question').minimum(:votes_difference)
      max_score = tag.questions.all_answered.of_type('question').maximum(:votes_difference)

      tag.questions.all_answered.of_type('question').each do |q|
        time     = @manager.question_calculator.time(q, nil)
        max_time = time if max_time.nil? || time > max_time
      end

      tag.update(max_time: max_time, min_votes_difference: min_score, max_votes_difference: max_score)
    end

    private

    def score_changed?(tag)
      max_score = tag.questions.all_answered.of_type('question').maximum(:votes_difference)
      min_score = tag.questions.all_answered.of_type('question').minimum(:votes_difference)

      max_score != tag.max_votes_difference || min_score != tag.min_votes_difference
    end

    def time_changed?(tag)
      max_time = nil

      tag.questions.all_answered.of_type('question').each do |q|
        time     = @manager.question_calculator.time(q, nil)
        max_time = time if max_time.nil? || time > max_time
      end

      tag.max_time != max_time
    end

    def already_had_answers?(question, last_update)
      question.answers.any? && question.answers.first.created_at < last_update
    end
  end
end
