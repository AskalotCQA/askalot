module Markdown
  module Processor
    extend self

    def process(text, user = nil, &callback)
      linker = Redcurtain::Renderer::Linker.new(:user)

      linker.render(text, regex: /(^|\s+)(@\w+)/, linker: lambda { |match|
        nick = match.gsub(/@/, '').strip
        user = User.find_by(nick: nick)

        callback.call(user) if callback

        "@#{user.id}"
      })
    end
  end
end
