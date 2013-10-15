require 'spec_helper'

describe Events::Management do
  describe '#log' do
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
      double :params, {
        controller: "users",
        action: "show",
        login: "xuser"
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
      management = Events::Management.new request: request, params: params, user: user
      event      = management.log({ action: 'hello' })

      expect(event.data[:action]).to eql 'hello'
    end

    it 'fails on missing action' do
      management = Events::Management.new request: request, params: params, user: user

      expect { management.log({}) }.to raise_error RuntimeError
    end

    it 'secures passwords and tokens' do
      pending
    end
  end
end
