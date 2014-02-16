# TODO (smolnar) use unique cookies

module Slido
  class Scraper
    def self.run(category, options = {})
      username = category.slido_username

      uri    = "#{Slido.config.base}/#{username}"
      params = Slido.config.to_h.slice(:cookies)

      response = Scout::Downloader.download(uri, params.deep_merge(with_response: true))

      uri = response.last_effective_url

      content   = Scout::Downloader.download("#{uri}/questions/load", params)
      questions = Slido::Questions::Parser.parse(content)

      content = Scout::Downloader.download("#{uri}/wall")
      event   = Slido::Wall::Parser.parse(content)

      attributes = event.to_h.merge(category_id: category.id)

      author = Core::Finder.find_user_by(login: :slido)
      event  = Core::Builder.create_slido_event_by(:uuid, attributes)

      event.update_attributes!(attributes)

      questions.each do |question|
        attributes = question.to_h.merge(category_id: category.id, author_id: author.id)

        question = Core::Builder.create_question_by(:slido_question_uuid, attributes)

        question.update_attributes!(attributes)
      end
    end
  end
end
