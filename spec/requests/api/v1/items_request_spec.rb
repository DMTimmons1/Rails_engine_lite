require 'rails_helper'

describe "Items API" do
  before do
    @merchant_1 = Merchant.create!(name: "Dawson")

    @item_1 = Item.create!(name: "Wheat", description: "It's pretty dry", unit_price: 1.50, merchant_id: @merchant_1.id)
    @item_2 = Item.create!(name: "Gold", description: "Worth it's weight!", unit_price: 65.00, merchant_id: @merchant_1.id)
    @item_3 = Item.create!(name: "Basketball Hoop", description: "Sturdy for dunking!", unit_price: 100.00, merchant_id: @merchant_1.id)
  end
  context 'get requests' do
    it "sends a list of items" do
      get '/api/v1/items'

      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(3)

      items[:data].each do |item|
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
      end
    end

    it 'sends one item by its id' do
      get "/api/v1/items/#{@item_1.id}"

      expect(response).to be_successful
      item = JSON.parse(response.body, symbolize_names: true)
      
      expect(item[:data][:attributes]).to have_key(:name)
      expect(item[:data][:attributes][:name]).to be_a(String)
      expect(item[:data][:attributes][:name]).to eq("Wheat")

      expect(item[:data][:attributes]).to have_key(:description)
      expect(item[:data][:attributes][:description]).to be_a(String)
      expect(item[:data][:attributes][:description]).to eq("It's pretty dry")

      expect(item[:data][:attributes]).to have_key(:unit_price)
      expect(item[:data][:attributes][:unit_price]).to be_a(Float)
      expect(item[:data][:attributes][:unit_price]).to eq(1.50)

      expect(item[:data][:attributes]).to have_key(:merchant_id)
      expect(item[:data][:attributes][:merchant_id]).to be_an(Integer)
      expect(item[:data][:attributes][:merchant_id]).to eq(@merchant_1.id)

    end
  end
  describe 'post requests' do 
    context 'happy path' do
      it 'creates a new item' do
        post '/api/v1/items', params: {
            item: {
              name: "Wheat",
              description: "It's pretty dry",
              unit_price: 1.50,
              merchant_id: @merchant_1.id
            }
          }
        expect(response).to be_created
        item = JSON.parse(response.body, symbolize_names: true)
        
        expect(item[:data][:attributes]).to have_key(:name)
        expect(item[:data][:attributes][:name]).to be_a(String)
        expect(item[:data][:attributes][:name]).to eq("Wheat")

        expect(item[:data][:attributes]).to have_key(:description)
        expect(item[:data][:attributes][:description]).to be_a(String)
        expect(item[:data][:attributes][:description]).to eq("It's pretty dry")

        expect(item[:data][:attributes]).to have_key(:unit_price)
        expect(item[:data][:attributes][:unit_price]).to be_a(Float)
        expect(item[:data][:attributes][:unit_price]).to eq(1.50)

        expect(item[:data][:attributes]).to have_key(:merchant_id)
        expect(item[:data][:attributes][:merchant_id]).to be_an(Integer)
        expect(item[:data][:attributes][:merchant_id]).to eq(@merchant_1.id)
      end
    end

    context 'sad path' do
      it 'does not create an item with invalid params' do
        post '/api/v1/items', params: {
          item: {
            name: '',
            description: '',
            unit_price: '',
            merchant_id: ''
          }
        }
        expect(response).to be_unprocessable
      end
    end

    context 'Delete requests' do
      it 'deletes an existing item' do
        delete "/api/v1/items/#{@item_2.id}"

        expect(response).to be_no_content
      end
    end
  end
end