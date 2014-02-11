module Slido
  module Wall
    class Parser
      def self.parse(html)
        document = Nokogiri::HTML(html)
        result   = OpenStruct.new

        context = document.css('.wall-base #content script:first').text

        _, json = *context.match(/event:\s+(?<json>.*}),\s+cols:/)

        data = JSON.parse(json, symbolize_names: true)

        result.uuid        = data[:event_id].to_i
        result.identifier  = data[:hash]
        result.name        = data[:name]
        result.started_at  = Time.parse(data[:date_from])
        result.ended_at    = Time.parse(data[:date_to])
        result.url         = "#{Slido.base}/#{result.identifier}"

        result
      end
    end
  end
end
