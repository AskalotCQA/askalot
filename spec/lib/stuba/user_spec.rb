require 'spec_helper'

describe Stuba::User do
  let(:data) {
    {
      uisid: ['1234'],
      uid: ['xuser1'],
      cn: ['Bc. Janko Hrasko'],
      sn: ['Hrasko'],
      givenname: ['Janko'],
      mail: ['xuser1@is.stuba.sk','xuser1@stuba.sk']
    }
  }

  it 'provides user information' do
    user = Stuba::User.new(data)

    expect(user.uid).to eql('1234')
    expect(user.login).to eql('xuser1')
    expect(user.name).to eql('Bc. Janko Hrasko')
    expect(user.first).to eql('Janko')
    expect(user.middle).to eql(nil)
    expect(user.last).to eql('Hrasko')
    expect(user.email).to eql('xuser1@stuba.sk')
  end

  describe '.to_params' do
    it 'converts user to params' do
      user = Stuba::User.new(data)

      expect(user.to_params).to eql({
        login: 'xuser1',
        email: 'xuser1@stuba.sk',
        name: 'Bc. Janko Hrasko',
        first: 'Janko',
        middle: nil,
        last: 'Hrasko',
        ais_login: 'xuser1',
        ais_uid: '1234'
      })
    end
  end
end
