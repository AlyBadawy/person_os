FactoryBot.define do
  factory :event_entry do
    eventable
    user
    occurred_at { Time.current }
    metadata { {} }
  end
end
