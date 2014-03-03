module Markdown
  module Processor
    extend self

    def process(text, user, &callback)
      linker = Redcurtain::Renderer::Linker.new(:user)

      # TODO (smolnar) resolve why do end doesnt work
      linker.render text, regex: /(^|\s+)(@\w+)/, linker: lambda { |match|
        nick = match.gsub(/@/, '').strip

        user = User.find_by(nick: nick)

        callback.call(user)

        "@#{user.id}"
      }
    end
  end
end
