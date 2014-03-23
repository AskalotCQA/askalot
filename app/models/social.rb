class Social
  include Squire::Base

  squire.source Rails.root.join('config', 'social.yml')

  squire.namespace Rails.env.to_sym, base: :defaults

  module ClassMethods
    def networks
      @networks ||= Hash[all.map { |key|
        network        = send(key)
        network.key    = key
        network.regexp = regexp(network.placeholder)

        [key, network]
      }]
    end

    def networks_show
      @networks_show ||= Hash[enabled.map { |key|
        network        = send(key)
        network.key    = key
        network.regexp = regexp(network.placeholder)

        [key, network]
      }]
    end

    def networks_hide
      @networks_hide ||= Hash[hide.map { |key|
        network        = send(key)
        network.key    = key
        network.regexp = regexp(network.placeholder)

        [key, network]
      }]
    end

    private

    def regexp(placeholder)
      s = placeholder.clone

      s.gsub!(/\A(https?\:\/\/)?(www.)?/, '')
      s.gsub!(/[\.\/]/) { |c| '\\' + c }
      s.gsub!('userid', '(?<userid>[0-9]+)')
      s.gsub!('username', '(?<username>[a-zA-Z0-9\.\_\-]+)')

      /\Ahttps?\:\/\/?(www.)?#{s}\/?\z/
    end
  end

  extend ClassMethods
end
