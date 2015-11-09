require 'spec_helper'

describe Stuba::User do
  let(:student_data) {
    {
      uisid: ['1234'],
      uid: ['xuser1'],
      cn: ['Bc. Janko Hraško'],
      sn: ['Hrasko'],
      givenname: ['Janko'],
      mail: ['xuser1@is.stuba.sk','xuser1@stuba.sk'],
      employeetype: ['student'],
      accountstatus: ['uis:active']
    }
  }
  let(:teacher_data) {
    {
      uisid: ['2234'],
      uid: ['xuser2'],
      cn: ['Bc. Janko Hraško'],
      sn: ['Hrasko'],
      givenname: ['Janko'],
      mail: ['xuser2@is.stuba.sk','xuser2@stuba.sk'],
      employeetype: ['staff'],
      accountstatus: ['uis:active']
    }
  }

  let(:researcher_data) {
    {
      uisid: ['3234'],
      uid: ['xuser3'],
      cn: ['Bc. Janko Hraško'],
      sn: ['Hrasko'],
      givenname: ['Janko'],
      mail: ['xuser3@is.stuba.sk','xuser3@stuba.sk'],
      employeetype: ['researcher'],
      accountstatus: ['uis:active']
    }
  }

  it 'provides user information' do
    user = Stuba::User.new(student_data)

    expect(user.uid).to       eql('1234')
    expect(user.login).to     eql('xuser1')
    expect(user.first).to     eql('Janko')
    expect(user.middle).to    be_nil
    expect(user.last).to      eql('Hraško')
    expect(user.email).to     eql('xuser1@stuba.sk')
    expect(user.role).to      eql(:student)
    expect(user.alumni?).to   eql(false)
  end

  it 'assigns correct role' do
    student    = Stuba::User.new(student_data)
    teacher    = Stuba::User.new(teacher_data)
    researcher = Stuba::User.new(researcher_data)

    expect(student.role).to    eql(:student)
    expect(teacher.role).to    eql(:teacher)
    expect(researcher.role).to eql(:student)
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
        employeetype: ['student'],
        accountstatus: ['uis:active']
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
      user = Stuba::User.new(student_data)

      expect(user.to_params).to eql({
        login: 'xuser1',
        email: 'xuser1@stuba.sk',
        name: 'Bc. Janko Hraško',
        first: 'Janko',
        middle: nil,
        last: 'Hraško',
        ais_login: 'xuser1',
        ais_uid: '1234',
        role: :student,
        alumni: false
      })
    end
  end
end
