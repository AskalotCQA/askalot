require 'spec_helper'

describe Stuba::User do
  let(:data) {
    {
      uisid: ['1234'],
      uid: ['xuser1'],
      cn: ['Bc. Janko Hraško'],
      sn: ['Hrasko'],
      givenname: ['Janko'],
      mail: ['xuser1@is.stuba.sk','xuser1@stuba.sk'],
      employeetype: ['student']
    }
  }

  it 'provides user information' do
    user = Stuba::User.new(data)

    expect(user.uid).to eql('1234')
    expect(user.login).to eql('xuser1')
    expect(user.first).to eql('Janko')
    expect(user.middle).to be_nil
    expect(user.last).to eql('Hraško')
    expect(user.email).to eql('xuser1@stuba.sk')
    expect(user.role).to eql(:student)
  end

  context 'when user has middle name' do
    let(:data) {
      {
        uisid: ['1234'],
        uid: ['xuser1'],
        cn: ['Bc. Janko Johny Hraško'],
        sn: ['Hrasko'],
        givenname: ['Janko'],
        mail: ['xuser1@is.stuba.sk','xuser1@stuba.sk'],
        employeetype: ['student']
      }
    }

    it 'parses middle name correctly' do
      user = Stuba::User.new(data)

      expect(user.uid).to    eql('1234')
      expect(user.login).to  eql('xuser1')
      expect(user.name).to   eql('Bc. Janko Johny Hraško')
      expect(user.first).to  eql('Janko')
      expect(user.middle).to eql('Johny')
      expect(user.last).to   eql('Hraško')
      expect(user.email).to  eql('xuser1@stuba.sk')
      expect(user.role).to   eql(:student)
    end
  end

  describe '.to_params' do
    it 'converts user to params' do
      user = Stuba::User.new(data)

      expect(user.to_params).to eql({
        login: 'xuser1',
        email: 'xuser1@stuba.sk',
        name: 'Bc. Janko Hraško',
        first: 'Janko',
        middle: nil,
        last: 'Hraško',
        ais_login: 'xuser1',
        ais_uid: '1234',
        role: :student
      })
    end
  end
end
