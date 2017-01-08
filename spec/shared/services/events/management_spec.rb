require 'spec_helper'

# TODO (smolnar) Refactor, move persistance to Event spec

describe Shared::Events::Management do
  describe '#log' do
    let(:management) { Shared::Events::Management.new }

    let(:request) do
      double :request, {
        fullpath: "/users/xuser",
        ip: "127.0.0.1",
        method: "GET",
        media_type: "",
        remote_ip: "127.0.0.1",
        original_fullpath: "/users/xuser",
        original_url: "http://localhost:3000/users/xuser",
        uuid: "7d37da54-dd58-4126-b879-c15709cc3aae",
        session_options: {
          path: "/",
          domain: nil,
          expire_after: nil,
          secure: false,
          httponly: true,
          defer: false,
          renew: false,
          id: "3e1a905ab3b7e5985d31badc40ca61dc"
        }
      }
    end

    let(:params) do
      {
        utf8: "✓",
        authenticity_token: "3e1a905ab3b7e5985d31badc40ca61dc",
        user: {
          login: "xuser",
          password: "12345678",
          remember_me: "0"
        },
        action: "create",
        controller: "sessions"
      }
    end

    let(:user) do
      double :user, {
        id: 1,
        login: 'xuser',
        email: 'xuser@gmail.com'
      }
    end

    it 'creates event' do
      data  = { action: 'hello', snapshot: { request: request, params: params }}
      event = management.log data

      expect(event.data[:action]).to eql 'hello'
      expect(event.data[:request][:method]).to eql request.method
      expect(event.data[:session][:id]).to eql request.session_options[:id]
      expect(event.data[:params][:controller]).to eql params[:controller]
    end

    it 'creates event with snapshot user' do
      data  = { action: 'hello', snapshot: { request: request, params: params, user: user }}
      event = management.log data

      expect(event.data[:user][:id]).to eql user.id
    end

    it 'creates event with custom user' do
      data  = { action: 'hello', user: { key: 'hello' }, snapshot: { request: request, params: params, user: user }}
      event = management.log data

      expect(event.data[:user][:key]).to eql 'hello'
    end

    it 'fails on missing action' do
      data = { snapshot: { request: request, params: params }}

      expect { management.log(data) }.to raise_error(RuntimeError)
    end

    it 'fails on missing snapshot request or params' do
      expect { management.log({ action: 'hello' }) }.to raise_error(NoMethodError)
      expect { management.log({ action: 'hello', snapshot: { request: request }}) }.to raise_error(KeyError)
      expect { management.log({ action: 'hello', snapshot: { params:  params  }}) }.to raise_error(KeyError)
    end

    it 'fails on custom user but no snapshot user' do
      expect { management.log({ action: 'hello', user: {}, snapshot: { request: request, params: params }}) }.to raise_error(RuntimeError)
    end

    it 'secures passwords and tokens' do
      data  = { action: 'hello', snapshot: { request: request, params: params }}
      event = management.log data

      expect(event.data[:params][:authenticity_token]).to eql :__SECURED__.to_s
      expect(event.data[:params][:user][:password]).to eql :__SECURED__.to_s
    end
  end
end
