FactoryBot.define do
  factory :shared_context_user, :class => 'Shared::ContextUser' do
    association :user
  end
end
