module Shared::Events
  class Management
    def log(data)
      data     = data.clone
      snapshot = data.delete :snapshot

      fail if data[:action].blank?

      request = snapshot.fetch :request
      session = request.session_options.to_hash
      params  = snapshot.fetch :params
      user    = snapshot[:user]

      put_request(data, request)
      put_session(data, session)
      put_params(data, params)

      if user
        put_user(data, user)
      else
        fail if data[:user]
      end

      Shared::Event.create! data: secure(data)
    end

    private

    def put_request(hash, request)
      hash[:request] = {
        fullpath: request.fullpath,
        ip: request.ip,
        method: request.method,
        media_type: request.media_type,
        remote_ip: request.remote_ip,
        original_fullpath: request.original_fullpath,
        original_url: request.original_url,
        uuid: request.uuid
      }
    end

    def put_session(hash, session)
      hash[:session] = session
    end

    def put_params(hash, params)
      hash[:params] = params.clone
      hash[:params][:content] = '[removed]' if hash[:action] == 'mooc/parser.parser' && !params[:content].nil?
    end

    def put_user(hash, user)
      hash.deep_merge! user: {
        id: user.id,
        login: user.login,
        email: user.email
      }
    end

    def secure(value, key = nil)
      return value.inject({}) { |h, (k, v)| h[k] = secure v, k; h } if value.is_a? Hash

      key.to_s =~ /password|token/i ? :__SECURED__ : value
    end
  end
end
