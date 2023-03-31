require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
  end

  describe '::find_all_items_by_name' do
    it 'returns the merchant based off the search result' do
      @merchant_1 = Merchant.create!(name: "Dawson")

      @item_1 = Item.create!(name: "Wheat", description: "It's pretty dry", unit_price: 1.50, merchant_id: @merchant_1.id)
      @item_2 = Item.create!(name: "Gold", description: "Worth it's weight!", unit_price: 65.00, merchant_id: @merchant_1.id)
      @item_3 = Item.create!(name: "Basketball Hoop", description: "Sturdy for dunking!", unit_price: 100.00, merchant_id: @merchant_1.id)
      @item_4 = Item.create!(name: "Basketball", description: "Essential to play!", unit_price: 60.50, merchant_id: @merchant_1.id)

      expect(Item.find_all_items_by_name("Basket")).to eq([@item_3, @item_4])
    end
  end
end