# frozen_string_literal: true

FactoryBot.define do
  factory :section do
    name { Faker::Book.genre }
    colour { "#%06x" % (rand * 0xffffff) }
  end
end
    