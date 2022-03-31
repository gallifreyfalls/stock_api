FactoryBot.define do
  factory :stock do
    name { Faker::Name.unique.name }
    bearer { create(:bearer) }
  end
end
