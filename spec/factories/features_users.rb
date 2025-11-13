FactoryBot.define do
  factory :features_user do
    user
    feature
    quota { 1 }
  end
end
