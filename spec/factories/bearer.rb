FactoryBot.define do
  factory :bearer do
    name { Faker::Name.unique.name }
  end
end
