FactoryBot.define do
  factory :invoice do
    order { nil }
    category { "MyString" }
    number { "MyString" }
    amount { "9.99" }
  end
end
