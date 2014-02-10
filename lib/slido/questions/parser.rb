module Slido::Questions
  class Parser
    def self.parse(json)
      data = JSON.parse(json, symbolize_names: true)

      data.map do |question|
        result = OpenStruct.new

        result.title            = question[:text]
        result.text             = question[:text]
        result.slido_event_uuid = question[:event_id].to_i
        result.slido_uuid       = question[:event_question_id].to_i
        result.tag_list         = :slido

        result
      end
    end
  end
end
