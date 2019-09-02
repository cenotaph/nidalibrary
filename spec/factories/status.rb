# frozen_string_literal: true

FactoryBot.define do
  factory :status do
    trait :on_shelf do
      name { 'On shelf' }
      colour { '#333333' }
    end
    trait :borrowed do 
      name { 'Borrowed' }
      colour { '#aaaacc' }
    end
    trait :missing do
      name { 'Missing' }
      colour { '#FF2222' }
    end
  end
end
    