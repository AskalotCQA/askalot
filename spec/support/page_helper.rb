module PageHelper
  def current_params
    params = {}

    # TODO (smolnar) use rails api to parse params
    URI.parse(current_url).query.split(/&/).each do |param|
      key, value = param.split('=')

      if key =~ /\A.*\[\]\z/
        key = key.sub(/\[\]/, '').to_sym

        params[key] ||= Array.new
        params[key] << value
      else
        params[key.to_sym] = value
      end
    end

    params
  end
end
