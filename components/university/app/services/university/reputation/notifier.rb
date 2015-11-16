module University::Reputation
  module Notifier
    extend self

    @manager = University::Reputation::Manager.new

    def publish(action, initiator, resource, options = {})
      return unless [University::Answer, University::Vote, University::Question, University::Tagging, University::Labeling].include?(resource.class)

      send resource.class.name.demodulize.downcase, resource, action
    end

    def answer(answer, action)
      method = "answer_#{action.to_s}"

      @manager.send method, answer if @manager.respond_to?(method)
    end

    def vote(vote, action)
      votable = vote.votable.reload

      return @manager.question_vote(votable) if votable.is_a?(University::Question) && votable.answers.present?

      @manager.answer_vote(votable) if votable.is_a? University::Answer
    end

    def question(question, action)
      return unless action == :delete

      @manager.question_delete(question)
    end

    def tagging(tagging, action)
      return if tagging.created_at - tagging.to_question.created_at < 3 && action == :create

      @manager.tagging(tagging)
    end

    def labeling(labeling, action)
      return unless labeling.label.value == :best

      @manager.labeling(labeling)
    end
  end
end
