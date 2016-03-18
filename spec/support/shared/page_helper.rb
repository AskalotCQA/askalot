module Shared::PageHelper
  def current_params
    params = Hash.new
    uri    = URI.parse(current_url)
    query  = CGI.parse(uri.query)

    query.each do |key, value|
      params[key.to_sym] = URI.decode(value.first)
    end

    params
  end
end
