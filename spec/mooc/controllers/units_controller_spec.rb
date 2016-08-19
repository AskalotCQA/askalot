require 'spec_helper'

describe Mooc::UnitsController, type: :controller do
  let(:user) { create :user }

  routes { Mooc::Engine.routes }

  render_views

  before :each do
    @params = {
        context_uuid: 'default',
        context_id: '1',
        resource_link_id: '-category-hash',
        roles: 'student',
        user_id: '1000',
        lis_person_sourcedid: 'John Doe',
        lis_person_contact_email_primary: 'john.doe@example.com',
        lti_version: 'LTI-1p0',
        lti_message_type: 'basic-lti-launch-request'
    }
  end

  describe 'POST show' do
    it 'redirects to error page when consumer secret is not set' do
      post :show, @params

      expect(response).to redirect_to(units_error_path(exception: 'LTI consumer key not provided'))
    end

    it 'redirects to error page when consumer secret is not correct' do
      @params[:oauth_consumer_key] = 'key'

      post :show, @params

      expect(response).to redirect_to(units_error_path(exception: 'LTI secret does not match'))
    end

    it 'creates new category and context category if does not exist' do
      sign_in user

      before_count = Shared::Category.all.count

      @params[:context_id] = 'another-course-uuid'

      post :show, @params

      after_count = Shared::Category.all.count

      expect(after_count).to eql(before_count + 2)
      expect(Shared::Category.last.name).to eql('unknown')
    end

    it 'does not create new category and context if they already exist' do
      sign_in user

      post :show, @params

      before_count = Shared::Category.all.count

      post :show, @params

      after_count = Shared::Category.all.count

      expect(after_count).to eql(before_count)
    end
  end

  describe 'GET error' do
    it 'shows error page with descriptive error' do
      get :error, context_uuid: 'default', exception: 'LTI secret does not match'

      expect(response).to render_template('error')

      assert_select '#lti-error', html: 'LTI secret does not match'
    end
  end
end
