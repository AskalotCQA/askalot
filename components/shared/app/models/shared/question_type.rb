module Shared
  class QuestionType < ActiveRecord::Base

    has_many :questions

    self.table_name = 'question_types'

    MODES = [:question, :forum, :document]

    symbolize :mode, in: MODES

    scope :public_types, -> { where(mode: [:question, :forum]).order(:mode, :name) }
    scope :questions, -> { where(mode: :question) }
    scope :forums, -> { where(mode: :forum) }
  end
end
