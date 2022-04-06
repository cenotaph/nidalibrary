# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Book, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:title) }

  end

  it 'has a valid factory' do
    u = FactoryBot.build(:book)
    expect(u.save).to be true
  end

  it 'is invalid without a title' do
    expect(FactoryBot.build(:book, title: nil).save).to be false
  end

  xit 'is invalid without a title' do
    expect(FactoryBot.build(:book, catno: nil).save).to be false
  end

end
