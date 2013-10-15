class Events::Management
  attr_reader :request, :session, :user

  def initialize(attributes = {})
    @request = attributes.fetch :request
    @session = attributes[:session] || @request.session_options
    @user    = attributes[:user]
  end

  def log(data)
    data = data.clone

    fail if data[:action].blank?

    put_request data, request
    put_session data, session
    put_user    data, user

    #TODO (zbell) rm
    puts JSON.pretty_generate secure(data)

    Event.create! data: secure(data)
  end

  private

  def put_request(data, request)
    data.deep_merge! request: {
      fullpath: request.fullpath,
      ip: request.ip,
      method: request.method,
      media_type: request.media_type,
      query_parameters: request.query_parameters,
      remote_ip: request.remote_ip,
      original_fullpath: request.original_fullpath,
      original_url: request.original_url,
      uuid: request.uuid
    }
  end

  def put_session(data, session)
    data.deep_merge! session: {
      id: session[:id]
    }
  end

  def put_user(data, user)
    data.deep_merge! user: {
      id: user.id,
      login: user.login,
      email: user.email
    }
  end

  def secure(data, key = nil)
    return data.inject({}) { |h, (k, v)| h[k] = secure v, k; h } if data.is_a? Hash

    key.to_s =~ /password|token/i ? :__SECURED__ : data
  end
end
