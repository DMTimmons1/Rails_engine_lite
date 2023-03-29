require 'rails_helper'

describe "Merchants API" do
  before do
    @merchant_1 = Merchant.create!(name: "Dawson")
    @merchant_2 = Merchant.create!(name: "Scott")
    @merchant_3 = Merchant.create!(name: "Cindy")
  end
  it "sends a list of merchants" do
    get '/api/v1/merchants'

    expect(response).to be_successful
    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(3)

    merchants[:data].each do |merchant|
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it 'can get one merchant by its id' do
    get "/api/v1/merchants/#{@merchant_1.id}"

    merchant = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful

    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
    expect(merchant[:data][:attributes][:name]).to eq("Dawson")
  end
end