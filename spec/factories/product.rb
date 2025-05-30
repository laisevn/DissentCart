require 'faker'

FactoryBot.define do
  factory :product do
    name { Faker::Lorem.word }
    quantity { Faker::Number.within(range: 1..10) }
    unit_price { Faker::Number.number(digits: 2) }
    total_price { quantity * unit_price }
    product_id { Faker::Number.unique.between(from: 1, to: 999) }

    association :cart

    after(:build) do |product|
      product.total_price = product.quantity * product.unit_price if product.attributes.key?('total_price')
    end
  end
end
