FactoryBot.define do
  factory :eventable do
    user
    eventable_type
    name { Faker::Lorem.sentence }
    schedule { {} }
    starts_on { Date.current }
    ends_on { Date.current + 4.months }
    metadata { {} }
  end
end
