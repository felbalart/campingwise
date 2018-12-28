FactoryBot.define do
  factory :order do
    guest { nil }
    tag { "MyString" }
  end
end
