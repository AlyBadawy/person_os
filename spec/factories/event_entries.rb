FactoryBot.define do
  factory :event_entry do
    eventables
    occured_at { Time.current }
    metadata { {} }
  end
end
