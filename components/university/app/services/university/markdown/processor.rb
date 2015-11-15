module University::Markdown
  module Processor
    extend self

    def process(text, user = nil, &callback)
      linker = Redcurtain::Renderer::Linker.new(:user)

      linker.render(text, regex: /(^|\s+)(@\w+)/, linker: lambda { |match|
        nick = match.gsub(/@/, '').strip
        user = User.find_by(nick: nick)

        if user
          callback.call(user) if callback

          "@#{user.id}"
        else
          match
        end
      })
    end

    def unprocess(text, user = nil, &callback)
      linker = Redcurtain::Renderer::Linker.new(:user)

      linker.render(text, regex: /(^|\s+)(@\d+)/, linker: lambda { |match|
        id   = match.gsub(/@/, '').strip
        user = User.find_by(id: id)

        if user
          callback.call(user) if callback

          "@#{user.nick}"
        else
          match
        end
      })
    end
  end
end
