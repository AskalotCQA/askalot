require 'ostruct'

module Slido::Questions
  class Parser
    def self.parse(json)
      data = JSON.parse(json, symbolize_names: true)

      data.map do |question|
        result = OpenStruct.new

        result.title    = question[:text]
        result.text     = question[:text]
        result.tag_list = :slido

        result
      end
    end
  end
end
