module Shared
  class QuestionType < ActiveRecord::Base

    has_many :questions

    self.table_name = 'question_types'

    MODES = [:question, :forum, :document]

    symbolize :mode, in: MODE

  end
end
