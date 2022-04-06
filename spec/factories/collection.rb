# frozen_string_literal: true

FactoryBot.define do
  factory :collection do
    name { Faker::Educator.subject }
    number {Faker::Number.number(digits: 3) }
    active { true }
  end
end