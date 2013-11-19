class Social
  include Squire::Base

  squire.source Rails.root.join('config', 'social.yml')

  squire.namespace Rails.env.to_sym, base: :defaults

  def self.networks
    @networks ||= Hash[enabled.map { |key|
      network        = send(key)
      network.key    = key
      network.regexp = regexp(network.placeholder)

      [key, network]
    }]
  end

  def self.regexp(placeholder)
    s = placeholder.clone

    s.gsub!(/\A(https?:\/\/)?(www.)?/, '')
    s.gsub!(/[\.\/]/) { |c| '\\' + c }
    s.gsub!('userid', '[0-9]+')
    s.gsub!('username', '[a-zA-Z0-9\.\_\-]+')

    /\A(https?\:\/\/)?(www.)?#{s}\/?\z/
  end
end
