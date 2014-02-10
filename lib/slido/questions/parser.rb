<<<<<<< HEAD
=======
require 'ostruct'

>>>>>>> Add Slido questions parser
module Slido
  module Questions
    class Parser
      def self.parse(json)
        data = JSON.parse(json, symbolize_names: true)

        data.map do |question|
          result = OpenStruct.new

<<<<<<< HEAD
          result.title            = question[:text]
          result.text             = question[:text]
          result.slido_event_uuid = question[:event_id].to_i
          result.slido_uuid       = question[:event_question_id].to_i
          result.tag_list         = :slido
=======
          result.title    = question[:text]
          result.text     = question[:text]
          result.tag_list = :slido
>>>>>>> Add Slido questions parser

          result
        end
      end
    end
  end
end
