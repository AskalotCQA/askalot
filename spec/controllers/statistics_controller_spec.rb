require 'spec_helper'

describe University::StatisticsController do
  render_views

  let(:user) { create :teacher }

  describe 'GET index' do
    it 'succeeds' do
      sign_in user

      expect(response).to be_success
    end
  end
end
