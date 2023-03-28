require 'rails_helper'

describe "Merchants API" do
  before do
    Merchant.create!(name: "Dawson")
    Merchant.create!(name: "Scott")
    Merchant.create!(name: "Cindy")
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

  end
end