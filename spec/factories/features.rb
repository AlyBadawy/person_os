FactoryBot.define do
  factory :feature do
    name { Faker::Lorem.word }
    metadata { {} }
  end
end
