# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.first_name + ' ' +   Faker::Name.last_name }
    email { Faker::Internet.email }
    password { 'test_password' }
    trait :image do
      image { File.new(File.join(::Rails.root.to_s, 'spec/fixtures/images/gaddis.jpg')) }
    end
  end
end
