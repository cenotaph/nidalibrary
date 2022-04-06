# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  it 'has a valid factory' do
    u = FactoryBot.build(:collection)
    expect(u.save).to be true
  end

   it 'is invalid without a name' do
    expect(FactoryBot.build(:collection, name: nil).save).to be false
  end

end
