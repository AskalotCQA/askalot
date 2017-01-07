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
      lis_person_sourcedid: 'JohnDoe',
      lis_person_contact_email_primary: 'john.doe@example.com',
      lti_version: 'LTI-1p0',
      lti_message_type: 'basic-lti-launch-request',
      oauth_consumer_key: 'key'
    }
  end

  describe 'POST show' do
    context 'with invalid LTI request' do
      it 'redirects to error page when consumer secret is not set' do
        @params.delete(:oauth_consumer_key)

        post :show, @params

        expect(response).to redirect_to(units_error_path(exception: 'LTI consumer key not provided'))
      end

      it 'redirects to error page when consumer secret is not correct' do
        @params[:oauth_consumer_key] = 'incorrect'

        post :show, @params

        expect(response).to redirect_to(units_error_path(exception: 'LTI secret does not match'))
      end

      it 'redirects to error page when request is not valid' do
        allow_any_instance_of(IMS::LTI::ToolProvider).to receive(:valid_request?).and_return(false)

        post :show, @params

        expect(response).to redirect_to(units_error_path(exception: 'LTI request is not valid'))
      end
    end

    context 'with valid LTI request' do
      before :each do
        allow_any_instance_of(IMS::LTI::ToolProvider).to receive(:valid_request?).and_return(true)
      end

      it 'redirects to error page when request is too old' do
        allow_any_instance_of(IMS::LTI::ToolProvider).to receive(:request_oauth_timestamp).and_return(0)

        post :show, @params

        expect(response).to redirect_to(units_error_path(exception: 'LTI request is too old'))
      end

      it 'redirects to error page when unit is not parsed' do
        allow_any_instance_of(IMS::LTI::ToolProvider).to receive(:request_oauth_timestamp).and_return(Time.now.utc)

        post :show, @params

        expect(response).to redirect_to(units_error_path(exception: "Nastavenie Askalotu v tomto unite ešte nebolo dokončené. Pokračujte obnovením aktuálnej stránky. Ak sa vám stále zobrazuje tento text, pravdepodobne ste zle nastavili Askalot (možno ste zabudli pridať 'raw html' komponent okrem LTI komponentu Askalotu?)"))
      end

      it 'redirects to error page if user data are not provided' do
        allow_any_instance_of(IMS::LTI::ToolProvider).to receive(:request_oauth_timestamp).and_return(Time.now.utc)

        @params.delete(:lis_person_sourcedid)
        @params.delete(:lis_person_contact_email_primary)

        post :show, @params

        expect(response).to redirect_to(units_error_path(exception: "Váš používateľský účet ešte nebol zaregistrovaný a informácie o používateľovi nie sú dostuné v tejto požiadavke na zobrazenie stránky (pravdedpodobne pristupujete po prvý krát k Askalotu z Unit pohľadu v edX štúdiu). Prosím, navštívte Unit priamo z edX kurzu, aby Vám bol automaticky vytvorený účet."))
      end
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
