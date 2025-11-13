FactoryBot.define do
  factory :eventable_type do
    name { Faker::FunnyName.name }
    metadata { {} }
  end
end
