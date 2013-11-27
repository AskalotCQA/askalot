require 'spec_helper'

describe 'Label Answer' do
  let(:user) { create :user }
  let!(:question) { create :question }

  before :each do
    login_as user
  end

  pending 'TODO'

  #context 'when user is not a label author' do
  #  it 'labels the answer', js: true do
  #  end
  #end
  #
  #context 'when user already a label author' do
  #  before :each do
  #    answer.toggle_labeling_by! user, :helpful
  #  end
  #
  #  it 'unfavors the answer', js: true do
  #  end
  #end
end
