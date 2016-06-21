module Shared::Reputation
  class Manager
    attr_reader :question_calculator
    attr_reader :answer_calculator

    def initialize
      @question_calculator = Shared::Reputation::QuestionCalculator.new
      @answer_calculator   = Shared::Reputation::AnswerCalculator.new
    end

    def question_vote(question)
      remove_and_add_for_asker(question)
    end

    def answer_vote(answer)
      data = get_data(answer.to_question)

      remove_and_add_for_answerer(answer, data)

      return if data[:min_score] != answer.votes_difference && data[:max_score] != answer.votes_difference

      answer.to_question.answers.where.not(id: answer).each { |a| remove_and_add_for_answerer(a, data) }
    end

    def answer_create(answer)
      add_for_answerer(answer)
      add_for_asker(answer.to_question) if answer.to_question.answers.count == 1
    end

    def answer_delete(answer)
      question = answer.to_question
      data     = get_data(answer.to_question)
      old_time = @question_calculator.time(question, answer)

      update_reputation(answer.author, answer.reputation.value, :remove)
      update_reputation(question.author, question.reputation.value, :remove) if data[:time].nil? || data[:time] > old_time

      return unless data[:time].nil? || data[:time] > old_time

      question.answers.each { |a| remove_and_add_for_answerer(a, data) }
      add_for_asker(question, data[:time])
    end

    def question_delete(question)
      time       = @question_calculator.time(question, nil)
      reputation = @question_calculator.reputation(question, time, question.votes_difference)

      update_reputation(question.author, reputation, :remove)

      return if question.answers.nil?

      question.answers.each { |a| update_reputation(a.author, a.reputation.value, :remove) }
    end

    def question_update(question)
      return if question.answers.empty?

      revision   = question.revisions.last

      return if revision.question_type == question.mode

      time       = @question_calculator.time(question, nil)
      reputation = @question_calculator.reputation(question, time, question.votes_difference)

      if question.mode != 'question' && revision.question_type == 'question'
        puts 'was question'
        update_reputation(question.author, reputation, :remove)
        question.answers.each { |a| update_reputation(a.author, a.reputation.value, :remove) }
      elsif question.mode == 'question'
        update_reputation(question.author, reputation, :add)
        question.answers.each { |a| add_for_answerer(a) }
      end
    end

    def tagging(tagging)
      question = tagging.to_question.reload

      return if question.answers.count == 0

      remove_and_add_for_asker(question)

      data = get_data(question)

      question.answers.each { |a| remove_and_add_for_answerer(a, data) }
    end

    def labeling(labeling)
      answer = labeling.answer
      data   = get_data(answer.to_question)

      remove_and_add_for_answerer(answer, data)
    end

    def update_reputation(user, reputation, action)
      return if reputation.nil?

      profile             = user.profiles.of('reputation').first
      profile.value       += action == :add ? reputation : -reputation
      profile.probability += action == :add ? 1 : -1

      profile.save
    end

    def add_for_asker(question, time = nil)
      time       = @question_calculator.time(question, nil) if time.nil?
      reputation = @question_calculator.reputation(question, time, question.votes_difference)

      update_reputation(question.author, reputation, :add)
      question.reputation.update(value: reputation, probability: 1)
    end

    def add_for_answerer(answer)
      data       = get_data(answer.to_question)
      reputation = @answer_calculator.reputation(answer, data[:difficulty], data[:min_score], data[:max_score])

      update_reputation(answer.author, reputation, :add)
      answer.reputation.update(value: reputation, probability: 1)
    end

    def update_users(question)
      data = get_data(question)

      remove_and_add_for_asker(question)
      question.answers.each { |a| remove_and_add_for_answerer(a, data) }
    end

    private

    def get_data(question)
      data              = {}
      data[:time]       = @question_calculator.time(question, nil)
      data[:difficulty] = @question_calculator.difficulty(question, data[:time])
      data[:min_score]  = question.answers.minimum(:votes_difference)
      data[:max_score]  = question.answers.maximum(:votes_difference)

      data
    end

    def remove_and_add_for_answerer(answer, d)
      old_reputation = answer.reputation.value
      new_reputation = @answer_calculator.reputation(answer, d[:difficulty], d[:min_score], d[:max_score])

      update_reputation(answer.author, old_reputation, :remove) if answer.reputation.probability == 1
      update_reputation(answer.author, new_reputation, :add)

      answer.reputation.update(value: new_reputation, probability: 1)
    end

    def remove_and_add_for_asker(question)
      old_reputation = question.reputation.value
      question_time  = @question_calculator.time(question, nil)
      new_reputation = @question_calculator.reputation(question, question_time, question.votes_difference)

      update_reputation(question.author, old_reputation, :remove) if question.reputation.probability == 1
      update_reputation(question.author, new_reputation, :add)

      question.reputation.update(value: new_reputation, probability: 1)
    end
  end
end
