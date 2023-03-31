require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items }
  end

  describe '::find_merchant' do
    it 'returns the merchant based off the search result' do
      @merchant_1 = Merchant.create!(name: "Dawson")
      @merchant_2 = Merchant.create!(name: "Scott")
      @merchant_3 = Merchant.create!(name: "Cindy")

      expect(Merchant.find_merchant_by_name(@merchant_1.name)).to eq(@merchant_1)
    end
  end
end
