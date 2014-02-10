module Slido
  class Scraper
    def self.run(username, options = {})
      uri = "#{Slido.base}/#{username}"

      response = Scout::Downloader.download(uri, with_response: true)

      uri = response.last_effective_url

      content   = Scout::Downloader.download("#{uri}/questions/load")
      questions = Slido::Questions::Parser.parse(content)

      content = Scout::Downloader.download("#{uri}/wall")
      event   = Slido::Wall::Parser.parse(content)

      category = Category.find_by slido_username: username

      SlidoEvent.create!(event.to_h)

      questions.each do |question|
        attributes = question.to_h.merge(category_id: category.id)

        Question.create!(attributes)
      end
    end
  end
end
