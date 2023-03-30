require 'rails_helper'

describe "Items API" do
  before do
    @merchant_1 = Merchant.create!(name: "Dawson")
    @merchant_2 = Merchant.create!(name: "Scott")

    @item_1 = Item.create!(name: "Wheat", description: "It's pretty dry", unit_price: 1.50, merchant_id: @merchant_1.id)
    @item_2 = Item.create!(name: "Gold", description: "Worth it's weight!", unit_price: 65.00, merchant_id: @merchant_1.id)
    @item_3 = Item.create!(name: "Basketball Hoop", description: "Sturdy for dunking!", unit_price: 100.00, merchant_id: @merchant_1.id)
  end
  describe 'get requests' do
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

    it 'returns the mechant associated with the item' do
      get "/api/v1/items/#{@item_1.id}/merchant"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id]).to be_a(String)
      expect(merchant[:data][:id]).to eq("#{@merchant_1.id}")

      expect(merchant[:data]).to have_key(:type)
      expect(merchant[:data][:type]).to be_a(String)
      expect(merchant[:data][:type]).to eq("merchant")
      
      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to be_a(String)
      expect(merchant[:data][:attributes][:name]).to eq("#{@merchant_1.name}")
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
      it 'does not create an item with invalid param inputs' do
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
  end

  describe 'Delete requests' do
    it 'deletes an existing item' do
      delete "/api/v1/items/#{@item_2.id}"

      expect(response).to be_no_content
    end
  end

  describe 'update requests' do
    context 'happy path' do
      it 'updates an existing item' do
        patch "/api/v1/items/#{@item_2.id}", params: {
          item: {
            name: "Water",
            description: "it's wet, or is it?",
            unit_price: 1.23,
            merchant_id: "#{@merchant_2.id}"
          }
        }
        expect(response).to be_successful

        item = JSON.parse(response.body, symbolize_names: true)
        
        expect(item[:data][:attributes]).to have_key(:name)
        expect(item[:data][:attributes][:name]).to be_a(String)
        expect(item[:data][:attributes][:name]).to eq("Water")

        expect(item[:data][:attributes]).to have_key(:description)
        expect(item[:data][:attributes][:description]).to be_a(String)
        expect(item[:data][:attributes][:description]).to eq("it's wet, or is it?")

        expect(item[:data][:attributes]).to have_key(:unit_price)
        expect(item[:data][:attributes][:unit_price]).to be_a(Float)
        expect(item[:data][:attributes][:unit_price]).to eq(1.23)

        expect(item[:data][:attributes]).to have_key(:merchant_id)
        expect(item[:data][:attributes][:merchant_id]).to be_an(Integer)
        expect(item[:data][:attributes][:merchant_id]).to eq(@merchant_2.id)
      end
    end

    context 'sad path' do
      it 'does not update the existing item with invalid param inputs' do
        patch "/api/v1/items/#{@item_2.id}", params: {
          item: {
            name: '',
            description: '',
            unit_price: '',
            merchant_id: ''
          }
        }
        expect(response).to be_bad_request
      end
    end
  end
end