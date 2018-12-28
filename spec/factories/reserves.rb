FactoryBot.define do
  factory :reserf, class: 'Reserve' do
    order { nil }
    site { nil }
    start_date { "2018-12-27" }
    end_date { "2018-12-27" }
    status { "MyString" }
  end
end
