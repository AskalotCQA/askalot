module Shared::Reputation
  module Notifier
    extend self

    @manager = Shared::Reputation::Manager.new

    def publish(action, initiator, resource, options = {})
      return unless [Shared::Answer, Shared::Vote, Shared::Question, Shared::Tagging, Shared::Labeling].include?(resource.class)
      return if resource.to_question.mode != 'question' && action != :update

      send resource.class.name.demodulize.downcase, resource, action
    end

    def answer(answer, action)
      method = "answer_#{action.to_s}"

      @manager.send method, answer if @manager.respond_to?(method)
    end

    def vote(vote, action)
      votable = vote.votable.reload

      return @manager.question_vote(votable) if votable.is_a?(Shared::Question) && votable.answers.present?

      @manager.answer_vote(votable) if votable.is_a? Shared::Answer
    end

    def question(question, action)
      @manager.question_delete(question) if action == :delete
      @manager.question_update(question) if action == :update
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
