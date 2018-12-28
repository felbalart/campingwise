FactoryBot.define do
  factory :payment do
    order { nil }
    amount { "9.99" }
    payed_at { "2018-12-27" }
    payment_method { "MyString" }
  end
end
