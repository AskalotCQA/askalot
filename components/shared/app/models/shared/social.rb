module Shared
class Social
  include Squire::Base

  squire.source Rails.root.join('config', 'social.yml')

  squire.namespace Rails.env.to_sym, base: :defaults

  module ClassMethods
    def networks
      @networks ||= build enabled
    end

    def highlighted_networks
      @highlighted_networks ||= build highlighted
    end

    def suppressed_networks
      @suppressed_networks ||= build enabled - highlighted
    end

    private

    def build(networks)
      Hash[networks.map { |key|
        network            = send(key)
        network.key        = key
        network.pattern    = network.pattern? ? network.pattern : nil
        network.regexp     = regexp(network.pattern.presence || network.placeholder)

        [key, network]
      }]
    end

    def regexp(placeholder)
      s = placeholder.clone

      s.gsub!(/\A(https?\:\/\/)?(www.)?/, '')
      s.gsub!(/[\.\/]/) { |c| '\\' + c }
      s.gsub!('userid', '(?<userid>[0-9]+)')
      s.gsub!('username', '(?<username>[a-zA-Z0-9\.\_\-\?\=]+)')

      /\A(http|https)?\:\/\/?(www.)?#{s}\/?\z/
    end
  end

  extend ClassMethods
end
end
