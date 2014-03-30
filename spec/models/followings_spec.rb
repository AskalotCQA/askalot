require 'spec_helper'

describe Following do

  let(:follower) { create :user }
  let(:followee) { create :user }
  let(:following) { follower.followings.build(followee_id: followee.id) }

  subject { following }

  it { expect(following).to be_valid }

  describe "follower methods" do
    it { expect(following).to respond_to(:follower) }
    it { expect(following).to respond_to(:followee) }
    it { expect(following.follower).to eql follower }
    it { expect(following.followee).to eql followee }
  end

  describe "when followee id is not present" do
    before { following.followee_id = nil }
    it { expect(following).not_to be_valid }
  end

  describe "when follower id is not present" do
    before { following.follower_id = nil }
    it { expect(following).not_to be_valid }
  end
end
