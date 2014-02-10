require 'ostruct'

module Slido::Wall
  class Parser
    def self.parse(html)
      document = Nokogiri::HTML(html)
      result   = OpenStruct.new

      context = document.css('.wall-base #content script:first').text

      _, json = *context.match(/event:\s+(?<json>.*}),\s+cols:/)

      data = JSON.parse(json, symbolize_names: true)

      result.name      = data[:name]
      result.starts_at = Time.parse(data[:date_from])
      result.ends_at   = Time.parse(data[:date_to])

      result
    end
  end
end
