require 'spec_helper'

describe 'LTI request communication', type: :request do
  before :each do
    @tc = IMS::LTI::ToolConsumer.new('key', 'secret')
    @tc.launch_url = 'http://localhost/edx/default/units'
    @tc.resource_link_id = '-category-hash'
    @tc.context_id = 'course/some/thing'
    @tc.roles = 'student'
    @tc.user_id = '2db5624923723eff13eb4cc2d0d24938'
    @tc.lis_person_sourcedid = 'JohnDoe'
    @tc.lis_person_contact_email_primary = 'john.doe@example.com'
    @tc.lti_message_type = 'basic-lti-launch-request'

    @params = @tc.generate_launch_data

    IMS::LTI::ToolProvider.any_instance.stub(:valid_request?).and_return(true)
    IMS::LTI::ToolProvider.any_instance.stub(:request_oauth_timestamp).and_return(Time.now.utc)
  end

  it 'creates new category and context category if does not exist' do
    before_count = Shared::Category.all.count

    post '/default/units', @params

    after_count = Shared::Category.all.count

    expect(after_count).to eql(before_count + 2)
    expect(Shared::Category.last.name).to eql('unknown')
  end

  it 'creates user account and context assignment' do
    before_count = Shared::User.all.count

    post '/default/units', @params

    after_count = Shared::User.all.count

    expect(after_count).to eql(before_count + 1)
    expect(Shared::User.last.nick).to eql('JohnDoe')
    expect(Shared::ContextUser.last.user).to eql(Shared::User.last)
  end

  it 'creates user account and assignment if user is instructor' do
    @params['roles'] = 'Instructor'

    post '/default/units', @params

    expect(Shared::User.last.assignments.first.role.name).to eql('teacher')
  end

  it 'creates user account and assignment if user is TA' do
    @params['roles'] = 'Administrator'

    post '/default/units', @params

    expect(Shared::User.last.assignments.first.role.name).to eql('teacher_assistant')
  end

  it 'creates new category as not visible if user is instructor' do
    @params['roles'] = 'Instructor'

    post '/default/units', @params

    expect(Shared::Category.last.visible).to eql(false)
  end

  it 'creates new category as not visible if user is TA' do
    @params['roles'] = 'Administrator'

    post '/default/units', @params

    expect(Shared::Category.last.visible).to eql(false)
  end

  it 'creates new category as visible if user is student' do
    post '/default/units', @params

    expect(Shared::Category.last.visible).to eql(true)
  end

  context 'with unit view correctly setup' do
    before :each do
      post '/default/units', @params

      # simulate successful setup by public JS
      Shared::Context::Manager.context_category.update(askalot_page_url: 'correctly set up url')
      Shared::Category.last.update(name: 'Parsed Name', uuid: 'parsed_uuid')
    end

    it 'does not create new category and context category if does not exist' do
      before_count = Shared::Category.all.count

      post '/default/units', @params

      after_count = Shared::Category.all.count

      expect(after_count).to eql(before_count)
    end

    it 'stores activity about visited unit' do
      expect(Shared::List.count).to eql(1)
      expect(Shared::List.last.unit_view).to eql(true)
      expect(Shared::Category.last.lists_count).to eql(1)
    end

    context 'with already registered user' do
      before :each do
        @params['roles'] = 'Administrator'

        post '/default/units', @params
      end

      it 'reflects changes in user roles' do
        expect(Shared::User.last.assignments.first.role.name).to eql('teacher_assistant')
        expect(Shared::User.last.assignments.count).to eql(2)

        @params['roles'] = 'Instructor'

        post '/default/units', @params

        expect(Shared::User.last.assignments.first.role.name).to eql('teacher')
        expect(Shared::User.last.assignments.count).to eql(2)
      end
    end
  end

  context 'with unit view setup by teaacher' do
    before :each do
      @params['roles'] = 'Instructor'

      post '/default/units', @params

      # simulate successful setup by public JS
      Shared::Context::Manager.context_category.update(askalot_page_url: 'correctly set up url')
      Shared::Category.last.update(name: 'Parsed Name', uuid: 'parsed_uuid')

      logout(:user)
    end

    it 'updates category visiblity when student arrives' do
      expect(Shared::Category.last.visible).to eql(false)

      @params['roles'] = 'student'
      @params['user_id'] = 'abcde'
      @params['lis_person_sourcedid'] = 'JaneDoe'
      @params['lis_person_contact_email_primary'] = 'jane.doe@example.com'

      post '/default/units', @params

      expect(Shared::Category.last.visible).to eql(true)
    end
  end
end
