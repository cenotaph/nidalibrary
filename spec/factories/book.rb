# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    isbn10 { (rand * 10000000000 ).to_i.to_s }
    isbn13 { (rand * 10000000000000 ).to_i.to_s}
    title { Faker::Book.title }
    author { Faker::Book.author }
    publisher { Faker::Book.publisher }
    language { ['LT', 'EN', 'LV', 'LT/EN'].sample }
    catno { SecureRandom.alphanumeric(30).gsub(/\d/, '').upcase[0..3] + (rand * 1000).to_i.to_s }
    association :section
    association :status, :on_shelf
  end
end