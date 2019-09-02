# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:password) }
  end

  it 'has a valid factory' do
    u = FactoryBot.build(:user, password: 'rand23423om')
    expect(u.save).to be true
  end

  it 'should be able to upload avatar' do
    user = FactoryBot.create(:user, :image)
    expect(user.image_url).not_to be nil
  end

  it 'is invalid without a name' do
    expect(FactoryBot.build(:user, name: nil).save).to be false
  end

  it 'is invalid without a unique email' do
    user = FactoryBot.create(:user, password: 'random23423')
    expect(FactoryBot.build(:user, email: user.email).save).to be false
  end

  it 'is invalid without an email' do
    expect(FactoryBot.build(:user, email: nil).save).to be false
  end

end
